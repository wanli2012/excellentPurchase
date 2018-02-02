//
//  LBShopProductClassifyMenuReusableView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShopProductClassifyMenuReusableView.h"
#import "UIButton+SetEdgeInsets.h"

@interface LBShopProductClassifyMenuReusableView()

@property (weak, nonatomic) IBOutlet UIButton *priceBt;
@property (weak, nonatomic) IBOutlet UIButton *allbt;
@property (weak, nonatomic) IBOutlet UIButton *salebt;

@property (strong, nonatomic) UIButton *currentBt;

@end

@implementation LBShopProductClassifyMenuReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.priceBt horizontalCenterTitleAndImage:5];
    [self.salebt horizontalCenterTitleAndImage:5];
    self.currentBt = self.allbt;
}

- (IBAction)allEvent:(UIButton *)sender {
    sender.selected = YES;
    self.currentBt.selected = NO;
    [self.currentBt setTitleColor:LBHexadecimalColor(0x323333) forState:UIControlStateNormal];
    self.currentBt = sender;
    
    if (self.refreshdata) {
        self.refreshdata(1, 0);
    }
    
}
- (IBAction)saleEvent:(UIButton *)sender {
    if (self.currentBt == sender) {
        sender.selected = !sender.selected;
         [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
         [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.currentBt.selected = NO;
        [self.currentBt setTitleColor:LBHexadecimalColor(0x323333) forState:UIControlStateNormal];
        self.currentBt = sender;
    }
    
    if (sender.selected == YES) {
        if (self.refreshdata) {
            self.refreshdata(2, 2);
        }
    }else{
        if (self.refreshdata) {
            self.refreshdata(2, 1);
        }
    }
    
    
}
- (IBAction)priceEvnt:(UIButton *)sender {
    if (self.currentBt == sender) {
        sender.selected = !sender.selected;
        [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.currentBt.selected = NO;
        [self.currentBt setTitleColor:LBHexadecimalColor(0x323333) forState:UIControlStateNormal];
        self.currentBt = sender;
    }
    
    if (sender.selected == YES) {
        if (self.refreshdata) {
            self.refreshdata(3, 2);
        }
    }else{
        if (self.refreshdata) {
            self.refreshdata(3, 1);
        }
    }
    
}



@end
