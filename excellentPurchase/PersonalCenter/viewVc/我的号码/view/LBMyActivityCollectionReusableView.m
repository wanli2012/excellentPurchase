//
//  LBMyActivityCollectionReusableView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/21.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyActivityCollectionReusableView.h"

@interface LBMyActivityCollectionReusableView()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *numberslb;
@property (weak, nonatomic) IBOutlet UILabel *jionlb;
@property (weak, nonatomic) IBOutlet UIButton *adressBt;


@end

@implementation LBMyActivityCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.adressBt.layer.borderColor = LBHexadecimalColor(0x5C25FB).CGColor;
    self.adressBt.layer.borderWidth = 1;

}
- (IBAction)changecollectionType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.changeCollectionType) {
        self.changeCollectionType();
    }
}
//选择地址或者查看物流
- (IBAction)chooseAdressEvent:(UIButton *)sender {
    if ([_model.indiana_address_id integerValue] == 0) {//没有选择地址
       
        if (self.chooseAdress) {
            self.chooseAdress();
        }
        
    }else{//已经选择地址了
        if (self.chechfly) {
            self.chechfly();
        }
        
    }
    
}


-(void)setModel:(LBDolphinRecodermodel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.titlelb.text = _model.indiana_goods_name;
    self.numberslb.text = [NSString stringWithFormat:@"期号:%@",_model.indiana_number];
    self.jionlb.text = [NSString stringWithFormat:@"我参与:%@次",_model.u_count];
    
    if ([[UserModel defaultUser].uid isEqualToString:_model.indiana_uid]) {//中奖了
         self.adressBt.hidden = NO;
        
        if ([_model.indiana_address_id integerValue] == 0) {//没有选择地址
            [self.adressBt setTitle:@"收获地址" forState:UIControlStateNormal];
        }else{//已经选择地址了
             [self.adressBt setTitle:@"查看物流" forState:UIControlStateNormal];
        }
    }else{//别人中奖了
        self.adressBt.hidden = YES;
    }
    
}

@end
