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
#define PlaceHolder @"shijiyougou"

#define LBHexadecimalColor(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]
#define CWIPRandom(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define CWIPRandomColor CWIPRandom(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define WeakSelf __weak typeof(self) weakSelf = self;

#endif /* excellentHeader_h */
