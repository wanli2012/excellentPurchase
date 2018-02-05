//
//  LBMineOrderDetailAdressTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderDetailAdressTableViewCell.h"

@implementation LBMineOrderDetailAdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(LBMyOrdersDetailModel *)model{
    _model=model;
    self.namelb.text = [NSString stringWithFormat:@"收货人：%@",_model.get_user];
    self.phonelb.text = [NSString stringWithFormat:@"%@",_model.get_phone];
    self.adresslb.text = [NSString stringWithFormat:@"收货地址：%@",_model.get_address];
}
@end
