//
//  ZHLPDFService.swift
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/9.
//  Copyright © 2021 tanghai. All rights reserved.
//

import ZHLRouter

class ZHLPDFService: NSObject {
    var name: String = ""
}

extension ZHLPDFService: ZHLSwiftClassLoadProtocol {
    static func awake() {
        ZHLRouter.registerServiceProvide(self, procotol: ZHLPDFProcessingProtocol.self)
    }
}

extension ZHLPDFService: ZHLPDFProcessingProtocol {
    func makeDestination(_ resultBlock: @escaping (UIViewController) -> Void) {
         let vc = ZHLPDFViewController.init()
        vc.name = self.name
        resultBlock(vc)
    }
    
    class func createProcessingService(withName name: String) -> Self {
        let pdf = ZHLPDFService.init()
        pdf.name = name
        return pdf as! Self
    }
}
