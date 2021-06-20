//
//  MediaRow.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/18.
//

import SwiftUI
import DJISDK

struct MediaRow: View {
  var mediaFile: MediaFile
  
  var body: some View {
    HStack {
      Group {
        if mediaFile.thumbnail == nil {
          Image(systemName: "photo")
        } else {
          Image(uiImage: mediaFile.thumbnail!)
        }
      }
      Text(mediaFile.fileName)
    }
  }
}

struct MediaRow_Previews: PreviewProvider {
  
  static var mediaFile = MediaFile(fileName: "test.jpeg", thumbnail: UIImage(systemName: "hand.thumbsup.fill"), mediaFile: DJIMediaFile())
  
  static var previews: some View {
    MediaRow(mediaFile: mediaFile)
  }
}
