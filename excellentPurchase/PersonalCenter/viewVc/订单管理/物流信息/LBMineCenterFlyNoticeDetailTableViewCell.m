//
//  LBMineCenterFlyNoticeDetailTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeDetailTableViewCell.h"

@implementation LBMineCenterFlyNoticeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBMineCenterFlyNoticeModel *)model{
    _model = model;
    self.statusLb.text = [NSString stringWithFormat:@"物流状态: %@",_model.wl_status];
    self.codelb.text = [NSString stringWithFormat:@"物流单号: %@",_model.wl_num];
}
@end
