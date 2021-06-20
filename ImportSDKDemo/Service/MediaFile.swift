//
//  MediaFile.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/15.
//

import SwiftUI
import DJISDK

struct MediaFile: Identifiable, Hashable {
  let id = UUID()
  let fileName: String
  let thumbnail: UIImage?
  let mediaFile: DJIMediaFile
}
