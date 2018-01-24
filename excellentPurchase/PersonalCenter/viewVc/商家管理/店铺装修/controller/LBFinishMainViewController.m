//
//  LBFinishMainViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinishMainViewController.h"
#import "UIButton+SetEdgeInsets.h"

@interface LBFinishMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signBt;//换牌照
@property (weak, nonatomic) IBOutlet UIButton *databt;//修改资料
@property (weak, nonatomic) IBOutlet UIButton *counterBt;//我的货柜
@property (weak, nonatomic) IBOutlet UIButton *replyBt;//回复评论


@end

@implementation LBFinishMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.title = @"我的小店";
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.signBt verticalCenterImageAndTitle:5];
     [self.databt verticalCenterImageAndTitle:5];
     [self.counterBt verticalCenterImageAndTitle:5];
     [self.replyBt verticalCenterImageAndTitle:5];
}

@end
