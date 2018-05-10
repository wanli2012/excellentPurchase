//
//  excellentHeader.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#ifndef excellentHeader_h
#define excellentHeader_h

#define YYSRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/**占位图*/
#define PlaceHolder @"shangpinxiangqing"

#define LBHexadecimalColor(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]
#define CWIPRandom(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define CWIPRandomColor CWIPRandom(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define CZHRGBColor(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define WeakSelf __weak typeof(self) weakSelf = self;

//公钥RSA
#define public_RSA @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFbG/E41tZhkU0A0a+6TzukEYGns55LSe9yOWo4/0a2Qy6ZoTeujKJAm1CLgSUPH9nYOOMi+g32wIF+FTJfNrsBSKKw66jRefMVO5G0WhQg6k/dG26KoSEpg/fEl7CZKXS0vEzBT6U5eVDplCAt0918Ere5PNujx9GzDOFEKss+QIDAQAB"

#endif /* excellentHeader_h */
