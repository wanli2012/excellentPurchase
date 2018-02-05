//
//  LBMineOrdersHeaderViewOneCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrdersHeaderViewOneCell.h"

@implementation LBMineOrdersHeaderViewOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectEvent:(UIButton *)sender {
    
    _model.iselect = !_model.iselect;
    
    if (self.refreshfata) {
        self.refreshfata(self.indexpath);
    }
}

-(void)setModel:(LBMineOrderObligationmodel *)model{
    _model = model;
   
    self.selectBt.selected = _model.iselect;
    
    if ([NSString StringIsNullOrEmpty:_model.shop_name]) {
        self.storeName.text = [NSString stringWithFormat:@"无店名"];
    }else{
        self.storeName.text = [NSString stringWithFormat:@"%@",_model.shop_name];
    }
    self.timeLb.text = [NSString stringWithFormat:@"下单时间: %@",[formattime formateTime:_model.time]];
   
}

@end
