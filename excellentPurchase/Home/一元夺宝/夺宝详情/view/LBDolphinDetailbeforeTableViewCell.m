//
//  LBDolphinDetailbeforeTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailbeforeTableViewCell.h"

@interface LBDolphinDetailbeforeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *periodslb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *infolb;

@end

@implementation LBDolphinDetailbeforeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setDatadic:(NSDictionary *)datadic{
    _datadic = datadic;
    self.periodslb.text = [NSString stringWithFormat:@"第%@期",_datadic[@"indiana_number"]];
    self.timelb.text = [NSString stringWithFormat:@"开奖时间:%@",[formattime formateTimeYM:_datadic[@"indiana_endtime"]]];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_datadic[@"pic"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = [NSString stringWithFormat:@"%@",_datadic[@"nickname"]];
    self.infolb.text = [NSString stringWithFormat:@"本期参与: %@人/次   获奖号码: %@",_datadic[@"indiana_winner_count"],[formattime formateTimeYM:_datadic[@"indiana_lucky_number"]]];
}

@end
