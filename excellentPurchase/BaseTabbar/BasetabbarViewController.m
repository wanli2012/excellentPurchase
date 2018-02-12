//
//  BasetabbarViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BasetabbarViewController.h"
#import "LBHomeViewController.h"
#import "LBEatAndDrinkViewController.h"
#import "LBTmallViewController.h"
#import "LBPersonCenterViewController.h"
#import "LBFinancialCenterViewController.h"
#import "BaseNavigationViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "BaseNavigationViewController.h"//导航控制器
#import "LBLoginViewController.h"//登录注册

@interface BasetabbarViewController ()<UITabBarControllerDelegate>

@property (assign , nonatomic)SystemSoundID soundID;

@end

@implementation BasetabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate=self;
    [self addViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(exitLogin) name:@"exitLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];

}

//退出跳转登录
-(void)exitLogin{
    
    self.selectedIndex = 0;
}

//刷新界面
-(void)refreshInterface{
    
    [self.viewControllers reverseObjectEnumerator];
    [self addViewControllers];
    
}

- (void)addViewControllers {

    //首页
    LBHomeViewController *homeVc = [[LBHomeViewController alloc] init];
    BaseNavigationViewController *homenav = [[BaseNavigationViewController alloc] initWithRootViewController:homeVc];
    homenav.tabBarItem = [self barTitle:@"首页" image:@"home" selectImage:@"choicehome"];
    
    //吃喝玩乐
    LBEatAndDrinkViewController *eatVc = [[LBEatAndDrinkViewController alloc] init];
    BaseNavigationViewController *eatNav = [[BaseNavigationViewController alloc] initWithRootViewController:eatVc];
    eatNav.tabBarItem = [self barTitle:@"吃喝玩乐" image:@"play" selectImage:@"choiceplay"];
    
    //淘宝商城
    LBTmallViewController *tmallVC = [[LBTmallViewController alloc] init];
    BaseNavigationViewController *tmallNav = [[BaseNavigationViewController alloc] initWithRootViewController:tmallVC];
    tmallNav.tabBarItem = [self barTitle:@"海淘商城" image:@"store" selectImage:@"choicestore"];
    
    //理财中心
    LBFinancialCenterViewController *financialVC = [[LBFinancialCenterViewController alloc] init];
    BaseNavigationViewController *financialNav = [[BaseNavigationViewController alloc] initWithRootViewController:financialVC];
    financialNav.tabBarItem = [self barTitle:@"理财中心" image:@"managemoney" selectImage:@"choicemanagemoney"];
    
    //个人中心
    LBPersonCenterViewController *personVC = [[LBPersonCenterViewController alloc] init];
    BaseNavigationViewController *personNav = [[BaseNavigationViewController alloc] initWithRootViewController:personVC];
    personNav.tabBarItem = [self barTitle:@"个人中心" image:@"myself" selectImage:@"choicemyself"];
    
    self.viewControllers = @[homenav,eatNav,tmallNav,financialNav, personNav];
    
    self.selectedIndex = 0;
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSString * b =  [[NSUserDefaults standardUserDefaults]objectForKey:@"iscloseMusic"];
    if (b == nil || [b isEqualToString:@"YES"]) {
          [self playSound];//音效
    }
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];//动画
    if([item.title isEqualToString:@"首页"]){
        
    }else if([item.title isEqualToString:@"个人中心"]){
        
//        LBLoginViewController *loginVC = [[LBLoginViewController alloc] init];
//        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
//        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:nav animated:YES completion:nil];
//        return;
    }
    
}

- (UITabBarItem *)barTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    
    item.title = title;
    item.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : YYSRGBColor(251, 77, 83, 1)} forState:UIControlStateSelected];
    

    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    return item;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:4] ||viewController == [tabBarController.viewControllers objectAtIndex:3]) {
        
        if ([UserModel defaultUser].loginstatus == YES) {
            
            return YES;
        }
        
        LBLoginViewController *loginVC = [[LBLoginViewController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
        
    }
    
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除注册的系统声音
    AudioServicesRemoveSystemSoundCompletion(self.soundID);
}

-(void) playSound{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like.caf" ofType:nil];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&_soundID);
    AudioServicesPlaySystemSoundWithCompletion(_soundID, ^{
        AudioServicesDisposeSystemSoundID(_soundID);
    });
    
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
}


@end
