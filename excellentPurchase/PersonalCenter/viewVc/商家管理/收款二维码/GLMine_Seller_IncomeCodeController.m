//
//  GLMine_Seller_IncomeCodeController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Seller_IncomeCodeController.h"
#import "LBRecommendRecoderViewController.h"

@interface GLMine_Seller_IncomeCodeController ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图标
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;//ID号

@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;//二维码

//@property (weak, nonatomic) IBOutlet UIButton *setMoneyBtn;//设置金额
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setMoneyHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyViewHeight;//金额view 高度
@property (weak, nonatomic) IBOutlet UIView *moneyView;//金额view
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *noprofitLabel;

@end

@implementation GLMine_Seller_IncomeCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.type == 1){
        self.navigationItem.title = @"我的二维码";
        self.moneyViewHeight.constant = 0;
        self.moneyView.hidden = YES;
        
    }else{
        self.navigationItem.title = @"商家收款二维码";
        self.moneyViewHeight.constant = 45;
        self.moneyView.hidden = NO;
        
        self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.moneyCount];
        self.noprofitLabel.text = [NSString stringWithFormat:@"让利金额:¥%@",self.noProfitMoney];
        
    }
    
    [self logoQrCode];
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.IDLabel.text = [UserModel defaultUser].user_name;
    
    if([UserModel defaultUser].truename.length == 0){
        self.nameLabel.text = @"真实姓名:未完善";
        
    }else{
        self.nameLabel.text = [UserModel defaultUser].truename;
    }
    
    //自定义导航栏右键
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(UIScreenWidth - 60, 14, 60, 30);
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightBtn setTitle:@"推荐记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addTarget:self  action:@selector(recommendRecord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self logoQrCode];
    
}

//跳转到推荐记录
- (void)recommendRecord {
    self.hidesBottomBarWhenPushed = YES;
    LBRecommendRecoderViewController *recordVC = [[LBRecommendRecoderViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}


/**
 设置金额
 */
- (IBAction)setMoney:(id)sender {
    NSLog(@" 设置金额");
    
}

//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    NSString *contentStr;
    
    if(self.type == 1){
        contentStr = [NSString stringWithFormat:@"%@%@",RECOMMEND_URL,[UserModel defaultUser].user_name];
        
    }else{//商家收款码
        NSString *str = [NSString stringWithFormat:@"{\"shopuid\":%@,\"money\":%@,\"rlmoney\":%@}",[UserModel defaultUser].uid,self.moneyCount,self.noProfitMoney];
        contentStr = str;
    }
    
    //    NSString *contentStr = @"";
    NSData *qrImageData = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@"mine_logo"];
    
    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    //设置图片
    self.codeImageV.image = finalyImage;
}

@end
