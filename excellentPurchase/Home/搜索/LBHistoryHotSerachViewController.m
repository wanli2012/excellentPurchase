//
//  LBHistoryHotSerachViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHistoryHotSerachViewController.h"
#import "XC_label.h"

@interface LBHistoryHotSerachViewController ()<selectHotOrHistoryDelegate,UITextFieldDelegate>

@property (nonatomic,strong) XC_label  *xcLabel ;

@property (nonatomic,strong)NSMutableArray *dataSource ;//推荐搜索

@property (nonatomic,strong)NSMutableArray *historySource ;//历史搜索

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;


@end

@implementation LBHistoryHotSerachViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES ;
    
    [self hotOptions];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(void)hotOptions
{
    //推荐搜索 ，模拟网络数据
    NSArray *arr = @[@"fes4发发ewrew",@"发顺丰",@"飞舞",@"粉丝纷纷",@"fes",@"发顺丰",@"蜂飞舞",@"粉丝纷纷",@"fes",@"发顺发丰",@"蜂飞舞",@"粉丝发发发发发纷",@"fes",@"发发发顺丰",@"蜂发飞舞",@"粉发发发丝发纷纷",@"发发fes",@"发顺丰",@"蜂飞发舞",@"发",@"粉丝粉丝纷纷粉丝纷纷粉丝纷纷粉丝纷纷粉丝纷纷粉丝纷纷粉丝纷纷粉丝纷纷"];
    
    self.dataSource = [NSMutableArray arrayWithArray:arr];
    //历史搜索 。模拟本地数据库里面拿数据
    NSArray *historyArr =@[@"蜂飞舞",@"粉丝纷纷",@"发顺丰",@"发顺丰",@"发顺丰",@"蜂飞舞",@"粉丝纷纷",@"fes",@"发顺丰",@"蜂飞舞",@"粉丝纷纷",@"fes",@"发顺丰",@"蜂飞舞",@"蜂飞舞",@"粉丝纷纷",@"发顺丰",@"发顺丰",@"发顺丰",@"蜂飞舞",@"粉丝纷纷",@"fes",@"发顺丰",@"蜂飞舞",@"粉丝纷纷",@"fes",@"发顺丰",@"蜂飞舞"];
    self.historySource = [NSMutableArray arrayWithArray:historyArr];
    
    _xcLabel = [[XC_label alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight-SafeAreaTopHeight) AndTitleArr:arr AndhistoryArr:historyArr AndTitleFont:14 AndScrollDirection:UICollectionViewScrollDirectionVertical];
    _xcLabel.delegate = self ;
    _xcLabel.opetionsHeight = 30;
    _xcLabel.isShow_One = YES ;  //默认NO 显示
    _xcLabel.isShow_Two = NO ; //默认NO 显示
    _xcLabel.headTitle_one = @"热门搜索";
    _xcLabel.headTitle_two = @"历史搜索";
    [self.view addSubview:_xcLabel];
}

#pragma mark selectHotOrHistoryDelegate
//选中某个选项
-(void)selectHotOrHistory:(NSString *)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString *)selectTitle{
    [self.view endEditing:YES];
    
    //这里是选中某个选项， 主要处理跳转逻辑
}

//删除历史选项
-(void)deleteHistoryOptions:(NSString *)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString * _Nullable)selectTitle AndNSdataSource:(NSMutableArray * _Nullable)dataSource{
    [self.view endEditing:YES];
    
    
    
    //这里可以删除本地数据 逻辑 UI 已经处理好了。只需要删除暴露在外面对应的数据源就可以了
    
}

//删除热搜选项
-(void)deleteHotOptions:(NSString * _Nullable)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString * _Nullable)selectTitle AndNSdataSource:(NSMutableArray *_Nullable)dataSource
{
    
    //这里可以删除热搜数据 逻辑 UI 已经处理好了。只需要删除暴露在外面对应的数据源就可以了
    
    
}

#pragma mark Xc_serchViewCilckBtn
-(void)cilckCancle{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchresult:(NSString *)resultString{
    
    [self.view endEditing:YES];
    

    //1 ,这里做去重复逻辑
    
    //2 ,去重复逻辑之后直接丢字符串进去，已经处理好了
    
    //搜索了关键字 ，就需要历史记录添加进去
    [_xcLabel insertHistorOptions:resultString];
}




@end
