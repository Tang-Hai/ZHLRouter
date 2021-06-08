//
//  ZHLImageProcessingService.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import "ZHLImageProcessingViewController.h"

#import "ZHLImageProcessingService.h"

@interface ZHLImageProcessingService ()

@property (strong, nonatomic) UIImage *image;

@end

@implementation ZHLImageProcessingService

+ (void)load {
    [ZHLRouter registerServiceProvide:[self class] procotol:@protocol(ZHLImageProcessingProtocol)];
}

+ (instancetype)createProcessingServiceWithImage:(UIImage *)image {
    ZHLImageProcessingService *obj = [ZHLImageProcessingService new];
    obj.image = image;
    return obj;
}

///获取目标控制器
- (void)makeDestination:(void(^)(UIViewController *))resultBlock {
    ZHLImageProcessingViewController*vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHLImageProcessingViewController"];
    vc.image = self.image;
    if (resultBlock) { resultBlock(vc); }
}

@end
