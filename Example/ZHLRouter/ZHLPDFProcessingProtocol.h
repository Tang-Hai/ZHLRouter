//
//  ZHLPDFProcessingProtocol.h
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/9.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import <ZHLRouter/ZHLRouter.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHLPDFProcessingProtocol <ZHLRouterPerformProtocol>

+ (instancetype)createProcessingServiceWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
