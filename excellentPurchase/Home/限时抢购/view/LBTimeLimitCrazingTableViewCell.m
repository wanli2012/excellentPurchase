//
//  LBTimeLimitCrazingTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTimeLimitCrazingTableViewCell.h"
#import "ZDProgressView.h"

@interface LBTimeLimitCrazingTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,strong) ZDProgressView *zdProgressView;

@end

@implementation LBTimeLimitCrazingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, 120, 16)];
    self.zdProgressView.progress = 0.5;
    self.zdProgressView.textFont = [UIFont systemFontOfSize:12];
    self.zdProgressView.text = @"40%";
    self.zdProgressView.noColor = LBHexadecimalColor(0xffedec);
    self.zdProgressView.prsColor = MAIN_COLOR;
    [self.progressView addSubview:self.zdProgressView];
}


@end
