//
//  ZHLAppDelegate.m
//  ZHLRouter
//
//  Created by tanghai on 06/01/2021.
//  Copyright (c) 2021 tanghai. All rights reserved.
//
#import <ZHLRouter/ZHLRouter.h>
#import "ZHLAppDelegate.h"

@implementation ZHLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ZHLRouter share] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[ZHLRouter share] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ZHLRouter share] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[ZHLRouter share] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[ZHLRouter share] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ZHLRouter share] applicationWillTerminate:application];
}

@end
