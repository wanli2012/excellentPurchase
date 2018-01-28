//
//  scaleHeader.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#ifndef scaleHeader_h
#define scaleHeader_h

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


//接口

#define HappyPlayBanner @"Happy/play_banner"//吃喝玩乐首页banner
#define HappyHappy @"Happy/happy"//吃喝玩乐数据展示

#endif /* scaleHeader_h */
