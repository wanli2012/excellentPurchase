//
//  predicateModel.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface predicateModel : NSObject
//判断网址格式是否正确
+ (BOOL) isValidateUrl:(NSString *)url;
//判断手机格式是否正确
+ (BOOL) valiMobile:(NSString *)mobile;
//判断邮箱格式是否正确
+ (BOOL) isValidateEmail:(NSString *)email;
//判断身份证格式是否正确
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//判断银行卡格式是否正确
+ (BOOL) IsBankCard:(NSString *)cardNumber;
//判断是否包含汉字
+ (BOOL) IsChinese:(NSString *)str;
//判断是否全是汉字
+ (BOOL)deptNameInputShouldChinese:(NSString *)str;
//判断只含有数字或字母
+(BOOL)judgePassWordLegal:(NSString *)pass;
//判断字符串是否包含数字，字母，或混合
+(int)checkIsHaveNumAndLetter:(NSString*)password;

//textfield 输入判断
//只能输入字母或数字;
+(BOOL)inputShouldLetterOrNum:(NSString *)inputString;
//只能输入字母
+(BOOL)inputShouldLetter:(NSString *)inputString;
//只能输入数字
+(BOOL)inputShouldNumber:(NSString *)inputString;
//只能输入汉字
+(BOOL)inputShouldChinese:(NSString *)inputString;
//只能输入数字和x X
+ (BOOL)inputShouldIDNumber:(NSString *)inputString;

@end
