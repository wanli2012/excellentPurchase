//
//  LBPersonCenterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBPersonCenterViewController.h"
#import "LBMineHeaderView.h"
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
    
    [self refreshRequest];
}

#pragma mark - 刷新接口
- (void)refreshRequest{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
   
    [NetworkManager requestPOSTWithURLStr:krefresh paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [UserModel defaultUser].phone = [self judgeStringIsNull:responseObject[@"data"][@"phone"] andDefault:NO];
            [UserModel defaultUser].user_name = [self judgeStringIsNull:responseObject[@"data"][@"user_name"] andDefault:NO];
            [UserModel defaultUser].truename = [self judgeStringIsNull:responseObject[@"data"][@"truename"] andDefault:NO];
            [UserModel defaultUser].tg_status = [self judgeStringIsNull:responseObject[@"data"][@"tg_status"] andDefault:NO];
            [UserModel defaultUser].del = [self judgeStringIsNull:responseObject[@"data"][@"del"] andDefault:NO];
            [UserModel defaultUser].pic = [self judgeStringIsNull:responseObject[@"data"][@"pic"] andDefault:NO];
            [UserModel defaultUser].group_id = [self judgeStringIsNull:responseObject[@"data"][@"group_id"] andDefault:NO];
            [UserModel defaultUser].group_name = [self judgeStringIsNull:responseObject[@"data"][@"group_name"] andDefault:NO];
            [UserModel defaultUser].nick_name = [self judgeStringIsNull:responseObject[@"data"][@"nick_name"] andDefault:NO];
            [UserModel defaultUser].rzstatus = [self judgeStringIsNull:responseObject[@"data"][@"rzstatus"] andDefault:NO];
            [UserModel defaultUser].tjr_name = [self judgeStringIsNull:responseObject[@"data"][@"tjr_name"] andDefault:NO];
            [UserModel defaultUser].tjr_group = [self judgeStringIsNull:responseObject[@"data"][@"tjr_group"] andDefault:NO];
            [UserModel defaultUser].voucher_ratio = [self judgeStringIsNull:responseObject[@"data"][@"voucher_ratio"] andDefault:NO];
            [UserModel defaultUser].mark = [self judgeStringIsNull:responseObject[@"data"][@"mark"] andDefault:YES];
            [UserModel defaultUser].balance = [self judgeStringIsNull:responseObject[@"data"][@"balance"] andDefault:YES];
            [UserModel defaultUser].shopping_voucher = [self judgeStringIsNull:responseObject[@"data"][@"shopping_voucher"] andDefault:YES];
            [UserModel defaultUser].keti_bean = [self judgeStringIsNull:responseObject[@"data"][@"keti_bean"] andDefault:YES];
            [UserModel defaultUser].currency = [self judgeStringIsNull:responseObject[@"data"][@"currency"] andDefault:YES];
            [UserModel defaultUser].Total_money = [self judgeStringIsNull:responseObject[@"data"][@"Total_money"] andDefault:YES];
            [UserModel defaultUser].Total_mark = [self judgeStringIsNull:responseObject[@"data"][@"Total_mark"] andDefault:YES];
            [UserModel defaultUser].Total_currency = [self judgeStringIsNull:responseObject[@"data"][@"Total_currency"] andDefault:YES];
            [UserModel defaultUser].money_sum = [self judgeStringIsNull:responseObject[@"data"][@"money_sum"] andDefault:YES];
            
            [usermodelachivar achive];
            
            [self assignmentHeader];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {

        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

//头视图赋值
- (void)assignmentHeader {
    
    [self.headerView.iconImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    if ([NSString StringIsNullOrEmpty:[UserModel defaultUser].nick_name]) {
        self.headerView.nicknameLabel.text = @"暂无呢称";
    }else{
        self.headerView.nicknameLabel.text = [UserModel defaultUser].nick_name;
    }
    
    self.headerView.IDNumberLabel.text = [UserModel defaultUser].user_name;
    self.headerView.groupTypeLabel.text = [UserModel defaultUser].group_name;
    
    self.headerView.noticeArr = @[@"你",@"号",@"啊"];
    self.headerView.valueArr = @[[UserModel defaultUser].mark,//用户积分
                                [UserModel defaultUser].balance,//用户余额
                                [UserModel defaultUser].shopping_voucher,//用户购物券
                                [UserModel defaultUser].keti_bean,//用户优购币
                                [UserModel defaultUser].currency,//优购币单价
                                [UserModel defaultUser].Total_money,//平台昨日营业额总量
                                [UserModel defaultUser].Total_mark,//平台昨日新增积分总量
                                [UserModel defaultUser].Total_currency,//平台昨日优购币新增
                              ];
    
}

//判空 给数字设置默认值
- (NSString *)judgeStringIsNull:(id )sender andDefault:(BOOL)isNeedDefault{
    
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    
    if ([NSString StringIsNullOrEmpty:str]) {
      
        if (isNeedDefault) {
            return @"0.00";
        }else{
            return @"";
            
        }
    }else{
        return str;
    }
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

    if([vcstr isEqualToString:@"GLMine_TeamController"]){//我的团队
        if([[UserModel defaultUser].rzstatus integerValue] == 0){////用户 认证状态 0没有认证 1:申请实名认证 2审核通过3失败
            [EasyShowTextView showInfoText:@"请先实名认证"];
            return;
        }else if([[UserModel defaultUser].rzstatus integerValue] == 1){
            [EasyShowTextView showInfoText:@"实名认证审核中"];
            return;
        }else if([[UserModel defaultUser].rzstatus integerValue] == 3){
            [EasyShowTextView showInfoText:@"实名认证失败"];
            return;
        }
    }
    
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

#pragma mark - 懒加载

-(NSMutableArray*)imageArr{
    if (!_imageArr) {
        
        switch ([[UserModel defaultUser].group_id integerValue]) {
            case GROUP_SHOP://商家
            {
                _imageArr = [NSMutableArray arrayWithObjects:@"mine_merchant",@"mine-shoping",@"mine-orderform",@"mine-pay",@"otherFunction",@"mine-set",@"mine-news", nil];
            }
                break;
            case GROUP_USER: case GROUP_TG://会员 创客
            {
                _imageArr = [NSMutableArray arrayWithObjects:@"mine-shoping",@"mine-orderform",@"mine-pay",@"otherFunction",@"mine-set",@"mine-news", nil];
            }
                break;
            case GROUP_GJTG:case GROUP_DQ:case GROUP_QY:case GROUP_CD:case GROUP_SD://高级创客 创客中心 区代 市代 省代
            {
                _imageArr = [NSMutableArray arrayWithObjects:@"mine-shoping",@"mine-orderform",@"mine-pay",@"mine-team",@"otherFunction",@"mine-set",@"mine-news", nil];
            }
                break;
                
            default:
                break;
        }
    }
    
    return _imageArr;
}

-(NSMutableArray*)titleArr{
    if (!_titleArr) {
        
        _titleArr = [NSMutableArray arrayWithObjects:@"商家管理",@"购物车",@"订单管理",@"我的钱包",@"我的团队",@"其他功能",@"设置",@"消息", nil];
        
        switch ([[UserModel defaultUser].group_id integerValue]) {
            case GROUP_SHOP://商家
            {
                _titleArr = [NSMutableArray arrayWithObjects:@"商家管理",@"购物车",@"订单管理",@"我的钱包",@"其他功能",@"设置",@"消息", nil];

            }
                break;
            case GROUP_USER: case GROUP_TG://会员 创客
            {
                _titleArr = [NSMutableArray arrayWithObjects:@"购物车",@"订单管理",@"我的钱包",@"其他功能",@"设置",@"消息", nil];
  
            }
                break;
            case GROUP_GJTG:case GROUP_DQ:case GROUP_QY:case GROUP_CD:case GROUP_SD://高级创客 创客中心 区代 市代 省代
            {
                _titleArr = [NSMutableArray arrayWithObjects:@"购物车",@"订单管理",@"我的钱包",@"我的团队",@"其他功能",@"设置",@"消息", nil];

            }
                break;
                
            default:
                break;
        }
    }
    return _titleArr;
}

-(LBMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"LBMineHeaderView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, UIScreenWidth, kInitHeaderViewHeight);
        _headerView.autoresizingMask = 0;
    }
    
    NSArray *arr = @[@"积分",@"余额",@"购物券",@"优购币",@"优购币单价",@"昨日营业额总量",@"新增积分总量",@"昨日优购币转化"];
    
    _headerView.titleArr = arr;
 
    
    return _headerView;
}

-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {

        
        switch ([[UserModel defaultUser].group_id integerValue]) {
            case GROUP_SHOP://商家
            {
                _userVcArr=[NSMutableArray arrayWithObjects:
                            @"GLMine_ManagementController",
                            @"GLMine_ShoppingCartController",
                            @"LBMineOrderManagerViewController",
                            @"GLMine_MyWalletController",
                            @"LBMineOtherFunctionViewController",
                            @"LBSetUpViewController",
                            @"GLMine_MessageController",nil];
                
            }
                break;
            case GROUP_USER: case GROUP_TG://会员 创客
            {
                _userVcArr=[NSMutableArray arrayWithObjects:
                            @"GLMine_ShoppingCartController",
                            @"LBMineOrderManagerViewController",
                            @"GLMine_MyWalletController",
                            @"LBMineOtherFunctionViewController",
                            @"LBSetUpViewController",
                            @"GLMine_MessageController",nil];
                
            }
                break;
            case GROUP_GJTG:case GROUP_DQ:case GROUP_QY:case GROUP_CD:case GROUP_SD://高级创客 创客中心 区代 市代 省代
            {
                _userVcArr=[NSMutableArray arrayWithObjects:
                            @"GLMine_ShoppingCartController",
                            @"LBMineOrderManagerViewController",
                            @"GLMine_MyWalletController",
                            @"GLMine_TeamController",
                            @"LBMineOtherFunctionViewController",
                            @"LBSetUpViewController",
                            @"GLMine_MessageController",nil];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    return _userVcArr;
}
@end
