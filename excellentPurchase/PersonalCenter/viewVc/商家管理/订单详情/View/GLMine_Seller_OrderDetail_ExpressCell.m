//
//  GLMine_Seller_OrderDetail_ExpressCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Seller_OrderDetail_ExpressCell.h"

@interface GLMine_Seller_OrderDetail_ExpressCell()<UITextFieldDelegate>


@end

@implementation GLMine_Seller_OrderDetail_ExpressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (self.block) {
        self.block(self.expressNumberTF.text);
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![predicateModel inputShouldLetterOrNum:string]) {
        [EasyShowTextView showInfoText:@"物流单号只能输入数字和字母"];
        return NO;
    }
    
    return YES;
}

@end

