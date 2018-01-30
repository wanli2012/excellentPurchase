//
//  LBMineCentermodifyAdressViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCentermodifyAdressViewController.h"
#import "LBMineCentermodifyAdressTableViewCell.h"
#import "GLMine_AddressModel.h"

#import "LBMineCenterAddAdreassViewController.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>
//#import <ReactiveCocoa/NSObject+RACKVOWrapper.h>
//#import "LBMineCenterAddAdreassViewController.h"

//#import "GLConfirmOrderController.h"

@interface LBMineCentermodifyAdressViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)UIButton *rightBt;
@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger  deleteIndex;//删除下标

@end

@implementation LBMineCentermodifyAdressViewController
//设置导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"修改收货地址";
    
    self.tableview.tableFooterView = [UIView new];
    self.tableview.estimatedRowHeight = 105;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCentermodifyAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCentermodifyAdressTableViewCell"];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:self.rightBt];
    
    self.navigationItem.rightBarButtonItem = ba;
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReceivingAddress) name:@"refreshReceivingAddress" object:nil];
    
}

//刷新
-(void)refreshReceivingAddress{
    [self postRequest:YES];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    
    [NetworkManager requestPOSTWithURLStr:kaddresses paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLMine_AddressModel *model = [GLMine_AddressModel mj_objectWithKeyValues:dict];
                [self.models addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableview reloadData];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.models.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCentermodifyAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCentermodifyAdressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    
//    cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"collect_name"]];
////    cell.phoneLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"s_phone"]];
//    cell.phoneLb.text = [NSString stringWithFormat:@"%@*****%@",[self.dataarr[indexPath.row][@"s_phone"] substringToIndex:3],[self.dataarr[indexPath.row][@"s_phone"] substringFromIndex:7]];
//    cell.adressLn.text = [NSString stringWithFormat:@"%@%@",self.dataarr[indexPath.row][@"areas"],self.dataarr[indexPath.row][@"s_address"]];

    WeakSelf;
    
    cell.index = indexPath.row;
//    cell.returnSetUpbt = ^(NSInteger index){
//
////        [weakSelf setupDefaultSelect:index];
//
//    };
    
    cell.returnEditbt = ^(NSInteger index){
        weakSelf.hidesBottomBarWhenPushed = YES;
        LBMineCenterAddAdreassViewController *vc=[[LBMineCenterAddAdreassViewController alloc]init];
        vc.isEdit = YES;
//        vc.dataDic = _dataarr[index];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    cell.returnDeletebt = ^(NSInteger index){

//        self.deleteIndex = index;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除地址吗?" delegate:weakself cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
    };
//
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LBMineCentermodifyAdressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    NSArray *vcsArray = [self.navigationController viewControllers];
//    NSInteger vcCount = vcsArray.count;
//    UIViewController *lastVC = vcsArray[vcCount-2];//最后一个vc是自己，倒数第二个是上一个控制器。
//
//    if([lastVC isKindOfClass:[GLConfirmOrderController class]]){
//
//        self.block(cell.nameLb.text,cell.phoneLb.text,cell.adressLn.text);
//         [self.navigationController popViewControllerAnimated:YES];
//    }
//
}
//添加地址
-(void)addAdressEvent{

    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterAddAdreassViewController *vc=[[LBMineCenterAddAdreassViewController alloc]init];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];

}

////设为默认
//-(void)setupDefaultSelect:(NSInteger)index{
//
////    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:@"shop/setDefaultAddress" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"address_id" : self.dataarr[index][@"address_id"]} finish:^(id responseObject) {
//        [_loadV removeloadview];
//
//        if ([responseObject[@"code"] integerValue]==1) {
//
//            [MBProgressHUD showError:responseObject[@"message"]];
//
//            [self initdatasource];
//
//        }else if ([responseObject[@"code"] integerValue]==3){
//
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }else{
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//    } enError:^(NSError *error) {
//        [_loadV removeloadview];
//
//        [MBProgressHUD showError:error.localizedDescription];
//
//    }];
//
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    //确定
//    if (buttonIndex == 1) {
//
//        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//        [NetworkManager requestPOSTWithURLStr:@"shop/delAddress" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"address_id" : self.dataarr[self.deleteIndex][@"address_id"]} finish:^(id responseObject) {
//            [_loadV removeloadview];
//            [self.tableview.mj_header endRefreshing];
//            [self.tableview.mj_footer endRefreshing];
//            if ([responseObject[@"code"] integerValue]==1) {
//               [MBProgressHUD showError:responseObject[@"message"]];
//                [self.dataarr removeObjectAtIndex:self.deleteIndex];
//                [self.tableview reloadData];
//
//            }else if ([responseObject[@"code"] integerValue]==3){
//
//                [MBProgressHUD showError:responseObject[@"message"]];
//
//            }else{
//                [MBProgressHUD showError:responseObject[@"message"]];
//            }
//        } enError:^(NSError *error) {
//            [_loadV removeloadview];
//            [self.tableview.mj_header endRefreshing];
//            [self.tableview.mj_footer endRefreshing];
//            [MBProgressHUD showError:error.localizedDescription];
//
//        }];
//    }
//}

-(UIButton*)rightBt{

    if (!_rightBt) {
        _rightBt=[UIButton buttonWithType:UIButtonTypeContactAdd];
        _rightBt.frame = CGRectMake(0, 0, 30, 30);
        _rightBt.backgroundColor=[UIColor redColor];
        [_rightBt addTarget:self action:@selector(addAdressEvent) forControlEvents:UIControlEventTouchUpInside];
        [_rightBt setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    }
    
    return _rightBt;

}

-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
    
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-114);
    }
    return _nodataV;
    
}


@end
