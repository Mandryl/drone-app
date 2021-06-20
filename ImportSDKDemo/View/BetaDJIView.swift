//
//  BetaDJIView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/14.
//

import SwiftUI
import DJIUXSDKBeta

struct BetaDjiView<DjiWidget: DUXBetaBaseWidget>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = BetaViewController<DjiWidget>
    
    func makeUIViewController(context: Context) -> BetaViewController<DjiWidget> {
        return BetaViewController<DjiWidget>()
    }
    
    func updateUIViewController(_ uiViewController: BetaViewController<DjiWidget>, context: Context) { }
}
