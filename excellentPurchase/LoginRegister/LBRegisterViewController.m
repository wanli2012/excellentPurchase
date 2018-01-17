//
//  LBRegisterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRegisterViewController.h"

@interface LBRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;//Scrollvive contentview的宽度

@end

@implementation LBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentViewH.constant = UIScreenWidth - 70;
}

@end
