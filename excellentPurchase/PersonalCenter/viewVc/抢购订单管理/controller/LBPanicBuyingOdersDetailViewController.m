//
//  LBPanicBuyingOdersDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBPanicBuyingOdersDetailViewController.h"
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
#import "LBPanicBuyingOdersDetailTableViewCell.h"
#import "LBSnapUpDetailViewController.h"
#import "LBApplyRefundViewController.h"

static NSString *mineOrderDetailAdressTableViewCell = @"LBMineOrderDetailAdressTableViewCell";
static NSString *panicBuyingOdersDetailTableViewCell = @"LBPanicBuyingOdersDetailTableViewCell";
static NSString *mineOrderDetailprateTableViewCell = @"LBMineOrderDetailprateTableViewCell";
static NSString *mineOrderDetailpdiscountsTableViewCell = @"LBMineOrderDetailpdiscountsTableViewCell";
static NSString *mineOrderDetailpmessageTableViewCell = @"LBMineOrderDetailpmessageTableViewCell";
static NSString *mineOrderNumbersTableViewCell = @"LBMineOrderNumbersTableViewCell";
static NSString *mineOrderDetailPriceTableViewCell = @"LBMineOrderDetailPriceTableViewCell";

@interface LBPanicBuyingOdersDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) LBMyOrdersDetailModel *dataModel;//数据模型
@property (weak, nonatomic) IBOutlet UIView *footerview;
@property (weak, nonatomic) IBOutlet UIButton *rightbt;
@property (weak, nonatomic) IBOutlet UIButton *leftbt;
@property (weak, nonatomic) IBOutlet UIButton *refuseBt;

@end

@implementation LBPanicBuyingOdersDetailViewController

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
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderUser_product_order_detail paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (self.typeindex == 1 || self.typeindex == 3 || self.typeindex == 5 || self.typeindex == 2) {
                self.footerview.hidden = NO;
            }
            self.dataModel = [LBMyOrdersDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
-(void)registertableviewcell{
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailAdressTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailAdressTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:panicBuyingOdersDetailTableViewCell bundle:nil] forCellReuseIdentifier:panicBuyingOdersDetailTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailprateTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailprateTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailpdiscountsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailpdiscountsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailpmessageTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailpmessageTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderNumbersTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderNumbersTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailPriceTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailPriceTableViewCell];
}

- (IBAction)EventRight:(UIButton *)sender {
    if (self.typeindex == 1) {
        [self rightNewpay];//去付款
    }else if (self.typeindex == 3){
        [self sureReceiving];
    }else if (self.typeindex == 5){
         [self checkfly];
    }else if (self.typeindex == 2){
        [self requstRefuseEvent:nil];
    }
}
- (IBAction)leftEvent:(UIButton *)sender {
    if (self.typeindex == 1) {
        [self cancelOrders];//取消订单
    }else if (self.typeindex == 3){
        [self checkfly];
    }else if (self.typeindex == 5){
        
    }
}
//申请退款
- (IBAction)requstRefuseEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBApplyRefundViewController *vc = [[LBApplyRefundViewController alloc]init];
    vc.model = self.model;
    WeakSelf;
    vc.refreshdata = ^(NSString *ord_refund_money) {
        weakSelf.typeindex = 7;
        self.dataModel.goods_info[0].ord_refund_money = ord_refund_money;
        [weakSelf updateViewConstraints];
        [weakSelf.tableview reloadData];
        if (weakSelf.refreshDatasource) {
            weakSelf.refreshDatasource();
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

//取消订单
-(void)cancelOrders{
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
    [NetworkManager requestPOSTWithURLStr:OrderHandlerUser_cancel_order paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (self.refreshDatasource) {
                self.refreshDatasource();
            }
             [EasyShowTextView showSuccessText:@"订单取消成功"];
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
//立即付款
- (void)rightNewpay {
   
    if (self.active_status  == 1 || self.active_status  == 2) {
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
        dic[@"is_cart"] = @(0);
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
    }else {
        self.hidesBottomBarWhenPushed = YES;
        LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
        vc.goods_id = self.dataModel.goods_info[0].ord_goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
//确认收货
- (void)sureReceiving {
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
- (void)checkfly {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterFlyNoticeDetailViewController *vc = [[LBMineCenterFlyNoticeDetailViewController alloc]init];
    vc.codestr = self.dataModel.odd_num;
    LBMyOrdersDetailGoodsListModel *model = self.dataModel.goods_info[0];
    vc.imageStr = model.thumb;
    [self.navigationController pushViewController:vc animated:YES];
}
//待评论
-(void)replayComment{
    LBMyOrdersDetailGoodsListModel  *gmodel = self.dataModel.goods_info[0];
    WeakSelf;
    self.hidesBottomBarWhenPushed = YES;
    LBMineEvaluateViewController *vc = [[LBMineEvaluateViewController alloc]init];
    vc.goods_id = gmodel.ord_goods_id;
    vc.order_goods_id = gmodel.ord_id;
    vc.replyType = 1;
    vc.goods_name = gmodel.goods_name;
    vc.goods_pic = gmodel.thumb;
    vc.replyFinish = ^{
        gmodel.is_comment = @"1";
        weakSelf.footerview.hidden = YES;
        [_tableview reloadData];
        if (weakSelf.refreshDatasource) {
            weakSelf.refreshDatasource();
        }
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
            if (self.typeindex == 5 && [self.dataModel.goods_info[0].is_comment integerValue] ==0) {
                return 137;
            }else{
                return 90;
            }
            
        }else if ((indexPath.row >= self.dataModel.goods_info.count) && (indexPath.row < self.dataModel.goods_info.count + 1)){
            return 60;
        }else if ((indexPath.row >= self.dataModel.goods_info.count+1) && (indexPath.row < self.dataModel.goods_info.count + 4)){
            if (indexPath.row == self.dataModel.goods_info.count+3) {
                if (self.typeindex == 7 || self.typeindex == 8 || self.typeindex == 9) {
                    return 50;
                }else{
                    return 0;
                }
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
            LBPanicBuyingOdersDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:panicBuyingOdersDetailTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataModel.goods_info[indexPath.row];
            if (self.typeindex == 5 && [self.dataModel.goods_info[indexPath.row].is_comment integerValue] == 0) {
                cell.replyBT.hidden = NO;
            }else{
                cell.replyBT.hidden = YES;
            }
            cell.gotoReply = ^{
                [self replayComment];
            };
            return cell;
        }else if ((indexPath.row >= self.dataModel.goods_info.count) && (indexPath.row < self.dataModel.goods_info.count + 1)){
            LBMineOrderDetailprateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailprateTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titileLb.text = @"奖励";
            cell.valueLb.textColor = MAIN_COLOR;
            cell.valueLb.text = [NSString stringWithFormat:@"%@积分+%@购物券",self.dataModel.reward_mark,self.dataModel.reward_coupons];
    
            return cell;
        }else if ((indexPath.row >= self.dataModel.goods_info.count+1) && (indexPath.row < self.dataModel.goods_info.count + 4)){
 
                LBMineOrderDetailPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailPriceTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.valuelb.textColor = LBHexadecimalColor(0x333333);
                if (indexPath.row == self.dataModel.goods_info.count+1 ) {
                    cell.titile.text = @"运费";
                    cell.valuelb.text = [NSString stringWithFormat:@"¥%@",self.dataModel.send_price];
                }else  if (indexPath.row == self.dataModel.goods_info.count+2 ) {
                    cell.titile.text = @"实付款(含运费)";
                    NSString *all = [NSString stringWithFormat:@"合计: ¥%.2f",([self.dataModel.send_price floatValue] + [self.dataModel.money  floatValue])];
                    NSString *price = [NSString stringWithFormat:@"¥%.2f",([self.dataModel.send_price floatValue] + [self.dataModel.money  floatValue])];
                    cell.valuelb.attributedText = [self addoriginstr:all specilstr:@[price]];
                    
                }else if (indexPath.row == self.dataModel.goods_info.count+3){
                    if (self.typeindex == 7 || self.typeindex == 8 || self.typeindex == 9) {
                        cell.hidden = NO;
                        if ([self.dataModel.goods_info[0].ord_refund_coupons integerValue] == 0) {
                            cell.valuelb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"¥%@",self.dataModel.goods_info[0].ord_refund_money] specilstr:@[[NSString stringWithFormat:@"¥%@",self.dataModel.goods_info[0].ord_refund_money]]];
                        }else{
                            cell.valuelb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"¥%@ + %@购物券",self.dataModel.goods_info[0].ord_refund_money,self.dataModel.goods_info[0].ord_refund_coupons] specilstr:@[[NSString stringWithFormat:@"¥%@",self.dataModel.goods_info[0].ord_refund_money]]];
                        }
                        switch (self.typeindex) {
                            case 7:
                                cell.titile.text = @"待退款";
                                break;
                            case 8:
                                cell.titile.text = @"已退款";
                                break;
                            case 9:
                                cell.titile.text = @"退款失败";
                                break;
                            default:
                                break;
                        }
                    }else{
                        cell.hidden = YES;
                    }
                }
                
                return cell;

        }else if (indexPath.row == self.dataModel.goods_info.count+4){
            LBMineOrderDetailpmessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailpmessageTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([NSString StringIsNullOrEmpty:self.dataModel.remark]) {
                cell.hidden = YES;
            }
            if ([NSString StringIsNullOrEmpty:self.dataModel.remark]) {
                cell.remark.text = [NSString stringWithFormat:@"留言：暂无留言"];
            }else{
                cell.remark.text = [NSString stringWithFormat:@"留言：%@",self.dataModel.remark];
            }
            
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
        }else if (self.typeindex == 2){
            headerview.statusLb.text = @"待发货";
        }else if (self.typeindex == 3){
            headerview.statusLb.text = @"待收货";
        }else if (self.typeindex == 5){
            if ([self.is_comment integerValue] == 1) {
                headerview.statusLb.text = @"已完成";
            }else{
                headerview.statusLb.text = @"待评价";
            }
        }else if (self.typeindex == 7){
            headerview.statusLb.text = @"退款中";
        }else if (self.typeindex == 8){
            headerview.statusLb.text = @"退款成功";
        }else if (self.typeindex == 9){
            headerview.statusLb.text = @"退款失败";
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
        if (self.typeindex != 1) {
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
            if (self.active_status  == 1 || self.active_status  == 2) {
                self.hidesBottomBarWhenPushed = YES;
                LBSnapUpDetailViewController *vc = [[LBSnapUpDetailViewController alloc]init];
                vc.goods_id = ((LBMyOrdersDetailGoodsListModel*)self.dataModel.goods_info[indexPath.row]).ord_goods_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                self.hidesBottomBarWhenPushed = YES;
                LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
                vc.goods_id = ((LBMyOrdersDetailGoodsListModel*)self.dataModel.goods_info[indexPath.row]).ord_goods_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    switch (self.typeindex) {
        
        case 1:
        {
            self.refuseBt.hidden = YES;
            self.leftbt.layer.borderWidth = 1;
            self.leftbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
            [self.leftbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
            self.leftbt.backgroundColor = [UIColor whiteColor];
            self.rightbt.backgroundColor = MAIN_COLOR;
            [self.rightbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.rightbt.layer.borderWidth = 1;
            self.rightbt.layer.borderColor =[UIColor clearColor].CGColor;
            [self.leftbt setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.rightbt setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            self.leftbt.hidden = YES;
            self.refuseBt.hidden = YES;
            self.rightbt.hidden = NO;
            self.rightbt.layer.borderWidth = 1;
            self.rightbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
            [self.rightbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
            self.rightbt.backgroundColor = [UIColor whiteColor];
            [self.rightbt setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.leftbt.layer.borderWidth = 1;
            self.leftbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
            [self.leftbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
            self.leftbt.backgroundColor = [UIColor whiteColor];
            self.rightbt.backgroundColor = [UIColor whiteColor];
            [self.rightbt setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            self.rightbt.layer.borderWidth = 1;
            self.rightbt.layer.borderColor =MAIN_COLOR.CGColor;
            
            [self.leftbt setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.rightbt setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
                self.leftbt.hidden = YES;
                self.refuseBt.hidden = YES;
                self.rightbt.layer.borderWidth = 1;
                self.rightbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
                [self.rightbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
                self.rightbt.backgroundColor = [UIColor whiteColor];
                [self.rightbt setTitle:@"查看物流" forState:UIControlStateNormal];
        }
            break;
            
        default:
            self.footerview.hidden = YES;
            break;
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

@end
