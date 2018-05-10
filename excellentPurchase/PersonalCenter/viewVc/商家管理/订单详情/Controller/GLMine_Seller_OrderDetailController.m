//
//  GLMine_Seller_OrderDetailController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Seller_OrderDetailController.h"

#import "LBMineOrderDetailproductsTableViewCell.h"//商品cell
#import "GLMine_Seller_OrderDetail_DiscountCell.h"//优惠cell
#import "GLMine_Seller_OrderDetail_ReciptInfoCell.h"//收货信息
#import "GLMine_Seller_OrderDetail_RemarkCell.h"//备注
#import "GLMine_Seller_OrderDetail_ExpressCell.h"//物流信息

#import "ValuePickerView.h"//单项Picker

@interface GLMine_Seller_OrderDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *numLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//总价
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;//运费
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewH;

@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *ensureDeliveryBtn;//确认发货按钮
@property (weak, nonatomic) IBOutlet UIButton *ensureOrderBtn;//确认订单按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;//取消订单按钮

@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic, copy)NSString *wl_odd_num;//物流单号

@end

@implementation GLMine_Seller_OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBMineOrderDetailproductsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineOrderDetailproductsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Seller_OrderDetail_DiscountCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Seller_OrderDetail_DiscountCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Seller_OrderDetail_ReciptInfoCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Seller_OrderDetail_ReciptInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Seller_OrderDetail_RemarkCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Seller_OrderDetail_RemarkCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Seller_OrderDetail_ExpressCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Seller_OrderDetail_ExpressCell"];
    
    self.pickerView = [[ValuePickerView alloc]init];
    
    if(self.type == 11){;//查询状态 2.待发货 3.已发货 11.已取消
        self.navigationItem.title = @"订单详情";
        self.ensureDeliveryBtn.hidden = YES;
        self.ensureOrderBtn.hidden = NO;
        self.cancelOrderBtn.hidden = NO;
    }else if(self.type == 2){
        self.navigationItem.title = @"订单详情";
        self.ensureDeliveryBtn.hidden = NO;
        self.ensureOrderBtn.hidden = YES;
        self.cancelOrderBtn.hidden = YES;
    }else if(self.type == 3){
        self.navigationItem.title = @"订单详情";
        self.bottomHeight.constant = 0;
        self.ensureDeliveryBtn.hidden = YES;
        self.ensureOrderBtn.hidden = YES;
        self.cancelOrderBtn.hidden = YES;
    }

    [self assignment];
}

//赋值
- (void)assignment {
    
    self.orderNumLabel.text = self.model.order_num;
    self.dateLabel.text = [formattime formateTimeOfDate4:self.model.time];
    self.numLabel.text = [NSString stringWithFormat:@"%@件",self.model.goods_num];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.model.order_money];
    self.freightLabel.text = [NSString stringWithFormat:@"含运费:¥%@",self.model.send_price];
}

/**
 确认发货
 */
- (IBAction)ensureDelivery:(id)sender {
    
    WeakSelf;
    if (self.wl_odd_num.length == 0) {
        [EasyShowTextView showInfoText:@"请填写物流单号"];
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要发货吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GLMine_Branch_OrderModel *model = self.model;
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        for (GLMine_Branch_Order_goodsModel *goods_model in model.goods_data) {
            [arrM addObject:goods_model.ord_id];
        }
        
        NSString *ord_str = [arrM componentsJoinedByString:@"_"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"app_handler"] = @"SEARCH";
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"order_id"] = model.ord_order_id;//主订单id
        dic[@"ord_str"] = ord_str;//子订单字符串 单个 142 多个下划线拼接 456_878_545
        dic[@"wl_odd_num"] = weakSelf.wl_odd_num;//物流单号
        
        [EasyShowLodingView showLoding];
        [NetworkManager requestPOSTWithURLStr:kstore_order_send paramDic:dic finish:^(id responseObject) {
            
            [EasyShowLodingView hidenLoding];
            [LBDefineRefrsh dismissRefresh:self.tableView];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [EasyShowTextView showSuccessText:@"发货成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_RefreshNotification" object:nil];
                
            }else{
                [EasyShowTextView showErrorText:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            
            [LBDefineRefrsh dismissRefresh:self.tableView];
            [EasyShowLodingView hidenLoding];
            [EasyShowTextView showErrorText:error.localizedDescription];
            [self.tableView reloadData];
            
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:ok];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 确认订单
 */
- (IBAction)ensureOrder:(id)sender {
   
}

/**
 取消订单
 */
- (IBAction)cancelOrder:(id)sender {
    
    self.pickerView.dataSource =@[@"其他原因",@"库存不足",@"同城线下交易",@"商品信息错误"];
    
//    self.pickerView.pickerTitle = @"";
//    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"-"];
//        weakSelf.sexTF.text= stateArr[0];
        NSLog(@"-----%@",stateArr[0]);
    };
    
    [self.pickerView show];
}

#pragma mark -UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.model.goods_data.count;
        
    }else{
        
        if (self.type == 1) {//1:已下单 2:待发货 3:已发货
            return 3;
        }else{
            return 4;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LBMineOrderDetailproductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineOrderDetailproductsTableViewCell"];
        cell.selectionStyle = 0;
        cell.goodsModel = self.model.goods_data[indexPath.row];
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            
            GLMine_Seller_OrderDetail_DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_DiscountCell" forIndexPath:indexPath];
            cell.discountLabel.text = [NSString stringWithFormat:@"- ¥%@",self.model.offset_coupons];
            
            CGFloat totalPrice = [self.model.order_money floatValue];
            CGFloat coupon = [self.model.offset_coupons floatValue];
            NSString *reallyPay = [NSString stringWithFormat:@"%.2f",totalPrice - coupon];
            
            cell.reallyPayLabel.text = [NSString stringWithFormat:@"¥%@",reallyPay];
            
            cell.selectionStyle = 0;
            return cell;
            
        }else if(indexPath.row == 1){
            GLMine_Seller_OrderDetail_ReciptInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_ReciptInfoCell" forIndexPath:indexPath];
            
            cell.receiverLabel.text = [NSString stringWithFormat:@"%@(%@)",self.model.get_user,self.model.get_phone];
            cell.addressLabel.text = self.model.get_address;
            
            cell.selectionStyle = 0;
            return cell;
            
        }else if(indexPath.row == 2){
            GLMine_Seller_OrderDetail_RemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_RemarkCell" forIndexPath:indexPath];
            
            cell.markLabel.text = self.model.remark;
            cell.selectionStyle = 0;
            
            return cell;
            
        }else{
            GLMine_Seller_OrderDetail_ExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_ExpressCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            
            if(self.type == 2){// 2:待发货 3:已发货
                cell.expressNumberTF.enabled = YES;
                WeakSelf;
                cell.block = ^(NSString *wl_odd_num) {
                    weakSelf.wl_odd_num = wl_odd_num;
                };
            }else{
                cell.expressNumberTF.enabled = NO;
                cell.expressNumberTF.text = self.model.ord_odd_num;
            }
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        return 110;
    }else{
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.hidesBottomBarWhenPushed = YES;
//    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
//    [self.navigationController pushViewController:dataVC animated:YES];
    
}

@end
