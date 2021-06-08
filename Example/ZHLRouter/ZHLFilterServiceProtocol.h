//
//  ZHLFilterServiceProtocol.h
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZHLRouter/ZHLRouter.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHLFilterServiceProtocol <ZHLRouterPerformProtocol>

+ (instancetype)createFilterService;

@end

NS_ASSUME_NONNULL_END
