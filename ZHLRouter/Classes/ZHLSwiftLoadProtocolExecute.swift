//
//  ZHLSwiftLoadProtocolExecute.swift
//  ZHLRouter
//
//  Created by MAC on 2021/6/9.
//

import Foundation

public class ZHLSwiftLoadProtocolExecute: NSObject {
    
    @objc public class func executeLoad() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? ZHLSwiftClassLoadProtocol.Type)?.awake()
        }
        types.deallocate()
    }
    
}
