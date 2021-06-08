//
//  ZHLRoutePath.m
//  ZHLRouter
//
//  Created by MAC on 2021/6/1.
//

#import "ZHLRoutePath.h"

@implementation ZHLRoutePath

+ (ZHLRoutePath *(^)(UIViewController *))pushFrom {
    return ^(UIViewController *source) {
        return [self pushFrom:source];
    };
}

+ (ZHLRoutePath *(^)(UIViewController *))presentFrom {
    return ^(UIViewController *source) {
        return [self presentFrom:source];
    };
}

#pragma mark - Init

- (instancetype)initWithRouteType:(ZHLRouteType)routeType source:(UIViewController *)source {
    if (self= [super init]) {
        _source = source;
        _routeType = routeType;
        _animated = YES;
        _modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

+ (instancetype)pushFrom:(UIViewController *)source {
    return [[ZHLRoutePath alloc] initWithRouteType:ZHLRoutePushType source:source];
}

+ (instancetype)presentFrom:(UIViewController *)source {
    return [[ZHLRoutePath alloc] initWithRouteType:ZHLRoutePresent source:source];
}

@end

