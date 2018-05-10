//
//  LBMine_PayActivitySucessController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMine_PayActivitySucessController.h"
#import "LBHomeOneDolphinDetailController.h"
#import "LBMine_PayActivitySucesscell.h"
#import "CountDown.h"
#import "LBDolphinRecoderViewController.h"
#import "LBDolphinRecoderViewController.h"

@interface LBMine_PayActivitySucessController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *secondlb;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) CountDown *countDown;

@property (nonatomic, assign) NSInteger  seconds;
@property (nonatomic, strong) NSArray  *dataArr;

@end

static NSString *Mine_PayActivitySucesscell = @"LBMine_PayActivitySucesscell";

@implementation LBMine_PayActivitySucessController
-(void)dealloc{
    [self.countDown destoryTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.countDown destoryTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.secondlb.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"兑换详情";
    self.seconds = 5;
    //    返回按钮
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    button.backgroundColor=[UIColor clearColor];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderDeail"] isEqualToString:@"1"]) {//代表订单调过来
        [button addTarget:self action:@selector(popselfone) forControlEvents:UIControlEventTouchUpInside];
    }else{//代表详情调过来
        [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = ba;
    
    [self.tableview registerNib:[UINib nibWithNibName:Mine_PayActivitySucesscell bundle:nil] forCellReuseIdentifier:Mine_PayActivitySucesscell];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderDeail"] isEqualToString:@"1"]) {//代表订单调过来
        self.secondlb.text = [NSString stringWithFormat:@"%zd秒后自动返回夺宝记录...",self.seconds];
    }else{//代表详情调过来
        self.secondlb.text = [NSString stringWithFormat:@"%zd秒后自动返回商品详情...",self.seconds];
    }
    WeakSelf;
    [self.countDown countDownWithPER_SECBlock:^{
        self.seconds = self.seconds - 1;
        
        if (self.seconds <= 0) {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderDeail"] isEqualToString:@"1"]) {//代表订单调过来
                [weakSelf popselfone];
            }else{//代表详情调过来
                [weakSelf popself];
            }
    
        }else{
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderDeail"] isEqualToString:@"1"]) {//代表订单调过来
                self.secondlb.text = [NSString stringWithFormat:@"%zd秒后自动返回夺宝记录...",self.seconds];
            }else{//代表详情调过来
                self.secondlb.text = [NSString stringWithFormat:@"%zd秒后自动返回商品详情...",self.seconds];
            }
        }
    }];
    
    [self requestdatasource];
}

-(void)requestdatasource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"order_id"] = self.order_id;
    
    [NetworkManager requestPOSTWithURLStr:kIndianaget_lucky_number paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataArr = responseObject[@"data"];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMine_PayActivitySucesscell *cell = [tableView dequeueReusableCellWithIdentifier:Mine_PayActivitySucesscell forIndexPath:indexPath];
    cell.selectionStyle = 0;
    if (self.dataArr.count > 0) {
        cell.numbers.text = [self.dataArr componentsJoinedByString:@"  "];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight = 91;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}


-(void)popself{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LBHomeOneDolphinDetailController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)popselfone{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LBDolphinRecoderViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
//返回主页
- (IBAction)backrootvc:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//查看订单
- (IBAction)checkOrders:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBDolphinRecoderViewController *vc =[[LBDolphinRecoderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CountDown*)countDown{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}

-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
