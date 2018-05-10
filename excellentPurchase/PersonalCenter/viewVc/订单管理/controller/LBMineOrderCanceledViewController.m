//
//  LBMineOrderCanceledViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderCanceledViewController.h"
#import "LBMineOrderDetailViewController.h"
#import "LBMineSureOrdersViewController.h"
#import "LBPanicBuyingOdersModel.h"
#import "LBPanicBuyingOdersTableViewCell.h"
#import "LBPanicOrdersHeaderrView.h"
#import "LBMineCenterFlyNoticeDetailViewController.h"
#import "LBMineEvaluateViewController.h"
#import "LBEatShopProdcutClassifyViewController.h"
#import "LBProductDetailViewController.h"
#import "LBApplyRefundViewController.h"

static NSString *panicBuyingOdersTableViewCell = @"LBPanicBuyingOdersTableViewCell";

@interface LBMineOrderCanceledViewController ()<UITableViewDelegate,UITableViewDataSource,LBPanicBuyingOdersdelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;

@end

@implementation LBMineOrderCanceledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self.tableview registerNib:[UINib nibWithNibName:panicBuyingOdersTableViewCell bundle:nil] forCellReuseIdentifier:panicBuyingOdersTableViewCell];
    
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
}
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
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    }];
}

-(void)setuprefrsh{
    WeakSelf;
    [self loadData:self.page refreshDirect:YES];
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:weakSelf.tableview];
        }else{
            weakSelf.page = weakSelf.page + 1;
            [weakSelf loadData:weakSelf.page refreshDirect:NO];
        }
    }];
    
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(page);
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"status"] = @"10";//订单状态 1:待付款 3.待收货 5.已完成 10.已取消
    [NetworkManager requestPOSTWithURLStr:OrderUser_product_order paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            if (isDirect) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBPanicBuyingOdersModel *model = [LBPanicBuyingOdersModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count <= 0) {
                [EasyShowTextView showInfoText:@"没有数据啦!!!"];

            }
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.dataArr.count; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight = 80;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}
#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBPanicBuyingOdersModel *model = self.dataArr[indexPath.section];
    LBPanicBuyingOdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBPanicBuyingOdersTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jumpType = 1;
    cell.model = model.goods_data;
    cell.indexpath = indexPath;
    cell.delegete = self;
    return cell;
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *ID = @"LBPanicOrdersHeaderrView";
    LBPanicBuyingOdersModel *model = self.dataArr[section];
    LBPanicOrdersHeaderrView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerview) {
        headerview = [[LBPanicOrdersHeaderrView alloc]initWithReuseIdentifier:ID];
    }
    headerview.model = model.goods_data;
    WeakSelf;
    headerview.jumpmerchat = ^(NSString *store_id) {
        weakSelf.hidesBottomBarWhenPushed = YES;
        LBEatShopProdcutClassifyViewController *vc = [[LBEatShopProdcutClassifyViewController alloc]init];
        vc.store_id = store_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return headerview;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBPanicBuyingOdersModel *model = self.dataArr[indexPath.section];
   
    self.hidesBottomBarWhenPushed = YES;
    LBMineOrderDetailViewController *vc = [[LBMineOrderDetailViewController alloc]init];
    vc.ord_str = model.goods_data.ord_id;
    vc.typeindex = [model.goods_data.ord_status integerValue];
    vc.shop_uid = model.goods_data.ord_shop_uid;
    vc.active_status =  [model.goods_data.active.active_status integerValue];
    vc.model = model;
    vc.is_comment = model.goods_data.is_comment;
    WeakSelf;
    vc.refreshDatasource = ^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - LBPanicBuyingOdersdelegete
//取消订单
-(void)cancelOrders:(NSString *)ord_id{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"ord_str"] = ord_id;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderHandlerUser_cancel_order paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.page = 1;
            [self loadData:self.page refreshDirect:YES];
            [EasyShowTextView showSuccessText:@"订单取消成功"];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
-(void)GoPayOrders:(NSIndexPath *)indexpath{

    LBPanicBuyingOdersModel *model = self.dataArr[indexpath.section];
    self.hidesBottomBarWhenPushed = YES;
    LBMineOrderDetailViewController *vc = [[LBMineOrderDetailViewController alloc]init];
    vc.ord_str = model.goods_data.ord_id;
    vc.typeindex = [model.goods_data.ord_status integerValue];
    vc.shop_uid = model.goods_data.ord_shop_uid;
    vc.active_status =  [model.goods_data.active.active_status integerValue];
    vc.model = model;
    vc.is_comment = model.goods_data.is_comment;
    WeakSelf;
    vc.refreshDatasource = ^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)checklogistics:(NSIndexPath *)indexpath{
    LBPanicBuyingOdersModel *model = self.dataArr[indexpath.section];
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterFlyNoticeDetailViewController *vc = [[LBMineCenterFlyNoticeDetailViewController alloc]init];
    vc.codestr = model.goods_data.ord_odd_num;
    vc.imageStr = model.goods_data.thumb;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sureReciveGoods:(NSIndexPath *)indexpath{
    LBPanicBuyingOdersModel *model = self.dataArr[indexpath.section];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"ord_str"] = model.goods_data.ord_id;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderHandlerUser_order_confirm_get paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.page = 1;
            [self loadData:self.page refreshDirect:YES];
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

-(void)Goevaluate:(NSIndexPath *)indexpath{
    LBPanicBuyingOdersModel *model = self.dataArr[indexpath.section];
    self.hidesBottomBarWhenPushed = YES;
    LBMineEvaluateViewController *vc = [[LBMineEvaluateViewController alloc]init];
    vc.goods_id = model.goods_data.goods_id;
    vc.order_goods_id = model.goods_data.ord_id;
    vc.replyType = 1;
    vc.goods_name = model.goods_data.goods_name;
    vc.goods_pic = model.goods_data.thumb;
    vc.replyFinish = ^{
        model.goods_data.is_comment = @"1";
        [_tableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//申请退款
-(void)applyRefund:(NSIndexPath *)indexpath{
    self.hidesBottomBarWhenPushed = YES;
    LBApplyRefundViewController *vc = [[LBApplyRefundViewController alloc]init];
    vc.model = self.dataArr[indexpath.section];
    WeakSelf;
    vc.refreshdata = ^(NSString *ord_refund_money){
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:rang];
    }
    return noteStr;
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}
@end
