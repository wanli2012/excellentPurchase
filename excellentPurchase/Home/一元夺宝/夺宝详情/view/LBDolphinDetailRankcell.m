//
//  LBDolphinDetailRankcell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailRankcell.h"

@interface LBDolphinDetailRankcell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UIImageView *imagevone;
@property (weak, nonatomic) IBOutlet UIImageView *imagevtwo;

@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name3;


@end

@implementation LBDolphinDetailRankcell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imagev.layer.cornerRadius = 25;
    self.imagevone.layer.cornerRadius = 25;
    self.imagevtwo.layer.cornerRadius = 25;
}

-(void)setModel:(LBHomeOneDolphinDetailmodel *)model{
    _model = model;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.proud.head_pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
     [self.imagevone sd_setImageWithURL:[NSURL URLWithString:_model.sofa.head_pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
     [self.imagevtwo sd_setImageWithURL:[NSURL URLWithString:_model.tail.head_pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
     self.name1.text = _model.proud.nickname;
     self.name2.text = _model.sofa.nickname;
     self.name3.text = _model.tail.nickname;
    
    if ([NSString StringIsNullOrEmpty:self.name1.text]) {
        self.name1.text = @"待定";
    }
    if ([NSString StringIsNullOrEmpty:self.name2.text]) {
        self.name2.text = @"待定";
    }
    if ([NSString StringIsNullOrEmpty:self.name3.text]) {
        self.name3.text = @"待定";
    }
}

@end
