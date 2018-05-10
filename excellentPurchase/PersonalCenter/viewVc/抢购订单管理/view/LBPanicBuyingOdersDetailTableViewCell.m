//
//  LBPanicBuyingOdersDetailTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBPanicBuyingOdersDetailTableViewCell.h"

@interface LBPanicBuyingOdersDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *specinfo;
@property (weak, nonatomic) IBOutlet UILabel *newprice;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;
@property (weak, nonatomic) IBOutlet UILabel *numlb;

@end

@implementation LBPanicBuyingOdersDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.replyBT.layer.borderWidth = 1;
    self.replyBT.layer.borderColor = MAIN_COLOR.CGColor;
    
}

- (IBAction)replyEvent:(UIButton *)sender {
    if (self.gotoReply) {
        self.gotoReply();
    }
    
}


-(void)setModel:(LBMyOrdersDetailGoodsListModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.specinfo.text = [NSString stringWithFormat:@"%@",_model.ord_spec_info];
    self.newprice.text = [NSString stringWithFormat:@"¥%@",_model.ord_goods_price];
    self.oldprice.text = [NSString stringWithFormat:@"¥%@",_model.old_price];
    self.numlb.text = [NSString stringWithFormat:@"x%@",_model.ord_goods_num];
    
}

@end
