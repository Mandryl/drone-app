//
//  MediaFileFetcher.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/15.
//

import SwiftUI
import DJISDK
import Amplify
import Combine

final class MediaFileFetcher: ObservableObject {
  let mediaManager: DJIMediaManager?
  @Published var mediaFileList: [MediaFile]
  
  var progressCancellable: AnyCancellable? = nil
  var resultCancellable: AnyCancellable? = nil
  var apiCancellable: AnyCancellable? = nil
  
  init(mediaFileList: [MediaFile] = []) {
    self.mediaManager = fetchCamera()?.mediaManager
    self.mediaFileList = mediaFileList
  }
  
  func loadMediaList() {
    guard let _ = fetchCamera() else {
      print("Camera is unavailable")
      return
    }
    
    guard let mediaManager = self.mediaManager else {
      print("Media Manager is unavailable")
      return
    }
    
    guard mediaManager.sdCardFileListState != .syncing && mediaManager.sdCardFileListState != .deleting else {
      print("Media Manager is busy")
      return
    }
    
    mediaManager.refreshFileList(of: .sdCard) { error in
      if let e = error {
        print("Error: \(e)")
      } else {
        print("Fetch Media File List Success")
        if let mediaFileList = mediaManager.sdCardFileListSnapshot() {
          self.mediaFileList = mediaFileList.map { MediaFile(fileName: $0.fileName, thumbnail: $0.thumbnail, mediaFile: $0) }
          self.updateMediaList()
        } else {
          self.mediaFileList = []
        }
      }
    }
  }
  
  func updateMediaList() {
    guard let _ = fetchCamera() else {
      NSLog("Camera is unavailable")
      return
    }
    
    guard let scheduler = fetchCamera()?.mediaManager?.taskScheduler else {
      NSLog("Camera or Media Manager is unavailable")
      return
    }
    
    scheduler.suspendAfterSingleFetchTaskFailure = false
    scheduler.resume(completion: nil)
    
    for file in self.mediaFileList {
      if file.mediaFile.thumbnail == nil {
        let task = DJIFetchMediaTask(file: file.mediaFile, content: .thumbnail) { updatedFile, content, error in
          if let e = error {
            NSLog("Error: \(e)")
          } else {
            if let index = self.mediaFileList.firstIndex(of: file) {
              self.mediaFileList.remove(at: index)
              self.mediaFileList.append(MediaFile(fileName: updatedFile.fileName, thumbnail: updatedFile.thumbnail, mediaFile: updatedFile))
            }
          }
        }
        scheduler.moveTask(toEnd: task)
      }
    }
  }
  
  func downloadAndSendMedia(mediaFile: MediaFile) -> AnyPublisher<Data, MediaFetchError> {
    Deferred {
      Future { promise in
        var fileData = Data()
        var previousOffset = 0
        var progress: Float = 0
        
        guard mediaFile.mediaFile.mediaType == .JPEG else {
          promise(.failure(.init(errorMessage: "Invalid media type: \(mediaFile.mediaFile.mediaType)")))
          return
        }
        
        mediaFile.mediaFile.fetchData(withOffset: UInt(previousOffset), update: DispatchQueue.main) { data, completed, error in
          if let e = error {
            print("Fetch data failed: \(e)")
            promise(.failure(.init(errorMessage: "Fetch data failed")))
            return
          }
          
          guard let d = data else {
            print("Fetch data failed: data is nil")
            promise(.failure(.init(errorMessage: "Fetch data failed")))
            return
          }
          
          fileData.append(d)
          previousOffset += d.count
          progress = Float(previousOffset) * 100.0 / Float(mediaFile.mediaFile.fileSizeInBytes)
          print("Downloading: \(progress)")
          
          if previousOffset == mediaFile.mediaFile.fileSizeInBytes && completed {
            print("Download completed")
            promise(.success(fileData))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  // invoke aggregate api after put object to s3 in iOS app
  func sendMediaFile(data: Data) -> AnyPublisher<String, MediaFetchError> {
    Deferred {
      Future { promise in
        let key = "\(UUID()).jpg"
        let storageOperation = Amplify.Storage.uploadData(key: key, data: data)
        self.progressCancellable = storageOperation.progressPublisher.sink { progress in
          print("Uploading: \(progress)")
        }
        self.resultCancellable = storageOperation.resultPublisher.sink {
          if case let .failure(storageError) = $0 {
            print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            promise(.failure(.init(errorMessage: "Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")))
          }
        }
        receiveValue: { data in
          print("Upload completed")
          promise(.success(key))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  func createIncidentsFromRawImages(dataList: [Data], region: String) -> AnyPublisher<Void, MediaFetchError> {
    Deferred {
      Future { promise in
        print("START createIncidents")
        let base64Images: [String] = dataList.map { $0.base64EncodedString() }
        self.apiCancellable = IncidentsAPI.createIncidentsRawIncidentsPost(
          rawIncident: RawIncident(images: base64Images, region: region),
          apiResponseQueue: DispatchQueue.main
        )
        .mapError { MediaFetchError(errorMessage: "API Error: \($0.localizedDescription)") }
        .sink {
          if case let .failure(error) = $0 {
            print("PostRawIncidents failed")
            promise(.failure(error))
          }
        }
        receiveValue: {
          print("PostRawIncidents succeeded")
          promise(.success(Void()))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func createIncidents(fileName: String, region: String) -> AnyPublisher<Void, MediaFetchError> {
    Deferred {
      Future { promise in
        let storageOperation = Amplify.Storage.getURL(key: fileName)
        self.apiCancellable = storageOperation.resultPublisher
          .mapError { MediaFetchError(errorMessage: $0.errorDescription) }
          .flatMap {
            DefaultAPI.postIncidents(
              postIncidentsRequest: PostIncidentsRequest(imageUrl: $0.absoluteString, region: region),
              apiResponseQueue: DispatchQueue.main
            )
            .mapError { MediaFetchError(errorMessage: "API Error: \($0.localizedDescription)") }
          }
          .sink {
            if case let .failure(error) = $0 {
              print("PostIncidents failed")
              promise(.failure(error))
            }
          }
          receiveValue: {
            print("PostIncidents succeeded")
            promise(.success(Void()))
          }
      }
    }
    .eraseToAnyPublisher()
  }
}

struct MediaFetchError: Error {
  let errorMessage: String
}
