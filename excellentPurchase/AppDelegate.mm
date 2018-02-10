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
//#import "UMessage.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import <UMSocialCore/UMSocialCore.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#define WEIXI_APPKEY @"wx01b5d9da6a88048c"
#define WEIXIN_APPSECRET @"5b3cbdab8d6d0464566ac0af66c59390"

@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate>
{
@private  Reachability *hostReach;
}
@property(strong,nonatomic)BMKMapManager* mapManager;
@property(strong,nonatomic)NSDictionary* userInfo;

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
    BOOL ret = [_mapManager start:@"HFg81pQ2m97GLX0DCudONsWmmKhl9Pdc" generalDelegate:self];
    if (!ret) {
        [EasyShowTextView showInfoText:@"启动百度地图失败"];
    }
    
    /**
     *微信支付
     */
    
//    [WXApi registerApp:WEIXI_APPKEY withDescription:@"sjyg"];
    [WXApi registerApp:WEIXIN_APPSECRET];
//    self.window.rootViewController = [[BasetabbarViewController alloc]init];
    
    BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:[[LBLoginViewController alloc] init]];
    self.window.rootViewController = loginNav;
    
    [self.window makeKeyAndVisible];
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isdirect1"] isEqualToString:@"YES"]) {
    
        self.window.rootViewController = [[BasetabbarViewController alloc]init];
        
//    }else{
//        self.window.rootViewController = [[yindaotuViewController alloc]init];
//    }

    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];

    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];

    [self configUSharePlatforms];

    return YES;
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXI_APPKEY appSecret:WEIXIN_APPSECRET redirectURL:nil];
    
    
    /* 支付宝的appKey */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
   
    //        NSString * token = [[[[deviceToken description]
    //                              stringByReplacingOccurrencesOfString: @"<" withString: @""]
    //                             stringByReplacingOccurrencesOfString: @">" withString: @""]
    //                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
//    [UMessage didReceiveRemoteNotification:userInfo];
    
    self.userInfo = userInfo;
    //定制自定的的弹出框
    NSString *str = [NSString stringWithFormat:@"%@",userInfo[@"nim"]];
    
    if (![str isEqualToString:@"1"]) {//表示不是网易云推送
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                message:userInfo[@"aps"][@"alert"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即更新", nil];
            
            [alertView show];
            
        }else{
           
        }
        
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        //return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    return NO;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    if (!result) {
        // 其他如支付等SDK的回调
        
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }else if ([url.host isEqualToString:@"safepay"]){
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Alipaysucess" object:nil];
                    
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr=@"订单正在处理中";
                            break;
                        case 4000:
                            returnStr=@"订单支付失败";
                            break;
                        case 6001:
                            returnStr=@"订单取消";
                            break;
                        case 6002:
                            returnStr=@"网络连接出错";
                            break;
                            
                        default:
                            break;
                    }
                    
                    [EasyShowTextView showText:returnStr];
                    
                }
            }];
        }else{
            //return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
        }
        
    }
    return result;

}

// NOTE: 9.0以后使用新API接口
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Alipaysucess" object:nil];
                
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:
                        returnStr=@"订单正在处理中";
                        break;
                    case 4000:
                        returnStr=@"订单支付失败";
                        break;
                    case 6001:
                        returnStr=@"订单取消";
                        break;
                    case 6002:
                        returnStr=@"网络连接出错";
                        break;
                        
                    default:
                        break;
                }
                
                  [EasyShowTextView showText:returnStr];
                
            }
        }];
    }
    
    return YES;
    
}

/**
 *微信支付
 */
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;

    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];

        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysucess" object:nil];
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付结果：取消！";
                break;

            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                break;
        }
    }
    [EasyShowTextView showText:strMsg];
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
       NSString *netconnType =  [self getNetType];
        [self showNetworkStatusAlert:[NSString stringWithFormat:@"当前使用的是%@网络,请小心使用",netconnType]];
    }
    else if(status == ReachableViaWiFi)
    {
        
    }else
    {
        [self showNetworkStatusAlert:@"无网络连接,查看设置"];
    }
    
}
- (NSString *)getNetType
{
    NSString *netconnType = @"";
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        netconnType = @"2G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        netconnType = @"4G";
    }
    
    return netconnType;
}
-(void)showNetworkStatusAlert:(NSString *)str{
    //我这里是网络变化弹出一个警报框，由于不知道怎么让widow加载UIAlertController，所以这里用UIAlertView替代了
    UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertc addAction:cancelAction];
    [self.window.rootViewController presentViewController:alertc animated:YES completion:nil];
}

@end
