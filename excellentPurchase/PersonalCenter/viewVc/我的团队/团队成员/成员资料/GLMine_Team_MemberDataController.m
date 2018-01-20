//
//  GLMine_Team_MemberDataController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_MemberDataController.h"

@interface GLMine_Team_MemberDataController ()

@property (weak, nonatomic) IBOutlet UILabel *signLabel;//状态(审核中,审核成功,审核失败)

@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//账号ID
@property (weak, nonatomic) IBOutlet UILabel *groupTypeLabel;//身份
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//执照

@end

@implementation GLMine_Team_MemberDataController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNav];
}

/**
 导航栏设置
 */
- (void)setNav{
    self.navigationItem.title = @"成员资料";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"联系他" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(contact) forControlEvents:UIControlEventTouchUpInside];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 联系他
 */
- (void)contact{
    
    if (@available(iOS 10.0, *)) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",self.phoneLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"ddd2222"]];
    }
}


@end
