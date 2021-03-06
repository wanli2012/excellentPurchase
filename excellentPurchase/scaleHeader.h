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
 首页消息 cell的高度
 */
#define bannerHeiget   60
/**
 首页活动图片比例 cell的高度
 */
#define HomeActivityH   292.0/375

/**
 首页底部图片比例
 */
#define bottomScale   460 / 750.0

/**
 吃喝玩乐-精品推荐图片比例
 */
#define EatrecommendScle   93 / 113.0
/**
 吃喝玩乐-吃喝玩乐活动banner图片比例
 */
#define EatActBannerScle   100 / 375.0

/**
 吃喝玩乐-cell的高度
 */
#define EatCellH   120.0

/**宽度比例*/
#define CZH_ScaleWidth(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375)*(__VA_ARGS__)

/**高度比例*/
#define CZH_ScaleHeight(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.height/667)*(__VA_ARGS__)

//海淘商城 商品详情
#define TmallPdetail @"GoodsDetail/goods_detail_view/goods_id/"

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
#define UserCartAdd_cart @"UserCart/add_cart"//海淘商城 加入购物车
#define SeaShoppingSea_store @"SeaShopping/sea_store"//海淘商城店铺信息
#define SeaShoppingStore_goods @"SeaShopping/store_goods"//海淘店铺内-商品列表
#define UserUser_collect @"User/user_collect"//用户收藏列表
#define OrderConfirm_product_order @"Order/confirm_product_order"//用户确认订单
#define OrderAppend_order @"Order/append_order"//用户提交下单
#define PayOrder_payment @"Pay/order_payment"//支付
#define OrderUser_face_order_list @"Order/user_face_order_list"//面对面订单
#define OrderUser_product_order @"Order/user_product_order"//用户商品订单列表
#define OrderHandlerUser_cancel_order @"OrderHandler/user_cancel_order"//用户取消商品订单
#define OrderHandlerUser_order_confirm_get @"OrderHandler/user_order_confirm_get"//用户确认收货
#define OrderUser_product_order_detail @"Order/user_product_order_detail"//用户确认收货
#define OrderAppend_order_wait_pay @"Order/append_order_wait_pay"//待付款重新下单
#define CommentUser_comment @"Comment/user_comment"//用户评论线上已完成订单商品
#define CommentStore_comment @"Comment/store_comment"//线下订单对店家进行评论
#define CommentLine_store_reply @"Comment/line_store_reply"//线下订单商家回复评论
#define CommentStore_order_reply @"Comment/store_order_reply"//商家回复线上订单评论
#define PayFace_pay @"Pay/face_pay"//面对面支付
#define OrderGuess_favorite @"Order/guess_favorite"//支付界面猜你喜欢
#define UserGroomUser_groom_list @"UserGroom/user_groom_list"//用户推荐列表
#define UserGroomGroom_gain @"UserGroom/groom_gain"//查看推荐收益
#define DataNew_data @"Data/new_data"//请求H5首页跑马灯详情
#define shareMalldetail @"Home/SeaMall/MallDetail/goods_id/"//分享店铺
#define shareRegister @"Home/User/Register.html?userid="//分享注册
#define MoneyCenterUser_money @"MoneyCenter/user_money"//用户福宝/购物券
#define OrderStore_face_order_list @"Order/store_face_order_list"//商家面对面订单列表
#define SeaShoppingIndex_sea_goods @"SeaShopping/index_sea_goods"//商城首页店铺类型跳转
#define AccessGet_logisits_info @"Access/get_logisits_info"//获取物流信息
#define kchallenge_order_list @"Challenge/challenge_order_list"//抢购活动订单
#define korder_refund_reason_list @"OrderRefund/order_refund_reason_list"//退款原因列表
#define kOrderRefundorder_refund @"OrderRefund/order_refund"//订单退款申请
#define kAccessget_sky_air @"Access/get_sky_air"//天气接口
#define kIndianaindiana_main @"Indiana/indiana_main"//夺宝首页
#define kIndianaindiana_list @"Indiana/indiana_list"//夺宝记录
#define kIndianalucky_number_detail @"Indiana/lucky_number_detail"//我的幸运号码
#define kIndianabuy_detail @"Indiana/buy_detail"//夺宝购买详情
#define kIndianacreate_indiana_order @"Indiana/create_indiana_order"//夺宝下单
#define kIndianaindiana_goods_detail @"Indiana/indiana_goods_detail"//夺宝详情
#define kIndianaindiana_goods_record @"Indiana/indiana_goods_record"//本期参与记录
#define kIndianaindiana_reward_history @"Indiana/indiana_reward_history"//往期记录
#define kIndianaindiana_slide_history @"Indiana/indiana_slide_history"//商品详情晒图记录
#define kIndianaindiana_detail @"Indiana/indiana_detail"//夺宝计算详情
#define kPayindiana_pay @"Pay/indiana_pay"//夺宝支付
#define kIndianaget_lucky_number @"Indiana/get_lucky_number"//获取夺宝订单的幸运号码
#define kIndianaindiana_wait_slide @"Indiana/indiana_wait_slide"//用户待晒单
#define kIndianaindiana_slide_list @"Indiana/indiana_slide_list"//晒单列表

#endif /* scaleHeader_h */
