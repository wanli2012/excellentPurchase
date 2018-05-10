//
//  LBHomeViewActivityNowTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewActivityNowTableViewCell.h"
#import "ZDProgressView.h"

@interface LBHomeViewActivityNowTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,strong) ZDProgressView *zdProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *imagv;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *progresslb;


@end

@implementation LBHomeViewActivityNowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, 120, 16)];
    self.zdProgressView.progress = 0;
    self.zdProgressView.textFont = [UIFont systemFontOfSize:12];
    self.zdProgressView.text = @"0%";
    self.zdProgressView.noColor = LBHexadecimalColor(0xffedec);
    self.zdProgressView.prsColor = MAIN_COLOR;
    [self.progressView addSubview:self.zdProgressView];
    
}

-(void)setModel:(LBHomeViewActivityListModel *)model{
    _model = model;
    [_imagv sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    _titlelb.text = _model.indiana_goods_name;
    
    NSString * progress = [NSString stringWithFormat:@"%f",[_model.buy_count floatValue] / [_model.indiana_reward_count floatValue]];
    self.zdProgressView.text = [NSString stringWithFormat:@"%.0f%%",[progress floatValue] * 100 ];
    self.zdProgressView.progress = [progress floatValue];
    self.progresslb.text = [NSString stringWithFormat:@"开奖进度%@",[NSString stringWithFormat:@"%.0f%%",[progress floatValue] * 100 ]];
    
}

@end
