//
//  GLRecommendController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendController.h"
#import "LBRecommendRecoderViewController.h"

@interface GLRecommendController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *versionLb;
@property (strong, nonatomic) NSString *recommendUrl;

@end

@implementation GLRecommendController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.title = @"推荐";

    self.contentV.layer.cornerRadius = 5.f;
    self.contentV.clipsToBounds = YES;

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

//设置导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

}
//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",RECOMMEND_URL,[UserModel defaultUser].user_name];
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
