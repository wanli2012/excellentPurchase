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
#define kAPP_HANDLE @"SEARCH"

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


#define URL_Base @"http://cs5.hytc.gs/index.php/App/"

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
#define kBankList_URL @"Bank/get_bank_list"//银行卡列表
#define kBank_NameList_URL @"Bank/bank_name_list"//银行列表


#endif /* Interface_h */
