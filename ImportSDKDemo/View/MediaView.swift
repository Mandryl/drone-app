//
//  MediaView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/14.
//

import SwiftUI
import DJISDK
import Amplify
import Combine

struct MediaView: View {
  
  @Environment(\.editMode) var editMode
  
  @ObservedObject var fetcher = MediaFileFetcher()
  
  var region: String
  @State var selections = Set<MediaFile>()
  @State var needAlert = false
  @State var needProgress = false
  @State var alertMessage = ""
  @State var sendMediaCancellable: AnyCancellable? = nil
  
  func onAppear() {
    if let camera = fetchCamera() {
      camera.setMode(.mediaDownload) { error in
        if let e = error {
          print("Set Download mode failed: \(e)")
        }
      }
      fetcher.loadMediaList()
    }
  }
  
  func onDisappear() {
    if let camera = fetchCamera() {
      camera.setMode(.shootPhoto) { error in
        if let e = error {
          print("Set Shoot photo mode failed: \(e)")
        }
      }
    }
  }
  
  func onSelectAll() {
    selections.removeAll()
    fetcher.mediaFileList.forEach {
      selections.insert($0)
    }
  }
  
  func onDeselectAll() {
    selections.removeAll()
  }
  
  func onTapSend() {
    needProgress = true
    // if invoke api after uploading images to s3, uncomment below
    // if let mediaFile = selected {
    //   let cancellable = fetcher.downloadAndSendMedia(mediaFile: mediaFile)
    //     .flatMap {
    //       fetcher.sendMediaFile(data: $0)
    //     }
    //     .flatMap {
    //       fetcher.createIncidents(fileName: $0, region: region)
    //     }
    //   sendMediaCancellable = publisher
    //     .sink {
    //       if case let .failure(error) = $0 {
    //         finishSending(error.errorMessage)
    //       }
    //     }
    //     receiveValue: {
    //       finishSending("Success sending")
    //     }
    // if invoke api directly, uncomment below
    if selections.count != 0 {
      let mediaFiles = selections
      let publishers = mediaFiles.map {
        fetcher.downloadAndSendMedia(mediaFile: $0)
      }
      sendMediaCancellable = Publishers.MergeMany(publishers)
        .collect()
        .flatMap {
          fetcher.createIncidentsFromRawImages(
            dataList: $0,
            region: region
          )
        }
        .sink {
          if case let .failure(error) = $0 {
            finishSending(error.errorMessage)
          }
        }
        receiveValue: { dataList in
          finishSending("Success sending")
        }
    }
  }
  
  private func finishSending(_ message: String) {
    needAlert = true
    alertMessage = message
    needProgress = false
    editMode?.wrappedValue = .inactive
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        List(fetcher.mediaFileList, id: \.self, selection: $selections) { mediaFile in
          MediaRow(mediaFile: mediaFile)
        }
      }
      
      if needProgress {
        HUDProgressView(placeHolder: "Please wait...")
      }
    }
    .edgesIgnoringSafeArea(.all)
    .onAppear(perform: onAppear)
    .navigationBarTitle("Media", displayMode: .inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: fetcher.loadMediaList) {
          Image(systemName: "goforward")
        }
      }
      
      ToolbarItem(placement: .navigationBarTrailing) {
        Group {
          if editMode?.wrappedValue == .active {
            if selections.count == fetcher.mediaFileList.count {
              Button(action: onDeselectAll) {
                Text("Deselect")
              }
            } else {
              Button(action: onSelectAll) {
                Text("Select All")
              }
            }
          }
        }
      }
      
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }
      
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: onTapSend) {
          Image(systemName: "paperplane")
        }
      }
    }
    .alert(isPresented: $needAlert) {
      Alert(
        title: Text("Alert"),
        message: Text(alertMessage),
        dismissButton: .default(Text("Send"))
      )
    }
  }
}

struct MediaView_Previews: PreviewProvider {
  static var fetcher = MediaFileFetcher(
    mediaFileList: [
      MediaFile(fileName: "test.jpeg", thumbnail: UIImage(systemName: "hand.thumbsup.fill"), mediaFile: DJIMediaFile()),
      MediaFile(fileName: "test.jpeg", thumbnail: UIImage(systemName: "hand.thumbsup.fill"), mediaFile: DJIMediaFile()),
      MediaFile(fileName: "test.jpeg", thumbnail: UIImage(systemName: "hand.thumbsup.fill"), mediaFile: DJIMediaFile())
    ]
  )
  
  static var previews: some View {
    NavigationView {
      MediaView(region: "Japan")
    }
    .previewLayout(PreviewLayout.fixed(width: 844, height: 390))
  }
}
