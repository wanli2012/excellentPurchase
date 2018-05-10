//
//  LBDolphinDetailJoinTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailJoinTableViewCell.h"

@interface LBDolphinDetailJoinTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iamgev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *infolb;

@end

@implementation LBDolphinDetailJoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self.iamgev sd_setImageWithURL:[NSURL URLWithString:_dic[@"pic"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
    self.infolb.text = [NSString stringWithFormat:@"本期参与: %@人/次    %@",dic[@"indiana_order_person_count"],[formattime formateTimeYM:dic[@"indiana_order_paytime"]]];
}
@end
