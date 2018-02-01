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

//海淘商城 商品详情
#define TmallPdetail @"http://192.168.0.130/yogo_dz/htdocs/index.php/App/GoodsDetail/goods_detail_view/goods_id/"

//接口

#define HappyPlayBanner @"Happy/play_banner"//吃喝玩乐首页banner
#define HappyHappy @"Happy/happy"//吃喝玩乐数据展示
#define HappyCateData @"Happy/cate_data"//吃喝玩乐分类
#define HappyHotSearch @"Happy/hot_seach"//吃喝玩乐热门搜索
#define HappySearchPlay @"Happy/search_play"//吃喝玩乐搜索关键字
#define HappyShopData @"Happy/shop_data"//吃喝玩乐商店详情
#define SeaShoppingUser_collect @"SeaShopping/user_collect"//吃喝玩乐商店详情收藏
#define SeaShoppingNot_collect @"SeaShopping/not_collect"//吃喝玩乐商店详情取消收藏
#define HappyStore_comment_list @"Happy/store_comment_list"//店铺评论列表
#define HappyGoodsData @"Happy/goods_data"//吃喝玩乐商品详情
#define SeaShoppingNav_cate @"SeaShopping/nav_cate"//海淘商城一级分类
#define SeaShoppingCate_list @"SeaShopping/cate_list"//海淘商城二级分类
#define SeaShoppingSea_index @"SeaShopping/sea_index"//海淘商城首页
#define SeaShoppingGoods_search @"SeaShopping/goods_search"//海淘搜索、分类筛选
#define SeaShoppingMore_goods @"SeaShopping/more_goods"//海淘商城 更多数据
#define SeaShoppingHot_seach @"SeaShopping/hot_seach"//海淘商城 热门搜索
#define SeaShoppingGoods_data @"SeaShopping/goods_data"//海淘商城 商品详情
#define SeaShoppingGoods_comment_list @"SeaShopping/goods_comment_list"//海淘商城 评论更多


#endif /* scaleHeader_h */
