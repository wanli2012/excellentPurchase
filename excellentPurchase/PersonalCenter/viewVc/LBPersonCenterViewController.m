//
//  LBPersonCenterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBPersonCenterViewController.h"
#import "LBMineHeaderView.h"
#import "CCPScrollView.h"
#import "LBMineTableViewCell.h"

#import "LBAccountManagementViewController.h"//个人资料

#import "GLMine_ShoppingCartController.h"//购物车
#import "LBSetUpViewController.h"//设置
#import "GLMine_TeamController.h"//我的团队
#import "GLMine_MessageController.h"//消息中心
#import "LBMineOrderManagerViewController.h"//订单管理
#import "GLMine_PropertyController.h"//我的资产
#import "LBMineCollectionViewController.h"//收藏
#import "LBSwitchAccountViewController.h"//切换账号
#import "GLMine_ManagementController.h"//商家管理
#import "GLMine_MyWalletController.h"//我的钱包

#define kInitHeaderViewOriginY 0
#define kInitHeaderViewHeight 230 + SafeAreaTopHeight  //tableheaderview高度

@interface LBPersonCenterViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,LBMineHeaderViewDelegate>
/**
 头部视图
 */
@property (strong , nonatomic)LBMineHeaderView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**
 数据
 */
@property (strong , nonatomic)NSMutableArray *imageArr;
@property (strong , nonatomic)NSMutableArray *titleArr;

@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组

@end

static NSString *mineTableViewCell = @"LBMineTableViewCell";

@implementation LBPersonCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    adjustsScrollViewInsets_NO(self.tableview, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableview.tableHeaderView = self.headerView;
    self.headerView.delegate = self;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:mineTableViewCell bundle:nil] forCellReuseIdentifier:mineTableViewCell];
    
}

#pragma mark - LBMineHeaderViewDelegate
/**
 跳转到 我的资产
 */
- (void)toMyProperty{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PropertyController *propertyVC = [[GLMine_PropertyController alloc] init];
    [self.navigationController pushViewController:propertyVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 切换账号
 */
- (void)changeAccountEvent{
    
    self.hidesBottomBarWhenPushed = YES;
    LBSwitchAccountViewController *vc =[[LBSwitchAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

/**
 跳转到 个人信息 界面
 */
- (void)toMyInfomation{

    self.hidesBottomBarWhenPushed = YES;
    LBAccountManagementViewController *vc = [[LBAccountManagementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vcstr = self.userVcArr[indexPath.row];
    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titile.text = _titleArr[indexPath.row];
    cell.imagev.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat yOffset = scrollView.contentOffset.y;
    
    
}

-(NSMutableArray*)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray arrayWithObjects:@"mine_merchant",@"mine-shoping",@"mine-orderform",@"mine-pay",@"mine-team",@"otherFunction",@"mine-set",@"mine-news", nil];
    }
    return _imageArr;
}

-(NSMutableArray*)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@"商家管理",@"购物车",@"订单管理",@"我的钱包",@"我的团队",@"其他功能",@"设置",@"消息", nil];
    }
    return _titleArr;
}

-(LBMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"LBMineHeaderView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, UIScreenWidth, kInitHeaderViewHeight);
        _headerView.autoresizingMask = 0;
    }
    
    NSArray *arr = @[@"积分",@"余额",@"购物券",@"优宝",@"优宝单价",@"昨日营业额总量",@"新增积分总量",@"昨日优购币转化"];
    NSArray *valueArr = @[@"23222",@"11",@"0",@"1",@"1",@"2",@"3",@"4444"];
    
    _headerView.titleArr = arr;
    _headerView.valueArr = valueArr;
    
    return _headerView;
}

-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {
        _userVcArr=[NSMutableArray arrayWithObjects:
                    @"GLMine_ManagementController",
                    @"GLMine_ShoppingCartController",
                    @"LBMineOrderManagerViewController",
                    @"GLMine_MyWalletController",
                    @"GLMine_TeamController",
                    @"LBMineOtherFunctionViewController",
                    @"LBSetUpViewController",
                    @"GLMine_MessageController",nil];
        
    }
    
    return _userVcArr;
}
@end
