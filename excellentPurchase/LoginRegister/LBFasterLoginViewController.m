//
//  LBFasterLoginViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFasterLoginViewController.h"

@interface LBFasterLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoH;

@end

@implementation LBFasterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    //iphoneX
    if (UIScreenWidth == 812.0) {
        self.navigation.constant = 47;
        self.logoH.constant = 92;
    }
    
}



@end
