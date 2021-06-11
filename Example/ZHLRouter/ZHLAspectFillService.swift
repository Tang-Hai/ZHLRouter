//
//  ZHLAspectFillService.swift
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/10.
//  Copyright © 2021 tanghai. All rights reserved.
//

import ZHLRouter

class ZHLAspectFillService: NSObject {

}

extension ZHLAspectFillService: ZHLSwiftClassLoadProtocol {
    static func awake() {
        ZHLRouter.registerServiceProvide(ZHLAspectFillService.init(), procotol: ZHLAspectFillProtocol.self)
    }
}

extension ZHLAspectFillService: ZHLAspectFillProtocol {
    func makeDestination(_ resultBlock: @escaping (UIViewController) -> Void) {
        resultBlock(ZHLAspectFillViewController.init())
    }
}
