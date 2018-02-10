//
//  LBMineOrderDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderDetailViewController.h"
#import "LBMineOrderDetailAdressTableViewCell.h"
#import "LBMineOrderDetailproductsTableViewCell.h"
#import "LBMineOrderDetailprateTableViewCell.h"
#import "LBMineOrderDetailpdiscountsTableViewCell.h"
#import "LBMineOrderDetailpmessageTableViewCell.h"
#import "LBMineOrderNumbersTableViewCell.h"
#import "LBMineOrderDetailPriceTableViewCell.h"
#import "LBMineOrdersDetailHeaderView.h"
#import "LBMyOrdersDetailModel.h"
#import "LBMineCentermodifyAdressViewController.h"
#import "LBProductDetailViewController.h"
#import "GLMine_Cart_PayController.h"
#import "LBMineEvaluateViewController.h"
#import "LBMineCenterFlyNoticeDetailViewController.h"

static NSString *mineOrderDetailAdressTableViewCell = @"LBMineOrderDetailAdressTableViewCell";
static NSString *mineOrderDetailproductsTableViewCell = @"LBMineOrderDetailproductsTableViewCell";
static NSString *mineOrderDetailprateTableViewCell = @"LBMineOrderDetailprateTableViewCell";
static NSString *mineOrderDetailpdiscountsTableViewCell = @"LBMineOrderDetailpdiscountsTableViewCell";
static NSString *mineOrderDetailpmessageTableViewCell = @"LBMineOrderDetailpmessageTableViewCell";
static NSString *mineOrderNumbersTableViewCell = @"LBMineOrderNumbersTableViewCell";
static NSString *mineOrderDetailPriceTableViewCell = @"LBMineOrderDetailPriceTableViewCell";

@interface LBMineOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *titileArr;
@property (strong, nonatomic) NSArray *productArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewoneTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTwoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewThreeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomVH;

@property (weak, nonatomic) IBOutlet UILabel *orderMoney;//订单金额

@property (strong, nonatomic) LBMyOrdersDetailModel *dataModel;//数据模型

@end

@implementation LBMineOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self registertableviewcell];//注册cell
    [self loadData];//加载数据

}

-(void)loadData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"shop_uid"] = self.shop_uid;
    dic[@"ord_str"] = self.ord_str;
    
    [NetworkManager requestPOSTWithURLStr:OrderUser_product_order_detail paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataModel = [LBMyOrdersDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.orderMoney.attributedText = [self addoriginstr:[NSString stringWithFormat:@"合计：¥%@",self.dataModel.money] specilstr:@[self.dataModel.money]];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
            [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
-(void)registertableviewcell{
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailAdressTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailAdressTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailproductsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailproductsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailprateTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailprateTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailpdiscountsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailpdiscountsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailpmessageTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailpmessageTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderNumbersTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderNumbersTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailPriceTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailPriceTableViewCell];
    
}
//立即付款
- (IBAction)rightNewpay:(UIButton *)sender {
    NSMutableArray *ord_strArr = [NSMutableArray array];
    for (int i = 0; i < self.dataModel.goods_info.count; i++) {
        LBMyOrdersDetailGoodsListModel *goodModel = self.dataModel.goods_info[i];
        [ord_strArr addObject:goodModel.ord_id];
    }
    NSString *ord_str = [ord_strArr componentsJoinedByString:@"_"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"address_id"] = self.dataModel.address_id;
    dic[@"ord_str"] = ord_str;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderAppend_order_wait_pay paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.hidesBottomBarWhenPushed = YES;
            GLMine_Cart_PayController *payVC = [[GLMine_Cart_PayController alloc] init];
            payVC.datadic = responseObject[@"data"];
            [self.navigationController pushViewController:payVC animated:YES];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
//确认收货
- (IBAction)sureReceiving:(UIButton *)sender {
    NSMutableArray *goodidArr = [NSMutableArray array];
    for (int i = 0; i < self.dataModel.goods_info.count; i++) {
        LBMyOrdersDetailGoodsListModel  *gmodel = self.dataModel.goods_info[i];
        [goodidArr addObject:gmodel.ord_id];
    }
    NSString *ord_str = [goodidArr componentsJoinedByString:@"_"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"ord_str"] = ord_str;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderHandlerUser_order_confirm_get paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showErrorText:responseObject[@"message"]];
            if (self.refreshDatasource) {
                self.refreshDatasource();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//查看物流
- (IBAction)checkfly:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterFlyNoticeDetailViewController *vc = [[LBMineCenterFlyNoticeDetailViewController alloc]init];
    vc.codestr = self.dataModel.odd_num;
    [self.navigationController pushViewController:vc animated:YES];
}
//待评论
-(void)replayComment:(NSIndexPath*)indexpath{
    LBMyOrdersDetailGoodsListModel  *gmodel = self.dataModel.goods_info[indexpath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineEvaluateViewController *vc = [[LBMineEvaluateViewController alloc]init];
    vc.goods_id = gmodel.ord_goods_id;
    vc.order_goods_id = gmodel.ord_id;
    vc.replyType = 1;
    vc.goods_name = gmodel.goods_name;
    vc.goods_pic = gmodel.thumb;
    vc.replyFinish = ^{
        gmodel.is_comment = @"1";
        [_tableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.dataModel) {
        return 2;
    }
    return 0; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else{
        return 6 + self.dataModel.goods_info.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else{
        if (indexPath.row >= 0 && indexPath.row < self.dataModel.goods_info.count) {
            return 90;
        }else if ((indexPath.row >= self.dataModel.goods_info.count) && (indexPath.row < self.dataModel.goods_info.count + 2)){
            return 60;
        }else if ((indexPath.row >= self.dataModel.goods_info.count+2) && (indexPath.row < self.dataModel.goods_info.count + 4)){
            if (self.typeindex == 3 && indexPath.row == self.dataModel.goods_info.count + 3) {
                return 80;
            }
            return 50;
        }else if (indexPath.row == self.dataModel.goods_info.count+4){
            if ([NSString StringIsNullOrEmpty:self.dataModel.remark]) {
                return 0;
            }
            tableView.estimatedRowHeight = 20;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else if (indexPath.row == self.dataModel.goods_info.count+5){
            tableView.estimatedRowHeight = 40;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }
    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBMineOrderDetailAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailAdressTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel;
        if (self.typeindex != 1) {
            cell.rightimge.hidden = YES;
        }
        return cell;
    }else{
        if (indexPath.row >= 0 && indexPath.row < self.dataModel.goods_info.count) {
            LBMineOrderDetailproductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailproductsTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.typeindex == 5){
                cell.replayBt.hidden = NO;
            }
            WeakSelf;
            cell.indexpath = indexPath;
            cell.orderModel = self.dataModel.goods_info[indexPath.row];
            cell.waitReply = ^(NSIndexPath *indexpath) {//待评论
                [weakSelf replayComment:indexPath];
            };
            return cell;
        }else if ((indexPath.row >= self.dataModel.goods_info.count) && (indexPath.row < self.dataModel.goods_info.count + 2)){
            LBMineOrderDetailprateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailprateTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == self.dataModel.goods_info.count) {
                cell.titileLb.text = @"奖励";
                cell.valueLb.textColor = MAIN_COLOR;
                 cell.valueLb.text = [NSString stringWithFormat:@"%@积分+%@购物券",self.dataModel.reward_mark,self.dataModel.reward_coupons];
            }else{
                cell.titileLb.text = @"商品金额";
                cell.valueLb.textColor = LBHexadecimalColor(0x333333);
                cell.valueLb.text = [NSString stringWithFormat:@"¥%@",self.dataModel.money];
            }
            return cell;
        }else if ((indexPath.row >= self.dataModel.goods_info.count+2) && (indexPath.row < self.dataModel.goods_info.count + 4)){
            if (self.typeindex == 3 && indexPath.row == self.dataModel.goods_info.count + 3) {
                LBMineOrderDetailpdiscountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailpdiscountsTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = self.dataModel;
                return cell;
            }else{
                LBMineOrderDetailPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailPriceTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.valuelb.textColor = LBHexadecimalColor(0x333333);
                if (indexPath.row == self.dataModel.goods_info.count+2 ) {
                    cell.titile.text = @"运费";
                    cell.valuelb.text = [NSString stringWithFormat:@"¥%@",self.dataModel.send_price];
                }else{
                    cell.titile.text = @"购物券抵扣";
                    cell.valuelb.text = [NSString stringWithFormat:@"¥%@",self.dataModel.coupons];
                }
                
                return cell;
            }
        }else if (indexPath.row == self.dataModel.goods_info.count+4){
            LBMineOrderDetailpmessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailpmessageTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([NSString StringIsNullOrEmpty:self.dataModel.remark]) {
               cell.hidden = YES;
            }
            cell.remark.text = [NSString stringWithFormat:@"留言：%@",self.dataModel.remark];
            return cell;
        }else if (indexPath.row == self.dataModel.goods_info.count+5){
            LBMineOrderNumbersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderNumbersTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.wuliuBt.hidden = YES;
            cell.orderNum.text = [NSString stringWithFormat:@"订单号: %@",self.dataModel.order_num];
            cell.timelb.text = [NSString stringWithFormat:@"下单时间: %@",[formattime formateTimeYM:self.dataModel.time]];
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section != 0) {
        NSString *ID = @"mineOrdersDetailHeaderView";
        LBMineOrdersDetailHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
        if (!headerview) {
            headerview = [[LBMineOrdersDetailHeaderView alloc]initWithReuseIdentifier:ID];
        }
        headerview.model = self.dataModel;
        if (self.typeindex == 1) {
            headerview.statusLb.text = @"等待买家付款";
        }else if (self.typeindex == 3){
            headerview.statusLb.text = @"待收货";
        }
        
        return headerview;
    }
    return nil;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {

        return 0.00001f;;
    }else{
        return 50;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.typeindex != 10) {
            return;
        }
        self.hidesBottomBarWhenPushed =YES;
        LBMineCentermodifyAdressViewController *vc =[[LBMineCentermodifyAdressViewController alloc]init];
        WeakSelf;
        vc.block = ^(GLMine_AddressModel *adressmodel) {
            weakSelf.dataModel.get_user = adressmodel.truename;
            weakSelf.dataModel.get_phone = adressmodel.phone;
            weakSelf.dataModel.get_address = adressmodel.address_address;
            [_tableview reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (indexPath.row >= 0 && indexPath.row < self.dataModel.goods_info.count) {
            self.hidesBottomBarWhenPushed = YES;
            LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
            vc.goods_id = ((LBMyOrdersDetailGoodsListModel*)self.dataModel.goods_info[indexPath.row]).ord_goods_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    if (self.typeindex == 1) {
        self.viewoneTop.constant = 0;
    }else if (self.typeindex == 3){
        self.viewTwoTop.constant = 0;
    }else if (self.typeindex == 5){
         self.viewThreeTop.constant = 0;
    }else if (self.typeindex == 10){
        self.bottomVH.constant = 0;
    }
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

-(NSArray*)titileArr{
    if (!_titileArr) {
        _titileArr = [NSArray arrayWithObjects:@"商品金额",@"运费",@"购物券抵扣", nil];
    }
    return _titileArr;
}

-(NSArray*)productArr{
    if (!_productArr) {
        _productArr = [NSArray arrayWithObjects:@"商品金额",@"运费",@"购物券抵扣", nil];
    }
    return _productArr;
}

@end
