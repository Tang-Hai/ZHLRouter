//
//  ZHLRouter.m
//  ZHLRouter
//
//  Created by MAC on 2021/6/1.
//

#import <UIKit/UIKit.h>
#import <ZHLRouter/ZHLRouter-Swift.h>

#import "ZHLRouteAdapter.h"
#import "ZHLRouter.h"

@interface ZHLRouter ()

@property (strong,nonatomic) Class navClass;
@property (strong,nonatomic) ZHLRouteAdapter *mainRouteAdapter;
@property (strong,nonatomic) NSMutableSet <ZHLRouterUrlProtocol>*urlServices;
@property (strong,nonatomic) NSMutableSet <ZHLRouterConfigJsonProtocol>*jsonServices;
@property (strong,nonatomic) NSMutableSet <id<ZHLRouteAppEventProtocol>>*appEventProtocols;

@property (assign,nonatomic) BOOL isStartUpComplete;
@property (strong,nonatomic) NSMutableSet <StartUpComplete>*startUpCompletes;
@end

@implementation ZHLRouter

+(void)load {
    [ZHLSwiftLoadProtocolExecute executeLoad];
}

+ (instancetype)share {
    static ZHLRouter *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [ZHLRouter new];
        share.navClass = UINavigationController.class;
        share.mainRouteAdapter = [ZHLRouteAdapter new];
        share.urlServices = [NSMutableSet<ZHLRouterUrlProtocol> set];
        share.jsonServices = [NSMutableSet<ZHLRouterConfigJsonProtocol> set];
        share.startUpCompletes = [NSMutableSet<StartUpComplete> set];
        share.appEventProtocols = [NSMutableSet<ZHLRouteAppEventProtocol> set];
    });
    return share;
}

+ (void)startUpComplete:(StartUpComplete)complete {
    ZHLRouter *share = [self share];
    if (share.isStartUpComplete) {
        complete();
    } else {
        [share.startUpCompletes addObject:complete];
    }
}

#pragma mark - register

+ (void)deregistererServiceProvideForProcotol:(Protocol *)procotol {
    [self deregistererServiceProvideForProcotol:procotol routeAdapter:[[self share] mainRouteAdapter]];
}

+ (void)registerServiceProvide:(id)provide procotol:(Protocol *)procotol {
    [self registerServiceProvide:provide procotol:procotol routeAdapter:[[self share] mainRouteAdapter]];
}

+ (id __nullable)serviceProvideForProcotol:(Protocol *)procotol {
    return [self serviceProvideForProcotol:procotol routeAdapter:[[self share] mainRouteAdapter]];
}

///?????????????????????????????????????????????????????????
+ (id __nullable)serviceProvideForProcotol:(Protocol *)procotol
                   routeAdapter:(id<ZHLRouteAdapterProtocol>)routeAdapter {
    return [routeAdapter serviceProvideForProcotol:procotol];
}
///?????????????????????????????????????????????????????????????????????
+ (void)deregistererServiceProvideForProcotol:(Protocol *)procotol routeAdapter:(id<ZHLRouteAdapterProtocol>)routeAdapter {
    [routeAdapter deregistererServiceProvideForProcotol:procotol];
}
///??????????????????????????????????????????????????????????????????
+ (void)registerServiceProvide:(id)provide
                    procotol:(Protocol *)procotol
                routeAdapter:(id<ZHLRouteAdapterProtocol>)routeAdapter {
    [routeAdapter registerServiceProvide:provide procotol:procotol];
}

///??????????????????????????????????????????????????????????????????
+ (void)registerUrlServiceProvide:(id<ZHLRouterUrlProtocol>)provide {
    [[[self share] urlServices] addObject:provide];
}
///??? Url ??????????????????
+ (void)deregistererUrlServiceProvide:(id<ZHLRouterUrlProtocol>)provide {
    NSMutableSet <ZHLRouterUrlProtocol>*urlServices = [[self share] urlServices];
    if ([urlServices containsObject:provide]) {
        [urlServices removeObject:provide];
    }
}
///???????????? URL
+ (id)openServiceWithUrlPath:(NSURL *)url fromController:(UIViewController *)fromController {
    id result = nil;
    NSMutableSet <ZHLRouterUrlProtocol>*urlServices = [[self share] urlServices];
    for (id<ZHLRouterUrlProtocol> obj in urlServices) {
        if ([obj canUrlHandle]) {
            result = [obj.class openServiceWithUrlPath:url fromController:fromController];break;
        }
    }
    return result;
}


///????????????????????? Url ????????????
+ (void)registerJsonServiceProvide:(id<ZHLRouterConfigJsonProtocol>)provide {
    [[[self share] jsonServices] addObject:provide];
}
///?????????????????? Json
+ (id)openServiceWithConfigJson:(NSString *)json fromController:(UIViewController *)fromController {
    id result = nil;
    NSMutableSet <ZHLRouterConfigJsonProtocol>*urlServices = [[self share] jsonServices];
    for (id<ZHLRouterConfigJsonProtocol> obj in urlServices) {
        if ([obj canConfigJsonHandle]) {
            result = [obj.class openServiceWithConfigJson:json fromController:fromController];break;
        }
    }
    return result;
}
///??? Json ??????????????????
+ (void)deregistererJsonServiceProvide:(id<ZHLRouterConfigJsonProtocol>)provide {
    NSMutableSet <ZHLRouterConfigJsonProtocol>*urlServices = [[self share] jsonServices];
    if ([urlServices containsObject:provide]) {
        [urlServices removeObject:provide];
    }
}

#pragma mark - ZHLRouterPerformProtocol

+ (void)setCustomNavClass:(Class)navClass {
    NSAssert([navClass isKindOfClass:[UINavigationController class]], @"?????????????????????");
    ZHLRouter *router = [self share];
    router.navClass = navClass;
}

#pragma mark - Pop

+ (void)popViewController:(UIViewController *)vc {
    [self popViewController:vc animated:YES];
}

+ (void)popViewController:(UIViewController *)vc animated:(BOOL)animated {
    [self popViewController:vc animated:YES completion:nil];
}

+ (void)popViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void(^)(void))completion {
    if (vc.navigationController) {
        if (vc.navigationController.viewControllers.count > 1) {
            [vc.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (completion) { completion(); }
            });
        } else {
            [vc.navigationController dismissViewControllerAnimated:animated completion:completion];
        }
    } else {
        [vc dismissViewControllerAnimated:animated completion:completion];
    }
}

#pragma mark - Push

+ (void)performOnDestination:(id<ZHLRouterPerformProtocol>)destination path:(ZHLRoutePath *)path {
    [self performOnDestination:destination path:path complete:nil];
}

+ (void)performOnDestination:(id<ZHLRouterPerformProtocol>)destination
                        path:(ZHLRoutePath *)path
                    complete:(void(^)(UIViewController *destination,ZHLRoutePath *path,BOOL success))complete {
    NSAssert(destination && path, @"destination ?????? path ????????? nil");
    [destination makeDestination:^(UIViewController * _Nonnull vc) {
        if (vc && path.source) {
            void(^pushBlock)(UINavigationController *) = ^(UINavigationController *nav){
                [nav pushViewController:vc animated:path.animated];
                __weak UIViewController *weakVc = vc;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (complete) { complete(weakVc,path,weakVc ? YES : NO); }
                });
            };
            void(^presentBlock)(UIViewController *,UIViewController *) = ^(UIViewController *source,UIViewController *vc){
                __weak UIViewController *weakVc = vc;
                vc.modalPresentationStyle = path.modalPresentationStyle;
                [source presentViewController:vc animated:path.animated completion:^{
                    if (complete) { complete(weakVc,path,weakVc ? YES : NO); }
                }];
            };
            switch (path.routeType) {
                case ZHLRoutePushType:
                    if ([vc isKindOfClass:[UINavigationController class]]) {
                        presentBlock(path.source,vc);
                    } else {
                        if ([path.source isKindOfClass:[UINavigationController class]]) {
                            pushBlock((UINavigationController *)path.source);
                        } else if (path.source.navigationController){
                            pushBlock(path.source.navigationController);
                        } else {
                            ZHLRouter *router = [self share];
                            UINavigationController *nav = [[router.navClass alloc] initWithRootViewController:vc];
                            presentBlock(path.source,nav);
                        }
                    }
                    break;
                case ZHLRoutePresent:
                    presentBlock(path.source,vc);
                    break;
            }
        } else if (complete) {
            complete(nil,path,NO);
        }
    }];
}

#pragma mark - AppEvent

+ (void)addAppEvent:(id<ZHLRouteAppEventProtocol>)obj {
    ZHLRouter *router = [self share];
    [router.appEventProtocols addObject:obj];
}

+ (void)removeAppEvent:(id<ZHLRouteAppEventProtocol>)obj {
    ZHLRouter *router = [self share];
    [router.appEventProtocols removeObject:obj];
}

#pragma mark - ZHLRouteAppEventProtocol

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isStartUpComplete = YES;
    if (self.startUpCompletes.count) {
        for (StartUpComplete complete in self.startUpCompletes) {
            complete();
        }
        [self.startUpCompletes removeAllObjects];
    }
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [obj application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(applicationWillResignActive:)]) {
            [obj applicationWillResignActive:application];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [obj applicationDidEnterBackground:application];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [obj applicationWillEnterForeground:application];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [obj applicationDidBecomeActive:application];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(applicationWillTerminate:)]) {
            [obj applicationWillTerminate:application];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL isOpenURL = NO;
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:openURL:options:)]) {
            if ([obj application:application openURL:url options:options]) {
                isOpenURL = YES;
            }
        }
    }
    return isOpenURL;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL isOpenURL = NO;
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:handleOpenURL:)]) {
            if([obj application:application handleOpenURL:url]) {
                isOpenURL = YES;
            }
        }
    }
    return isOpenURL;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL isOpenURL = NO;
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
            if([obj application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
                isOpenURL = YES;
            }
        }
    }
    return isOpenURL;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler {
    BOOL isOpenURL = NO;
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:continueUserActivity:restorationHandler:)]) {
            if([obj application:application continueUserActivity:userActivity restorationHandler:restorationHandler]) {
                isOpenURL = YES;
            }
        }
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [obj application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            [obj application:application didReceiveRemoteNotification:userInfo];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [obj application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            [obj application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    for (id<ZHLRouteAppEventProtocol> obj in self.appEventProtocols) {
        if ([obj respondsToSelector:@selector(application:handleEventsForBackgroundURLSession:completionHandler:)]) {
            [obj application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
        }
    }
}

@end
