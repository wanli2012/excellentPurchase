//
//  LBFindSecondPassWordViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFindSecondPassWordViewController.h"

@interface LBFindSecondPassWordViewController ()

/**
 距离视图顶部的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;

@end

@implementation LBFindSecondPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"找回二级密码";
    self.navigationController.navigationBar.hidden = NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.topConstrait.constant = SafeAreaTopHeight;
}

@end
