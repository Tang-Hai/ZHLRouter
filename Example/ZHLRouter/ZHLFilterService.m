//
//  ZHLFilterService.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import "ZHLFilterViewController.h"

#import "ZHLFilterService.h"

@implementation ZHLFilterService

+(void)load {
    [ZHLRouter registerServiceProvide:[self class] procotol:@protocol(ZHLFilterServiceProtocol)];
}

+ (instancetype)createFilterService {
    return [[self alloc] init];
}

- (void)makeDestination:(void(^)(UIViewController *))resultBlock {
    ZHLFilterViewController *vc = [ZHLFilterViewController new];
    if (resultBlock) {
        resultBlock(vc);
    }
}

@end
