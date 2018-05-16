//
//  LBNotShowWinningPictureCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBNotShowWinningPictureCell.h"

@interface LBNotShowWinningPictureCell()
@property (weak, nonatomic) IBOutlet UIImageView *iamgev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *numbers;

@end

@implementation LBNotShowWinningPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)showpicture:(UIButton *)sender {
    
    if (self.jumpShowpic) {
        self.jumpShowpic(self.model);
    }
    
}

-(void)setModel:(LBNotShowWinningPicturemodel *)model{
    _model = model;
    [self.iamgev sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = _model.indiana_goods_name;
    self.numbers.text = [NSString stringWithFormat:@"期号: %@",_model.indiana_number];
    
}

@end
