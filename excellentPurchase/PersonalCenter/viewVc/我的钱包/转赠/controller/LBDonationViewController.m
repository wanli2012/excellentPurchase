//
//  LBDonationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDonationViewController.h"

@interface LBDonationViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LBDonationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"转赠";
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    
}



@end
