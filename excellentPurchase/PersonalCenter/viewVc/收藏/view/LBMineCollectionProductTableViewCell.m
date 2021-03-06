//
//  LBMineCollectionProductTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCollectionProductTableViewCell.h"

@interface LBMineCollectionProductTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *ratelb;

@end

@implementation LBMineCollectionProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}
//加入购物车
- (IBAction)addShopCar:(UIButton *)sender {
    
    if (self.addShopCar) {
        self.addShopCar(self.indexpath);
    }
    
}

-(void)setModel:(LBMineCollectionProductModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:nil];
    self.titileLb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"¥ %@",_model.discount];
    self.ratelb.text = [NSString stringWithFormat:@"%@积分; %@购物券",_model.bonuspoints,_model.reword_coupons];
}


-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"MyTeam_Select-y2"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"MyTeam_select-n2"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}


//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"MyTeam_select-n2"];
                    }
                }
            }
        }
    }
}

//这个方法在Cell被选中或者被取消选中时调用
-(void)setSelected:(BOOL)selected
animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.backView.backgroundColor = [UIColor whiteColor];
   
}
//这个方法在用户按住Cell时被调用
-(void)setHighlighted:(BOOL)highlighted
             animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    self.backView.backgroundColor = [UIColor whiteColor];
}
@end
