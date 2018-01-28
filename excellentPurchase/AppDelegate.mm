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

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@property(strong,nonatomic)BMKMapManager* mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"YDpxkRgH1YcLhjuvGq3OD4RPGqeS8swt" generalDelegate:self];
    if (!ret) {
        [EasyShowTextView showInfoText:@"启动百度地图失败"];
    }
    
    
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
