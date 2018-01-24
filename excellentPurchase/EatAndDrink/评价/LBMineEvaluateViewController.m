//
//  LBMineEvaluateViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineEvaluateViewController.h"
#import "LCStarRatingView.h"

@interface LBMineEvaluateViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *noticelb;

@end

@implementation LBMineEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.navigationController.navigationBar.hidden = NO;
    
}

/**
 匿名评价

 @param sender <#sender description#>
 */
- (IBAction)evaluateEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

/**
 提交

 @param sender <#sender description#>
 */
- (IBAction)submitEvent:(UIButton *)sender {
}

@end
