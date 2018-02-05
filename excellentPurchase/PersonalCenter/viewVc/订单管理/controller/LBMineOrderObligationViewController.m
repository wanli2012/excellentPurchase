//
//  LBMineOrderObligationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//


#import "LBMineOrderObligationViewController.h"
#import "LBMineOrdersHeaderViewTableViewCell.h"
#import "LBMineOrderDetailViewController.h"
#import "LBMineOrderDetailViewController.h"
#import "LBMineOrderObligationmodel.h"
#import "LBMineOrdersHeaderViewOneCell.h"
#import "LBMineOrdersFooterViewCell.h"

static NSString *mineOrdersHeaderViewTableViewCell = @"LBMineOrdersHeaderViewTableViewCell";
static NSString *mineOrdersHeaderViewOneCell = @"LBMineOrdersHeaderViewOneCell";
static NSString *mineOrdersFooterViewCell = @"LBMineOrdersFooterViewCell";

@interface LBMineOrderObligationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, strong) NSMutableSet  *selectSets;//被选中支付的
@property (weak, nonatomic) IBOutlet UILabel *allpricelb;
@property (nonatomic, assign) CGFloat  pricepay;//选中总金额

@end

@implementation LBMineOrderObligationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
     [self.tableview registerNib:[UINib nibWithNibName:mineOrdersHeaderViewTableViewCell bundle:nil] forCellReuseIdentifier:mineOrdersHeaderViewTableViewCell];
     [self.tableview registerNib:[UINib nibWithNibName:mineOrdersHeaderViewOneCell bundle:nil] forCellReuseIdentifier:mineOrdersHeaderViewOneCell];
     [self.tableview registerNib:[UINib nibWithNibName:mineOrdersFooterViewCell bundle:nil] forCellReuseIdentifier:mineOrdersFooterViewCell];
    
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
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
        }
    }];
    
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(page);
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"status"] = @"1";
    [NetworkManager requestPOSTWithURLStr:OrderUser_product_order paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            if (isDirect) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBMineOrderObligationmodel *model = [LBMineOrderObligationmodel mj_objectWithKeyValues:dic];
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
    LBMineOrderObligationmodel *model = self.dataArr[section];
    return model.goods_data.count + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBMineOrderObligationmodel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return  50;
    }else if (indexPath.row == model.goods_data.count + 1){
         return 90;
    }else{
         return 95;
    }
    return 0;
}
#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBMineOrderObligationmodel *model = self.dataArr[indexPath.section];
    if (indexPath.row == 0) {
        LBMineOrdersHeaderViewOneCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrdersHeaderViewOneCell forIndexPath:indexPath];
        cell.model = model;
        WeakSelf;
        cell.refreshfata = ^(NSIndexPath *indexpath) {
            [weakSelf choosePayOrders:indexPath];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == model.goods_data.count + 1){
        LBMineOrdersFooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrdersFooterViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.button1.backgroundColor = YYSRGBColor(164, 164, 164, 1);
        cell.button2.backgroundColor = MAIN_COLOR;
        [cell.button1 setTitle:@"取消订单" forState:UIControlStateNormal];
        [cell.button2 setTitle:@"去付款" forState:UIControlStateNormal];
        cell.indexpath = indexPath;
        cell.model = model;
        WeakSelf;
        cell.clickbuttonOneEvent = ^(NSIndexPath *indexpath) {//取消订单
            [weakSelf cancelorders:indexPath];
        };
        cell.clickbuttonTwoEvent = ^(NSIndexPath *indexpath) {//去支付
            
        };
        return cell;
    }else{
        LBMineOrdersHeaderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrdersHeaderViewTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         LBMineOrderObligationGoodsmodel *goodmodel = model.goods_data[indexPath.row-1];
        cell.model = goodmodel;
        cell.stausLb.text = @"订单状态: 待付款";
        return cell;
    }
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return label;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self jumpOrdersDetail:indexPath];
    
}
//跳转订单详情
-(void)jumpOrdersDetail:(NSIndexPath*)indexpath{
    LBMineOrderObligationmodel *model = self.dataArr[indexpath.section];
    NSMutableArray *goodidArr = [NSMutableArray array];
    for (int i = 0; i < model.goods_data.count; i++) {
        LBMineOrderObligationGoodsmodel  *gmodel = model.goods_data[i];
        [goodidArr addObject:gmodel.ord_id];
    }
    
    NSString *ord_str = [goodidArr componentsJoinedByString:@"_"];
    self.hidesBottomBarWhenPushed = YES;
    LBMineOrderDetailViewController *vc = [[LBMineOrderDetailViewController alloc]init];
    vc.ord_str = ord_str;
    vc.typeindex = 1;
    vc.shop_uid = model.ord_shop_uid;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 选中或者取消

 @param indexpath 第几列
 */
-(void)choosePayOrders:(NSIndexPath*)indexpath{
    LBMineOrderObligationmodel *model = self.dataArr[indexpath.section];
    if (model.iselect == YES) {//被选中
        [self.selectSets addObject:model];
        self.pricepay = self.pricepay + [model.order_price floatValue];
    }else{//取消选中
        [self.selectSets removeObject:model];
        self.pricepay = self.pricepay - [model.order_price floatValue];
    }
    
    if (self.selectSets.count <= 0) {
        self.bottomView.constant = -50;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }else{
        if (self.bottomView.constant == -50) {
            self.bottomView.constant = 0;
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
    
    self.allpricelb.attributedText=[self addoriginstr: [NSString stringWithFormat:@"合计：%f",self.pricepay] specilstr:@[@(self.pricepay)]];
    
    [_tableview reloadData];
    
}

/**
 取消订单

 @param indexpath 第几列
 */
-(void)cancelorders:(NSIndexPath*)indexpath{
    LBMineOrderObligationmodel *model = self.dataArr[indexpath.section];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i< model.goods_data.count; i++) {
        LBMineOrderObligationGoodsmodel *goodmdel = model.goods_data[i];
        [arr addObject:goodmdel.goods_id];
    }
    
    NSString *ord_str = [arr componentsJoinedByString:@"_"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"ord_str"] = ord_str;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderHandlerUser_cancel_order paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.page = 1;
            [self loadData:self.page refreshDirect:YES];
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
    
}

-(void)repayOders:(NSIndexPath*)indexpath{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"app_handler"] = @"SEARCH";
//    dic[@"uid"] = [UserModel defaultUser].uid;
//    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"ord_str"] = ord_str;
//
//    [NetworkManager requestPOSTWithURLStr:OrderHandlerUser_cancel_order paramDic:dic finish:^(id responseObject) {
//
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
//            self.page = 1;
//            [self loadData:self.page refreshDirect:YES];
//        }else{
//
//            [EasyShowTextView showErrorText:responseObject[@"message"]];
//        }
//
//    } enError:^(NSError *error) {
//        [EasyShowTextView showErrorText:error.localizedDescription];
//    }];
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

-(NSMutableSet*)selectSets{
    if (!_selectSets) {
        _selectSets = [[NSMutableSet alloc]init];
    }
    return _selectSets;
}
@end
