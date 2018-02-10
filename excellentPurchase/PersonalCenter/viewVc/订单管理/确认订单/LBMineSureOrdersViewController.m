//
//  LBMineSureOrdersViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineSureOrdersViewController.h"
#import "LBMineOrderDetailAdressTableViewCell.h"
#import "LBMineOrderDetailproductsTableViewCell.h"
#import "LBMineOrderDetailprateTableViewCell.h"
#import "LBMineOrderDetailpdiscountsTableViewCell.h"
#import "LBMineSureOrdermessageTableViewCell.h"
#import "LBMineOrderNumbersTableViewCell.h"
#import "LBMineOrderDetailPriceTableViewCell.h"
#import "LBMineOrdersDetailHeaderView.h"
#import "LBMineSureOrdersModel.h"
#import "LBMineCentermodifyAdressViewController.h"
#import "GLMine_Cart_PayController.h"//支付界面
#import "GLMine_AddressModel.h"
#import "LBProductDetailViewController.h"

static NSString *mineOrderDetailAdressTableViewCell = @"LBMineOrderDetailAdressTableViewCell";
static NSString *mineOrderDetailproductsTableViewCell = @"LBMineOrderDetailproductsTableViewCell";
static NSString *mineOrderDetailprateTableViewCell = @"LBMineOrderDetailprateTableViewCell";
static NSString *mineOrderDetailpdiscountsTableViewCell = @"LBMineOrderDetailpdiscountsTableViewCell";
static NSString *mineSureOrdermessageTableViewCell = @"LBMineSureOrdermessageTableViewCell";
static NSString *mineOrderNumbersTableViewCell = @"LBMineOrderNumbersTableViewCell";
static NSString *mineOrderDetailPriceTableViewCell = @"LBMineOrderDetailPriceTableViewCell";

@interface LBMineSureOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *titileArr;
@property (strong, nonatomic) NSArray *productArr;
@property (weak, nonatomic) IBOutlet UILabel *allPrice;//总计
@property (strong, nonatomic) NSMutableArray *modelArr;
@property (strong, nonatomic) GLMine_AddressModel *addressModel;
@property (assign, nonatomic) CGFloat totallPrice;// 总价

@property (strong, nonatomic) NSMutableArray *goods_Arr;// 商品id
@property (strong, nonatomic) NSMutableArray *count_arr;// 数量
@property (strong, nonatomic) NSMutableArray *spec_arr;// 规格
@property (strong, nonatomic) NSMutableDictionary *remarkdic;// 备注

@property (assign, nonatomic) BOOL  refreshAdress;//是否需要更新地址

@end

@implementation LBMineSureOrdersViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.refreshAdress == NO) {
         [self getAddressList];//获取收货地址
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goods_Arr = [NSMutableArray array];
    self.count_arr = [NSMutableArray array];
    self.spec_arr = [NSMutableArray array];
    self.remarkdic = [NSMutableDictionary dictionary];
    [self registertableviewcell];//注册cell
    self.navigationItem.title = @"确认订单";
    for (NSDictionary *dic in self.DataArr) {
      LBMineSureOrdersModel  *model = [LBMineSureOrdersModel mj_objectWithKeyValues:dic];
        self.totallPrice = [model.money floatValue] + self.totallPrice;
        for (int i = 0; i < model.goods_info.count; i++) {
            LBMineSureOrdersGoodInfoModel *pmodel = model.goods_info[i];
            [self.goods_Arr addObject:pmodel.goods_id];
            [self.count_arr addObject:pmodel.goods_num];
            [self.spec_arr addObject:pmodel.spec_id];
        }
        [_remarkdic setObject:@"" forKey:model.shop_uid];
        [self.modelArr addObject:model];
    }
    self.allPrice.text = [NSString stringWithFormat:@"合计: ¥%.2f",self.totallPrice];
    
}

-(void)registertableviewcell{
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailAdressTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailAdressTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailproductsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailproductsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailprateTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailprateTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailpdiscountsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailpdiscountsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineSureOrdermessageTableViewCell bundle:nil] forCellReuseIdentifier:mineSureOrdermessageTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderNumbersTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderNumbersTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailPriceTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailPriceTableViewCell];
    
}
#pragma mark - 收货地址
-(void)getAddressList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [NetworkManager requestPOSTWithURLStr:kaddresses paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
           __block BOOL Stop = NO;
            WeakSelf;
            [responseObject[@"data"][@"page_data"] enumerateObjectsUsingBlock:^(NSDictionary   *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
                if ([dic[@"is_default"] integerValue] == 1) {
                    weakSelf.addressModel = [GLMine_AddressModel mj_objectWithKeyValues:dic];
                    Stop = YES;
                    *stop = YES;//停止循环
                }
            }];
            
            if (Stop == NO && [responseObject[@"data"][@"page_data"]count]>0) {
                self.addressModel = [GLMine_AddressModel mj_objectWithKeyValues:responseObject[@"data"][@"page_data"][0]];
            }
            self.refreshAdress = NO;
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}

#pragma mark - 提交订单
- (IBAction)submitOrder:(id)sender {

    if (!self.addressModel) {
        [EasyShowTextView showText:@"请填写收货地址"];
        return;
    }
    NSString *goods_str = [_goods_Arr componentsJoinedByString:@"_"];
    NSString *count_str = [_count_arr componentsJoinedByString:@"_"];
    NSString *spec_str = [_spec_arr componentsJoinedByString:@"_"];
    NSMutableArray *remarkarr = [[NSMutableArray alloc]init];
    for (NSString *key in self.remarkdic.allKeys) {
        NSString *str = @"";
        if ([NSString StringIsNullOrEmpty:_remarkdic[key]]) {
            str = [NSString stringWithFormat:@"%@: ",key];
        }else{
            str = [NSString stringWithFormat:@"%@:%@",key,_remarkdic[key]];
        }
        [remarkarr addObject:str];
    }
    NSString *remarkstr = [remarkarr componentsJoinedByString:@"_"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"goods_str"] = goods_str;
    dic[@"count_str"] = count_str;
    dic[@"spec_str"] = spec_str;
    dic[@"remark_str"] = remarkstr;
    dic[@"address_id"] = self.addressModel.address_id;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderAppend_order paramDic:dic finish:^(id responseObject) {
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

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return self.modelArr.count + 1; //返回值是多少既有几个分区
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else{
        LBMineSureOrdersModel *model =self.modelArr[section-1];
        return 5 + model.goods_info.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else{
        LBMineSureOrdersModel *model = self.modelArr[indexPath.section-1];
        
        if (indexPath.row >= 0 && indexPath.row < model.goods_info.count) {
            return 90;
        }else if ((indexPath.row >= model.goods_info.count) && (indexPath.row < model.goods_info.count + 2)){
            return 60;
        }else if ((indexPath.row >= model.goods_info.count+2) && (indexPath.row < model.goods_info.count + 4)){
            return 50;
        }else if (indexPath.row == model.goods_info.count+4){
            
            return 60;
        }
    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBMineOrderDetailAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailAdressTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        cell.rightimge.hidden = YES;
//        cell.rightImgeW.constant = 0;
//        cell.adressConstrait.constant = 0;
        
        if (self.addressModel) {
            cell.adresslb.text = [NSString stringWithFormat:@"收货地址：%@",_addressModel.address_address];
            cell.phonelb.text = [NSString stringWithFormat:@"%@",_addressModel.phone];
            cell.namelb.text = [NSString stringWithFormat:@"收货人：%@",_addressModel.truename];
        }
        
        return cell;
    }else{
        LBMineSureOrdersModel *model = self.modelArr[indexPath.section-1];
        
        if (indexPath.row >= 0 && indexPath.row < model.goods_info.count) {
            LBMineOrderDetailproductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailproductsTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = ((LBMineSureOrdersModel*)self.modelArr[indexPath.section-1]).goods_info[indexPath.row];
            return cell;
        }else if ((indexPath.row >= model.goods_info.count) && (indexPath.row < model.goods_info.count + 2)){
            LBMineOrderDetailprateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailprateTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LBMineSureOrdersModel *model =self.modelArr[indexPath.section-1];
            if (indexPath.row == model.goods_info.count) {
                 cell.valueLb.textColor = MAIN_COLOR;
                cell.titileLb.text = @"奖励";
                cell.valueLb.text = [NSString stringWithFormat:@"%@积分+%@购物券",model.reword_mark,model.reword_coupons];
            }else{
                cell.valueLb.textColor = LBHexadecimalColor(0x333333);
                cell.titileLb.text = @"商品金额";
                cell.valueLb.text = [NSString stringWithFormat:@"¥%@",((LBMineSureOrdersModel*)self.modelArr[indexPath.section-1]).money];
            }
            
            return cell;
        }else if ((indexPath.row >= model.goods_info.count+2) && (indexPath.row < model.goods_info.count + 4)){
    
            LBMineOrderDetailPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailPriceTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.valuelb.textColor = LBHexadecimalColor(0x333333);
            if (indexPath.row == model.goods_info.count+2) {
                cell.titile.text = @"运费";
                cell.valuelb.text = [NSString stringWithFormat:@"¥%@",((LBMineSureOrdersModel*)self.modelArr[indexPath.section-1]).send_price];
            }else{
                cell.titile.text = @"购物券抵扣";
                cell.valuelb.text = [NSString stringWithFormat:@"¥%@",((LBMineSureOrdersModel*)self.modelArr[indexPath.section-1]).offset_coupons];
            }
            return cell;
        }else if (indexPath.row == model.goods_info.count+4){
            LBMineSureOrdermessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineSureOrdermessageTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexpath = indexPath;
            cell.returntextview = ^(NSString *text, NSIndexPath *indexpath) {
                LBMineSureOrdersModel *model = _modelArr[indexPath.section-1];
                [_remarkdic removeObjectForKey:model.shop_uid];
                
                [_remarkdic setObject:text forKey:model.shop_uid];
                
            };
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
        LBMineSureOrdersModel *model = self.modelArr[section-1];
        if ([NSString StringIsNullOrEmpty:model.store_name]) {
            headerview.storeLb.text = @"无商店名";
        }else{
            headerview.storeLb.text = [NSString stringWithFormat:@"%@",model.store_name];
        }
        
        headerview.statusLb.text = @"待买家付款";
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
        self.hidesBottomBarWhenPushed =YES;
        LBMineCentermodifyAdressViewController *vc =[[LBMineCentermodifyAdressViewController alloc]init];
        vc.block = ^(GLMine_AddressModel *adressmodel) {
             self.refreshAdress = YES;
            self.addressModel = adressmodel;
            [_tableview reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LBMineSureOrdersModel *model = self.modelArr[indexPath.section-1];
        
        if (indexPath.row >= 0 && indexPath.row < model.goods_info.count) {
           LBMineSureOrdersGoodInfoModel *pmodel = ((LBMineSureOrdersModel*)self.modelArr[indexPath.section-1]).goods_info[indexPath.row];

            self.hidesBottomBarWhenPushed = YES;
            LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
            vc.goods_id = pmodel.goods_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
   
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

-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
@end
