//
//  LBMineCentermodifyAdressViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCentermodifyAdressViewController.h"
#import "LBMineCentermodifyAdressTableViewCell.h"

#import "LBMineCenterAddAdreassViewController.h"

@interface LBMineCentermodifyAdressViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)UIButton *rightBt;
@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
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
    
    [self setupNpdata];//设置无数据的时候展示
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

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
    self.tableview.tableFooterView = [UIView new];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableview.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableview.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableview.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableview.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"page"] = @(self.page);
    
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


- (void)deleteAddres:(NSInteger)index{
    GLMine_AddressModel *model = self.models[index];
    
    [EasyShowLodingView showLodingText:@"请求中"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"DELETE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"truename"] = model.truename;
    dic[@"province"] = model.address_province;
    dic[@"city"] = model.address_city;
    dic[@"area"] = model.address_area;
    dic[@"is_default"] = @([model.is_default boolValue]);
    dic[@"phone"] = model.phone;
    dic[@"address"] = model.address_address;
    
    dic[@"address_id"] = model.address_id;
      
    [NetworkManager requestPOSTWithURLStr:kAddressed paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshReceivingAddress" object:nil];
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
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
//        [weakSelf setupDefaultSelect:index];
//
//    };
    
    cell.returnEditbt = ^(NSInteger index){
        weakSelf.hidesBottomBarWhenPushed = YES;
        LBMineCenterAddAdreassViewController *vc=[[LBMineCenterAddAdreassViewController alloc]init];
        vc.isEdit = YES;
        vc.model = weakSelf.models[index];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    cell.returnDeletebt = ^(NSInteger index){

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要删除该地址吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deleteAddres:index];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:ok];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    };

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      GLMine_AddressModel  *model = self.models[indexPath.row];
    WeakSelf;
    if (weakSelf.block) {
        weakSelf.block(model);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }

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
        _rightBt.frame = CGRectMake(0, 0, 80, 44);
        _rightBt.backgroundColor = [UIColor clearColor];
        [_rightBt addTarget:self action:@selector(addAdressEvent) forControlEvents:UIControlEventTouchUpInside];
        [_rightBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_rightBt setImage:[UIImage imageNamed:@"添加银行卡"] forState:UIControlStateNormal];
        [_rightBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_rightBt setTitle:@"添加" forState:UIControlStateNormal];
        [_rightBt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
        
    }
    
    return _rightBt;

}

-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
}

//-(NodataView*)nodataV{
//    
//    if (!_nodataV) {
//        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
//        _nodataV.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-114);
//    }
//    return _nodataV;
//    
//}


@end
