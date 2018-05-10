//
//  LBTimeLimitQinggouTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTimeLimitQinggouTableViewCell.h"

@interface LBTimeLimitQinggouTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *conentLb;
@property (weak, nonatomic) IBOutlet UILabel *limitLb;
@property (weak, nonatomic) IBOutlet UILabel *salePricelb;
@property (weak, nonatomic) IBOutlet UILabel *oldPricelb;
@property (weak, nonatomic) IBOutlet UILabel *rewardlb;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation LBTimeLimitQinggouTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)noticeOrder:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showSuccessText:@"请先登录"];
        return;
    }
    WeakSelf;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"challenge_id"] = _model.challenge_id;

    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kChallenge_add_notice paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            _model.maa_status = @"1";
            if (weakSelf.refreshdata) {
                weakSelf.refreshdata();
            }
            [EasyShowTextView showSuccessText:@"预约成功"];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

-(void)setModel:(LBTodayTimeLimitActiveModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:@"shangpinxiangqing"]];
    NSMutableAttributedString *attri =    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.goods_name]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"海淘-返券"];
    attch.bounds = CGRectMake(0, -3, 30, 15);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    self.conentLb.attributedText = attri;
    self.limitLb.text = [NSString stringWithFormat:@"限量%@件",_model.challenge_alowd_num];
    self.salePricelb.text = [NSString stringWithFormat:@"¥%@",_model.costprice];
    self.oldPricelb.text = [NSString stringWithFormat:@"¥%@",_model.marketprice];
    self.rewardlb.text = [NSString stringWithFormat:@"奖%@积分",_model.rewardcounpons];
    if ([_model.maa_status integerValue] == 1) {
        self.button.userInteractionEnabled = NO;
        self.button.backgroundColor = LBHexadecimalColor(0x999999);
        [self.button setTitle:@"已预约" forState:UIControlStateNormal];
    }else{
        self.button.userInteractionEnabled = YES;
        self.button.backgroundColor = LBHexadecimalColor(0x5C02FF);
        [self.button setTitle:@"预约提醒" forState:UIControlStateNormal];
    }
    
}
@end
