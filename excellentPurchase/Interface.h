//
//  Interface.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#ifndef Interface_h
#define Interface_h

//接口需要的固定值
#define kPORT @"3"
#define kAPP_VERSION @"1.0.0"
//#define kAPP_HANDLE @"SEARCH"

#define SUCCESS_CODE 200 //请求或处理成功(请求数据，获取列表、删除数据、添加数据...等操作)
#define PAGE_ERROR_CODE 204//请求成功，未获取到内容(分页未请求到数据,提示已经到底了)
#define ERROR_CODE 400//参数错误
#define OVERDUE_CODE 401//未经授权的(登录过期，或其他未经认证的请求)

/*以下状态码为错误状态码-将不会返回任何实体数据，它会将错误返回在http响应头*/
//#define LOGIC_ERROR_CODE 403// 被禁止的 服务器上文件或目录的权限导致
//#define LOGIC_ERROR_CODE 404  //未找到资源
//#define LOGIC_ERROR_CODE 405  //请求方法不被允许(验证post和get或其他方式的请求)
//#define LOGIC_ERROR_CODE 500  //服务器内部错误

//captchaid的值是每个产品从后台生成的,
#define CAPTCHAID @"e81c8a046b5e4d08999ef30e01999e35"


//获取appStore上的最新版本号地址
#define GET_VERSION  @"https://itunes.apple.com/lookup?id=1300026210"
//下载地址
#define DOWNLOAD_URL @"https://itunes.apple.com/cn/app/id1300026210?mt=8"

#define URL_Base @"http://cs5.hytc.gs/index.php/App/"

//#define Xianxia_Base @"http://192.168.0.165/yogo_dz/htdocs/index.php/App"

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

#define kget_city_list @"Areas/get_city_list"///三级联动列表-峰

#define kget_assets_log_list @"Assets/get_assets_log_list"///优购币消息记录-王凯
#define kget_coupons_log_list @"Assets/get_coupons_log_list"///购物券变更记录-王凯
#define kget_integral_log_list @"Assets/get_integral_log_list"///个人积分变更-王凯
#define kget_balance_log_list @"Assets/get_balance_log_list"///余额消息记录-王凯

#define kget_money_list @"MoneyCenter/get_money_list"///优购币市值列表
#define kget_back_list @"MoneyCenter/get_back_list"///优购币出售记录
#define kget_mark_list @"MoneyCenter/get_mark_list"///购物券兑换记录
#define kwithdraw_cash @"MoneyCenter/withdraw_cash"///优购币出售
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

#endif /* Interface_h */
