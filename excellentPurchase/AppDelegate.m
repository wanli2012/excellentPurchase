//
//  AppDelegate.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "yindaotuViewController.h"//引导页
#import "BasetabbarViewController.h"//tabbar控制器
#import "BaseNavigationViewController.h"//导航控制器
#import "LBLoginViewController.h"//登录注册

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    self.window.rootViewController = [[BasetabbarViewController alloc]init];
    
    BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:[[LBLoginViewController alloc] init]];
    self.window.rootViewController = loginNav;
    
    [self.window makeKeyAndVisible];
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isdirect1"] isEqualToString:@"YES"]) {
    
        self.window.rootViewController = [[BasetabbarViewController alloc]init];
        
//    }else{
//        self.window.rootViewController = [[yindaotuViewController alloc]init];
//    }

    
    return YES;
}


@end
