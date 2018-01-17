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

/**
 首页banner图片比例
 */
#define bannerScale   459.0 / 750

/**
 首页banner cell的高度
 */
#define bannerHeiget   60

/**
 首页底部图片比例
 */
#define bottomScale   240 / 750.0

/**
吃喝玩乐-精品推荐图片比例
 */
#define EatrecommendScle   93 / 113.0

/**
 吃喝玩乐-cell的高度
 */
#define EatCellH   120.0

/**宽度比例*/
#define CZH_ScaleWidth(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375)*(__VA_ARGS__)

/**高度比例*/
#define CZH_ScaleHeight(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.height/667)*(__VA_ARGS__)

/**占位图*/
#define PlaceHolder @"shijiyougou"

#endif /* excellentHeader_h */
