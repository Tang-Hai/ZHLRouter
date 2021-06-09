//
//  ZHLRouteAdapter.m
//  ZHLRouter
//
//  Created by MAC on 2021/6/1.
//

#import "ZHLRouteAdapter.h"

@interface ZHLRouteAdapter ()

@property (strong, nonatomic) NSMutableDictionary *routerMap;

@end

@implementation ZHLRouteAdapter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.routerMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerServiceProvide:(id)provide procotol:(Protocol *)procotol {
    if (procotol == nil || provide == nil) {
        NSAssert(NO, @"注册协议或类为nil");
        return;
    }
    NSString *key = NSStringFromProtocol(procotol);
    Class class = self.routerMap[key];
    if ([class isMemberOfClass:provide]) {
        NSAssert(NO, @"重复注册");
        self.routerMap[key] = provide;
    } else {
        self.routerMap[key] = provide;
    }
}

- (void)deregistererServiceProvideForProcotol:(Protocol *)procotol {
    if (procotol == nil) {
        NSAssert(NO, @"协议为nil");
        return;
    }
    NSString *key = NSStringFromProtocol(procotol);
    [self.routerMap removeObjectForKey:key];
}

- (id)serviceProvideForProcotol:(Protocol *)procotol {
    if (procotol == nil) {
        NSAssert(NO, @"协议为nil");
        return nil;
    }
    NSString *key = NSStringFromProtocol(procotol);
    return self.routerMap[key];
}

@end
