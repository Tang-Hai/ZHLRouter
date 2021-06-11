//
//  ZHLRouter.h
//  ZHLRouter
//
//  Created by MAC on 2021/6/1.
//

#import <Foundation/Foundation.h>
#import "ZHLRouteAdapterProtocol.h"
#import "ZHLRouteAppEventProtocol.h"
#import "ZHLRoutePath.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^StartUpComplete)(void);

@protocol ZHLRouterUrlProtocol <NSObject>

+ (BOOL)canUrlHandle;
///打开远程 URL
+ (id __nullable)openServiceWithUrlPath:(NSURL *)url fromController:(UIViewController  * _Nullable )fromController;

@end

@protocol ZHLRouterConfigJsonProtocol <NSObject>

+ (BOOL)canConfigJsonHandle;
///打开远程配置 Json
+ (id __nullable)openServiceWithConfigJson:(NSString *)json fromController:(UIViewController * _Nullable )fromController;

@end

@protocol ZHLRouterPerformProtocol <NSObject>
///获取目标控制器
- (void)makeDestination:(void(^)(UIViewController *))resultBlock;

@end

@interface ZHLRouter : NSObject<ZHLRouteAppEventProtocol>

///路由单例
+ (instancetype)share;
///启动完成
+ (void)startUpComplete:(StartUpComplete)complete;


#pragma mark - register

///在公共路由提供者中通过协议获得服务者
+ (id __nullable)serviceProvideForProcotol:(Protocol *)procotol;
///在公共路由提供者中注册协议的服务对象（类）
+ (void)registerServiceProvide:(id)provide procotol:(Protocol *)procotol;
///在公共路由提供者中通过协议注销服务对象（类）
+ (void)deregistererServiceProvideForProcotol:(Protocol *)procotol;



///在自定义路由提供者中通过协议获得服务者
+ (id __nullable)serviceProvideForProcotol:(Protocol *)procotol
                   routeAdapter:(id<ZHLRouteAdapterProtocol>)routeAdapter;
///在自定义路由提供者中注册协议的服务对象（类）
+ (void)registerServiceProvide:(id)provide
                    procotol:(Protocol *)procotol
                routeAdapter:(id<ZHLRouteAdapterProtocol>)routeAdapter;
///在自定义路由提供者中通过协议注销服务对象（类）
+ (void)deregistererServiceProvideForProcotol:(Protocol *)procotol routeAdapter:(id<ZHLRouteAdapterProtocol>)routeAdapter;



#pragma mark - ZHLRouterUrlProtocol

///注册到支持打开 Url 的队列中
+ (void)registerUrlServiceProvide:(id<ZHLRouterUrlProtocol>)provide;
///从 Url 的队列中注销
+ (void)deregistererUrlServiceProvide:(id<ZHLRouterUrlProtocol>)provide;
///打开远程 URL
+ (id __nullable)openServiceWithUrlPath:(NSURL *)url fromController:(UIViewController *)fromController;



#pragma mark - ZHLRouterConfigJsonProtocol

///注册到支持打开 Url 的队列中
+ (void)registerJsonServiceProvide:(id<ZHLRouterConfigJsonProtocol>)provide;
///从 Json 的队列中注销
+ (void)deregistererJsonServiceProvide:(id<ZHLRouterConfigJsonProtocol>)provide;
///打开远程配置 Json
+ (id __nullable)openServiceWithConfigJson:(NSString *)json fromController:(UIViewController *)fromController;



#pragma mark - ZHLRouterPerformProtocol

///设置自定义的导航栏类，默认值为 UINavigationController
+ (void)setCustomNavClass:(Class)navClass;
///调转到目标页面
+ (void)performOnDestination:(id<ZHLRouterPerformProtocol>)destination path:(ZHLRoutePath *)path;
+ (void)performOnDestination:(id<ZHLRouterPerformProtocol>)destination path:(ZHLRoutePath *)path
                    complete:(void(^ __nullable)(UIViewController *destination,ZHLRoutePath *path,BOOL success))complete;
///返回上一个页面
+ (void)popViewController:(UIViewController *)vc;
+ (void)popViewController:(UIViewController *)vc animated:(BOOL)animated;
+ (void)popViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void(^__nullable)(void))completion;



#pragma mark - AppEvent

///添加到 AppEvent 接收器中，不会强持有 obj；
+ (void)addAppEvent:(id<ZHLRouteAppEventProtocol>)obj;
+ (void)removeAppEvent:(id<ZHLRouteAppEventProtocol>)obj;

@end

NS_ASSUME_NONNULL_END

