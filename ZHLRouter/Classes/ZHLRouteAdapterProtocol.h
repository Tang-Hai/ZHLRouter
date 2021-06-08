//
//  ZHLRouteAdapterProtocol.h
//  ZHLRouter
//
//  Created by MAC on 2021/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHLRouteAdapterProtocol <NSObject>

///获取服务对象
- (id __nullable)serviceProvideForProcotol:(Protocol *)procotol;
///为协议注册服务对象
- (void)registerServiceProvide:(id)provide procotol:(Protocol *)procotol;
///注销服务对象
- (void)deregistererServiceProvideForProcotol:(Protocol *)procotol;
@end

NS_ASSUME_NONNULL_END
