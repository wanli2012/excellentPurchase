//
//  LBHomeOneDolphinPictureDetailController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeOneDolphinPictureDetailController.h"
#import "LBindianaParticipationView.h"
#import "LBindiana_PayController.h"

@interface LBHomeOneDolphinPictureDetailController ()<UIWebViewDelegate>

@property (strong , nonatomic)LBindianaParticipationView *Participationview;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstrait;

@end

@implementation LBHomeOneDolphinPictureDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图文详情";
    _Participationview = [[NSBundle mainBundle]loadNibNamed:@"LBindianaParticipationView" owner:nil options:nil].firstObject;
    _Participationview.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
    _Participationview.frame = self.view.frame;
    _Participationview.indiana_remainder_count = self.indiana_remainder_count;
    [self.view addSubview:_Participationview];
    _Participationview.hidden = YES;
    WeakSelf;
    _Participationview.cancelEvent = ^{
        weakSelf.Participationview.hidden = YES;
    };
    
    _Participationview.sureEvent = ^(NSString *num) {
        [weakSelf sureAdd:num];
    };
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@%@",URL_Base,TmallPdetail,self.good_id];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    
    // 3. 发送请求给服务器
    [self.webview loadRequest:request];
}

- (IBAction)immeditelyJionEvent:(UIButton *)sender {
    
     _Participationview.hidden = NO;
}
//立即参与
-(void)sureAdd:(NSString*)num{
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showErrorText:@"请先登录"];
        return;
    }
    
    if ([num integerValue] > [self.indiana_remainder_count integerValue]) {
        [EasyShowTextView showInfoText:@"已超人数"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"indiana_id"] = self.indiana_id;
    dic[@"count"] = num;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kIndianacreate_indiana_order paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.hidesBottomBarWhenPushed = YES;
            LBindiana_PayController *vc = [[LBindiana_PayController alloc]init];
            vc.datadic = responseObject[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
      
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [EasyShowLodingView showLoding];
}
//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [EasyShowLodingView hidenLoding];
}
//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [EasyShowLodingView hidenLoding];
    [EasyShowTextView showErrorText:error.localizedDescription];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.topconstrait.constant = SafeAreaTopHeight;
}

@end
