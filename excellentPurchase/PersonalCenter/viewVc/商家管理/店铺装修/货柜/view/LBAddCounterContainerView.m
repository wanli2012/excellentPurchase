//
//  LBAddCounterContainerView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddCounterContainerView.h"

@interface LBAddCounterContainerView()<UITextFieldDelegate>


@end

@implementation LBAddCounterContainerView


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([NSString StringIsNullOrEmpty:string]) {
        [self endEditing:YES];
        [EasyShowTextView showInfoText:@"不能输入空格"];
        return NO;
    }
    
    return YES;
}



@end
