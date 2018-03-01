//
//  LBFaceToFace_PayController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/6.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFaceToFace_PayController.h"
#import "GLMine_Cart_PayCell.h"
#import "GLMine_Cart_PayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "GLMine_PaySucessController.h"//付款状态
#import "HHPayPasswordView.h"

@interface LBFaceToFace_PayController ()<UITableViewDelegate,UITableViewDataSource,HHPayPasswordViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@property (weak, nonatomic) IBOutlet UILabel *orderAllPrice;//订单总价
@property (weak, nonatomic) IBOutlet UILabel *deductionSum;//让利

@property (nonatomic, strong)NSString *payStr;

@end

@implementation LBFaceToFace_PayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"付款";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Cart_PayCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Cart_PayCell"];
    
    self.orderAllPrice.text = [NSString stringWithFormat:@"¥ %@",self.money];
    
    self.deductionSum.text = [NSString stringWithFormat:@"¥ %@",self.rlmoney];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    
    //    返回按钮
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = ba;
    
}

/**
 支付宝支付成功回调
 */
-(void)Alipaysucess{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 微信支付成功回调
 */
-(void)wxpaysucess{
   [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)popself{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)pushsucessVc{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PaySucessController *vc =[[GLMine_PaySucessController alloc]init];
    vc.type = 1;
    vc.method = self.payStr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushFailVc{
   
}

/**
 去付款
 */
- (IBAction)toPay:(id)sender {
    
    if ([NSString StringIsNullOrEmpty:self.payStr]) {
        [EasyShowTextView showText:@"请选择支付方式"];
        return;
    }
    
    if ([self.payStr isEqualToString:@"支付宝支付"]) {
        [self alipayMethod];
    }else if ([self.payStr isEqualToString:@"微信支付"]){
        [self wechatMethod];
    }else if ([self.payStr isEqualToString:@"余额支付"]){
        [self balanceMethod];
    }
    
}
//支付宝支付
/**
 payment_type:
 
 const PAY_TYPE_APP    = 101;//app调起支付
 const PAY_TYPE_WEB    = 102;//手机网页调起支付
 const PAY_TYPE_SCAN   = 103;//扫码支付
 const PAY_TYPE_INSIDE = 104;//第三方内部调起支付(微信jsApi)
 const PAY_TYPE_SELF   = 105;//平台自定义支付 余额、优购币...
 注:带微信支付宝时就不能传105，然后自己找到对应的方式传过来就行了
 */

/**
 turn_type:
 
 const PAY_ALIPAY         = 201;//支付宝支付
 const PAY_WXPAY          = 202;//微信支付
 const PAY_YUE            = 203;//余额支付
 const PAY_ALIPAY_COUPONS = 204;//支付宝+购物券
 const PAY_WXPAY_COUPONS  = 205;//微信+购物券
 const PAY_YUE_COUPONS    = 206;//余额+购物券
 */
-(void)alipayMethod{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"payment_type"] = @"101";
     dic[@"turn_type"] = @"201";
    dic[@"money"] = self.money;
   dic[@"rl_money"] = self.rlmoney;
     dic[@"shop_uid"] = self.shopuid;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:PayFace_pay paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"aliPay"] fromScheme:@"excellentAlipay" callback:^(NSDictionary *resultDic) {
                
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
                   [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr=@"订单正在处理中";
                            break;
                        case 4000:
                            returnStr=@"订单支付失败";
                            break;
                        case 6001:
                            returnStr=@"订单取消";
                            break;
                        case 6002:
                            returnStr=@"网络连接出错";
                            break;
                            
                        default:
                            break;
                    }
                    
                    [EasyShowTextView showErrorText:returnStr];
                    
                }
                
            }];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//微信支付
-(void)wechatMethod{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"turn_type"] = @"202";
    dic[@"payment_type"] = @"101";
    dic[@"money"] = self.money;
    dic[@"rl_money"] = self.rlmoney;
     dic[@"shop_uid"] = self.shopuid;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:PayFace_pay paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.openID=responseObject[@"data"][@"wxPay"][@"appid"];
            req.partnerId = responseObject[@"data"][@"wxPay"][@"partnerid"];
            req.prepayId = responseObject[@"data"][@"wxPay"][@"prepayid"];
            req.nonceStr = responseObject[@"data"][@"wxPay"][@"noncestr"];
            req.timeStamp = [responseObject[@"data"][@"wxPay"][@"timestamp"] intValue];
            req.package = responseObject[@"data"][@"wxPay"][@"package"];
            req.sign = responseObject[@"data"][@"wxPay"][@"sign"];
            [WXApi sendReq:req];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//余额支付
-(void)balanceMethod{

        if ([self.money floatValue] > [[UserModel defaultUser].balance floatValue]) {
            [EasyShowTextView showInfoText:@"余额不足，请充值"];
            return;
        }
    
    HHPayPasswordView *payPasswordView = [[HHPayPasswordView alloc] init];
    payPasswordView.delegate = self;
    [payPasswordView showInView:self.view];
    
}

-(void)passwordView:(HHPayPasswordView *)passwordView didFinishInputPayPassword:(NSString *)password{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"turn_type"] = @"203";
    dic[@"payment_type"] = @"105";
    dic[@"money"] = self.money;
    dic[@"rl_money"] = self.rlmoney;
     dic[@"pass"] = [RSAEncryptor encryptString:password publicKey:public_RSA];
     dic[@"shop_uid"] = self.shopuid;
    
    [NetworkManager requestPOSTWithURLStr:PayFace_pay paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [passwordView paySuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
           
        }else{
            [passwordView payFailureWithPasswordError:YES withErrorLimit:2];
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }

    } enError:^(NSError *error) {
        [passwordView payFailureWithPasswordError:YES withErrorLimit:2];
    }];
    
}
-(void)actionSure:(NSString *)password{
    if (password.length < 6) {
        [EasyShowTextView showInfoText:@"请输入二级密码"];
        return;
    }
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Cart_PayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Cart_PayCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0; i < self.models.count; i ++) {
        
        GLMine_Cart_PayModel *model = self.models[i];
        
        if (i == indexPath.row) {
            self.payStr = model.title;
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
        }
    }
    
    [tableView reloadData];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        NSArray *picArr = @[@"pay-zjifubao",@"pay-weixin",@"pay_jifen"];
        NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付"];
        NSString *str = [NSString stringWithFormat:@"余额：%@",[UserModel defaultUser].balance];
        NSArray *detailArr = @[@"推荐已安装支付宝的用户使用",@"推荐已安装微信的用户使用",str];
        
        for (int i = 0; i < 3; i ++) {
            
            GLMine_Cart_PayModel *model = [[GLMine_Cart_PayModel alloc] init];
            model.picName = picArr[i];
            model.title = titleArr[i];
            model.detail = detailArr[i];
            model.isSelected = NO;
            
            [_models addObject:model];
        }
        
    }
    return _models;
}


@end
