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
#import "Reachability.h"//网络监测
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate ()<BMKGeneralDelegate>
{
@private  Reachability *hostReach;
}
@property(strong,nonatomic)BMKMapManager* mapManager;

- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变
- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接改变后的情况

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self ListenNetWork];//监听网络
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

-(void)ListenNetWork{
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
}

//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
    
}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == ReachableViaWWAN)
    {
        [self showNetworkStatusAlert:@"现在使用的是无线网络"];
    }
    else if(status == ReachableViaWiFi)
    {
        
    }else
    {
        [self showNetworkStatusAlert:@"无网络连接,查看设置"];
    }
    
}

-(void)showNetworkStatusAlert:(NSString *)str{
    //我这里是网络变化弹出一个警报框，由于不知道怎么让widow加载UIAlertController，所以这里用UIAlertView替代了
    UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertc addAction:cancelAction];
    [self.window.rootViewController presentViewController:alertc animated:YES completion:nil];
}

@end
