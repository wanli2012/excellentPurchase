//
//  LBAboutUsViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAboutUsViewController.h"

@interface LBAboutUsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ruleLb;

@end

@implementation LBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.navigationController.navigationBar.hidden = NO;
    self.ruleLb.text = [NSString stringWithFormat:@"%@",@"1、探亲网络最低购物价格底线\n2、力求用户最大的返利优惠\n3、严格把控商品质量  \n4、推荐性价比最高的产品"];
    
}



@end
