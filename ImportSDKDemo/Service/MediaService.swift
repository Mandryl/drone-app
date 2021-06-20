//
//  MediaService.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/14.
//

import DJISDK

func fetchCamera() -> DJICamera? {
  guard let product = DJISDKManager.product() else {
    return nil
  }
  if product is DJIAircraft {
    return (product as! DJIAircraft).camera
  }
  if product is DJIHandheld {
    return (product as! DJIHandheld).camera
  }
  return nil
}
