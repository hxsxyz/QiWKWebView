//
//  AppDelegate.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/8.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "AppDelegate.h"
#import "QiWKWebViewController.h"
#import "ViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [ViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
