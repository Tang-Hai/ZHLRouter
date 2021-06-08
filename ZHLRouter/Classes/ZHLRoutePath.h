//
//  ZHLRoutePath.h
//  ZHLRouter
//
//  Created by MAC on 2021/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ZHLRouteType) {
    ZHLRoutePushType,
    ZHLRoutePresent,
};

@interface ZHLRoutePath : NSObject

@property (nonatomic, weak, readonly, nullable) UIViewController *source;
@property (nonatomic, readonly) ZHLRouteType routeType;
@property (nonatomic, assign) BOOL animated;
@property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle;

@property (class,nonatomic,readonly) ZHLRoutePath *(^pushFrom)(UIViewController *source);
@property (class,nonatomic,readonly) ZHLRoutePath *(^presentFrom)(UIViewController *source);

@end

NS_ASSUME_NONNULL_END
