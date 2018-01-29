//
//  LBMineCentermodifyAdressTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCentermodifyAdressTableViewCell.h"

@interface LBMineCentermodifyAdressTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLn;
@property (weak, nonatomic) IBOutlet UILabel *defaultSetLabel;//设置默认

@end

@implementation LBMineCentermodifyAdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupevent:)];
    [self.defaultSetLabel addGestureRecognizer:tap];
}

///设置默认
- (IBAction)setupevent:(UIButton *)sender {
    
//    self.model.is_default = !self.model.is_default;
    
    if (self.returnSetUpbt) {
        self.returnSetUpbt(self.index);
    }
    
}
///删除
- (IBAction)deleteEvent:(UIButton *)sender {

    if (self.returnDeletebt) {
        self.returnDeletebt(self.index);
    }
    
}

///编辑
- (IBAction)editEvent:(UIButton *)sender {

    if (self.returnEditbt) {
        self.returnEditbt(self.index);
    }
}

- (void)setModel:(GLMine_AddressModel *)model{
    _model = model;
    self.nameLb.text = model.truename;
    self.adressLn.text = [NSString stringWithFormat:@"%@%@%@%@",model.address_province,model.address_city,model.address_area,model.address_address];
    self.phoneLb.text = model.phone;
    
    if ([model.is_default integerValue] == 1) { //是否默认  1是 0否
        [self.setupBt setImage:[UIImage imageNamed:@"select-sex"] forState:UIControlStateNormal];
    }else{
        [self.setupBt setImage:[UIImage imageNamed:@"unselect-sex"] forState:UIControlStateNormal];
    }
}

// 懒加载
//- (RACSubject *)subject {
//    if (_subject == nil) {
//        _subject = [RACSubject subject];
//    }
//    
//    return _subject;
//}

@end
