//
//  LBFinishProductsCell1.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinishProductsCell1.h"

@interface LBFinishProductsCell1()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;//返的积分
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;//浏览
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;//付款人数

@end

@implementation LBFinishProductsCell1

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (IBAction)replycomment:(UIButton *)sender {
    if (self.replyComment) {
        self.replyComment(self.indexpath);
    }
}


- (void)setModel:(GLFinishGoodsDetailModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.discount];
    self.backMoneyLabel.text = [NSString stringWithFormat:@"%@积分",model.rewardspoints];
    self.scanLabel.text =  [NSString stringWithFormat:@"%@人浏览",model.browse];
    self.paymentLabel.text = [NSString stringWithFormat:@"%@人付款",model.browse];
    
}
@end
