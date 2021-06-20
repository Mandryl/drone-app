//
//  BetaViewController.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/14.
//

import DJIUXSDKBeta

class BetaViewController<T: DUXBetaBaseWidget> : UIViewController {
    
    var djiWidget = T()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(djiWidget)
        djiWidget.install(in: self)
        makeConstraints()
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            djiWidget.view.topAnchor.constraint(equalTo: view.topAnchor),
            djiWidget.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            djiWidget.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            djiWidget.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

