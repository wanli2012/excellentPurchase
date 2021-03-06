//
//  Interface.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#ifndef Interface_h
#define Interface_h

#import "LLWebViewController.h"//web页面

//接口需要的固定值
#define kPORT @"3"
#define kAPP_VERSION @"2.0.1"
//#define kAPP_HANDLE @"SEARCH"

#define SUCCESS_CODE 200 //请求或处理成功(请求数据，获取列表、删除数据、添加数据...等操作)
#define PAGE_ERROR_CODE 204//请求成功，未获取到内容(分页未请求到数据,提示已经到底了)
#define ERROR_CODE 400//参数错误
#define OVERDUE_CODE 401//登录过期，或其他未经认证的请求

#define GROUP_SD 2 //省代
#define GROUP_CD 3 //市代
#define GROUP_QY 4 //区代
#define GROUP_DQ 5 //创客中心
#define GROUP_GJTG 6 //高级创客z
#define GROUP_TG 7 //创客
#define GROUP_SHOP 8 //商家
#define GROUP_USER 9 //会员

//captchaid的值是每个产品从后台生成的,
#define CAPTCHAID @"f878a21255674cdcb8e3564e06e73473"
#define USHARE_APPKEY @"5a8174dfa40fa324d70000c4"

//获取appStore上的最新版本号地址
#define GET_VERSION  @"https://itunes.apple.com/lookup?id=1347772440"
//下载地址
#define DOWNLOAD_URL @"https://itunes.apple.com/cn/app/id1347772440?mt=8"

#define RECOMMEND_URL @"https://app.helloyogo.com/index.php/Home/User/Register?tjrid="
//https://app.helloyogo.com/index.php/Home/User/Register?tjrid=SH18426019
//服务条款
#define kProtocol_URL @"https://app.helloyogo.com/H5/all_agreement.html"

//#define URL_Base @"http://192.168.0.20/yogo_dz/htdocs/index.php/App/"//个人本地
//#define URL_Base @"https://app.helloyogo.com/index.php/App/"//线上
#define URL_Base @"http://cs1.diruikai.cn/index.php/App/"//线下服务器

#define share_URL_Base @"https://app.helloyogo.com/index.php/"//分享

#define kGETCODE_URL @"Access/get_verify_code"//获取验证码
#define kREGISTER_URL @"User/register"//注册
#define kLOGIN_URL @"User/sign_up"//登录
#define kForget_Password_URL @"User/forget_user_pwd"//忘记密码
#define kGet_GroupList_URL @"User/get_group_list"//用户分组列表
#define kUpdate_Password_URL @"User/update_sign_pass"//修改登录密码 
#define kReset_Second_Password_URL @"User/user_reset_pwd"//重置二级密码
#define kForget_Second_Password_URL @"User/find_two_pwd"//找回二级密码
#define kUpdate_Phone_First_Password_URL @"User/check_user_phone"//修改绑定手机号第一步
#define kUpdate_Phone_Second_Password_URL @"User/update_user_phone"//修改绑定手机号
#define kget_user_info @"User/get_user_info"//个人资料-峰
#define kuser_relevant @"User/user_relevant"///账号管理
#define kperfect_get_info @"User/perfect_get_info"///完善或修改信息-峰


#define kBankList_URL @"Bank/get_bank_list"//银行卡列表
#define kBank_NameList_URL @"Bank/bank_name_list"//银行列表
#define kBank_addCard_URL @"Bank/add_bank"//添加银行卡
#define kUnbind_Bank_URL @"Bank/unbind_bank"//解除银行卡绑定
#define kSetDefaultCard_URL @"Bank/set_default_bank"//设置默认银行卡

#define kShop_index_URL @"SeaShopping/shop_index"//商城首页

#define kaddresses @"Address/addresses"///收货地址列表-峰
#define kAddressed @"Address/addressed"///添加或编辑地址-峰

#define kgoods_brand_list @"GoodsCate/goods_brand_list"///获取品牌列表
#define kappend_upload @"Upload/append_upload"///上传图片

//#define kget_city_list @"Areas/get_city_list"///三级联动列表-峰

#define kget_assets_log_list @"Assets/get_assets_log_list"///福宝消息记录-王凯
#define kget_coupons_log_list @"Assets/get_coupons_log_list"///购物券变更记录-王凯
#define kget_integral_log_list @"Assets/get_integral_log_list"///个人积分变更-王凯
#define kget_balance_log_list @"Assets/get_balance_log_list"///余额消息记录-王凯

#define kget_money_list @"MoneyCenter/get_money_list"///福宝市值列表
#define kget_back_list @"MoneyCenter/get_back_list"///福宝出售记录
#define kget_mark_list @"MoneyCenter/get_mark_list"///购物券兑换记录
#define kwithdraw_cash @"MoneyCenter/withdraw_cash"///福宝出售
#define ksell_mark @"MoneyCenter/sell_mark"///购物券兑换

#define kstore_type_list @"StoreType/store_type_list"///获取商铺类型-江海林
#define kappend_shop @"Store/append_shop"///开通商家-峰-江海林
#define kstore_info @"Store/store_info"///我的小店 /商铺信息-江海林
#define kstore_goods_list @"Store/store_goods_list"//我的小店/获取商品-江海林
#define kappend_container @"StoreContainer/append_container"//添加货柜-峰-江海林
#define kcontainer_list @"StoreContainer/container_list"//货柜列表-峰-江海林
#define kcontainer_goods_append @"StoreContainer/container_goods_append"//货柜 (添加/编辑)商品-江海林
#define kcontainer_goods_list @"StoreContainer/container_goods_list"//获取(货柜/商品)数据-江海林

#define kcontainer_goods_lower @"StoreContainer/container_goods_lower"//商品下架-江海林
#define kstore_receive @"Store/store_receive"//我的小店获取(商铺资料/改牌照资料)-江海林
#define kstore_info_edit @"Store/store_info_edit"//修改商铺资料/修改招牌照 - 江海林

#define kappend_subordinate @"Team/append_subordinate"///人员配置-江海林
#define kappend_lower @"Team/append_lower"///开通下级-江海林
#define kgoods_cate_subordinate @"GoodsCate/goods_cate_subordinate"//获取,标签,品牌,属性-江海林

#define kstore_line_list @"OrderLine/store_line_list"//商家线下订单列表
#define kagain_commit_order @"OrderLine/again_commit_order"//线下下单重新提交
#define kstore_product_orders @"Order/store_product_orders"//商户订单列表-峰
#define kstore_order_send @"OrderHandler/store_order_send"//商家发货-周永峰
#define kstore_achievement_line @"Store/store_achievement_line"//商家线下订单业绩
#define kstore_achievement @"Store/store_achievement"//商家线上订单业绩
#define kmy_team @"Team/my_team"//团队首页-王凯Team/leaguer_index
#define kleaguer_index @"Team/leaguer_index"//查看下级成员列表--黄炜
#define kleaguer_info @"Team/leaguer_info"//成员资料--黄炜
#define kmen_achievement @"Team/men_achievement"//下级团队业绩列表-王凯
#define kteam_achievement @"Team/team_achievement"//团队列表-王凯
#define kteam_appraisals @"Team/team_appraisals"//团队绩效管理页面
#define kuser_cart_data @"UserCart/user_cart_data"//用户购物车数据
#define kdel_user_cart @"UserCart/del_user_cart"//用户删除购物车
#define kuser_recharge @"UserRecharge/user_recharge"//用户余额充值-江海林
#define kuser_recharge_list @"UserRecharge/user_recharge_list"//获取充值记录-江海林
#define kgive @"UserGive/give"//转赠-峰
#define kreceive_list @"UserGive/receive_list"//转赠和获赠列表-峰
#define kstore_balance @"MoneyCenter/store_balance"//商铺用户余额提现-江海林
#define kstore_balance_list @"MoneyCenter/store_balance_list"//商铺用户余额提现记录-江海林
#define krefresh @"Access/refresh"//数据刷新 - 陈明真
#define kactive_messaging @"Assets/active_messaging"//用户动态消息-江海林
#define ksystem_bulletin @"Assets/system_bulletin"//系统公告-王凯
#define kstore_find @"Store/store_find"//店铺管理 营业额*--黄炜
#define kfast_login @"User/fast_login"//店铺管理 营业额*--黄炜
#define kstore_commit @"OrderLine/store_commit"//线下下单
#define kupdate_tjr @"User/update_tjr"//修改用户推荐人

#define ksave_cart @"UserCart/save_cart"//用户批量改变购物车商品数量--黄炜
#define kstore_son_list @"Store/store_son_list"//分店列表-峰-江海林
#define kappend_shop_son @"Store/append_shop_son"//开通分店-峰-江海林
#define kstore_branch_find @"Store/store_branch_find"//进入分店-江海林
#define kstore_branch_frozen @"Store/store_branch_frozen"//(解冻/冻结)分店
#define kstore_branch_acc @"Store/store_branch_acc"//修改分店密码-江海林
#define kstore_withdraw @"Store/store_withdraw"//分店取消申请
#define kshop_reiterate_save @"Store/shop_reiterate_save"//商铺重申提交-江海林
#define kshop_reiterate_find @"Store/shop_reiterate_find"//商铺重申-江海林
#define kmeber_appraisals_set @"Team/meber_appraisals_set"//团队成员绩效历史记录
#define keamset_list @"Team/set_list"//未设置绩效金额成员列表
#define keamset_money @"Team/set_money"//设置成员绩效金额
#define ChallengeChallenge_list @"Challenge/challenge_list"//限时抢购列表
#define kChallenge_add_notice @"Challenge/challenge_add_notice"//预约提醒
#define kChallenge_trailer_info @"Challenge/challenge_trailer_info"//抢购预告
#define kUserquery_info @"User/query_info"//用户信息资料查询
#define kRedEnvelopered_list @"RedEnvelope/red_list"//发红包记录
#define kRedEnvelopesend_red_gift @"RedEnvelope/send_red_gift"//发红包
#define kIndianasetIndianaAddress @"Indiana/setIndianaAddress"//夺宝选择收货地址
#define kIndianaindiana_slide @"Indiana/indiana_slide"//添加晒图

#endif /* Interface_h */
