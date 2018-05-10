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
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UILabel *salelb;
@property (weak, nonatomic) IBOutlet UILabel *salepricelb;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;
@property (weak, nonatomic) IBOutlet UILabel *rewardLb;

@end

@interface LBTimeLimitCrazingTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,strong) ZDProgressView *zdProgressView;

@end

@implementation LBTimeLimitCrazingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, 120, 13)];
    self.zdProgressView.progress = 0;
    self.zdProgressView.textFont = [UIFont systemFontOfSize:12];
    self.zdProgressView.text = @"0%";
    self.zdProgressView.noColor = LBHexadecimalColor(0xffedec);
    self.zdProgressView.prsColor = MAIN_COLOR;
    [self.progressView addSubview:self.zdProgressView];
}
- (IBAction)Snappedimmediately:(UIButton *)sender {
}

-(void)setModel:(LBTodayBuyingListTimeLimitActiveModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:@"shangpinxiangqing"]];
    NSMutableAttributedString *attri =    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.goods_name]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"海淘-返券"];
    attch.bounds = CGRectMake(0, -3, 30, 15);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    self.contentlb.attributedText = attri;
    self.salepricelb.text = [NSString stringWithFormat:@"¥%@",_model.costprice];
    self.oldprice.text = [NSString stringWithFormat:@"¥%@",_model.marketprice];
    self.rewardLb.text = [NSString stringWithFormat:@"奖%@积分",_model.rewardcounpons];
    self.salelb.text = [NSString stringWithFormat:@"已抢购%@件",_model.sale_count];
    NSString * progress = [NSString stringWithFormat:@"%f",[_model.sale_count floatValue] / [_model.challenge_alowd_num floatValue]];
    self.zdProgressView.text = [NSString stringWithFormat:@"%.0f%%",[progress floatValue] * 100 ];
    self.zdProgressView.progress = [progress floatValue];
    
}
@end
