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

@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *ensureDeliveryBtn;//确认发货按钮
@property (weak, nonatomic) IBOutlet UIButton *ensureOrderBtn;//确认订单按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;//取消订单按钮

@property (nonatomic, strong) ValuePickerView *pickerView;

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
    
    if(self.type == 1){//1:已下单 2:待发货 3:已发货
        self.navigationItem.title = @"确认订单";
        self.ensureDeliveryBtn.hidden = YES;
        self.ensureOrderBtn.hidden = NO;
        self.cancelOrderBtn.hidden = NO;
    }else if(self.type == 2){
        self.navigationItem.title = @"确认发货";
        self.ensureDeliveryBtn.hidden = NO;
        self.ensureOrderBtn.hidden = YES;
        self.cancelOrderBtn.hidden = YES;
    }else{
        self.navigationItem.title = @"已发货详情";
        self.bottomHeight.constant = 0;
        self.ensureDeliveryBtn.hidden = YES;
        self.ensureOrderBtn.hidden = YES;
        self.cancelOrderBtn.hidden = YES;
    }
    
}

/**
 确认订单
 */
- (IBAction)ensureOrder:(id)sender {
    NSLog(@"确认订单");
}

/**
 取消订单
 */
- (IBAction)cancelOrder:(id)sender {
    
    self.pickerView.dataSource =@[@"其他原因",@"库存不足",@"同城线下交易",@"商品信息错误"];
    
//    self.pickerView.pickerTitle = @"";
//    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
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
        
        return 2;
        
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
        //    cell.model = self.models[indexPath.row];
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            GLMine_Seller_OrderDetail_DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_DiscountCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            return cell;
        }else if(indexPath.row == 1){
            GLMine_Seller_OrderDetail_ReciptInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_ReciptInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            return cell;
        }else if(indexPath.row == 2){
            GLMine_Seller_OrderDetail_RemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_RemarkCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            return cell;
        }else{
            GLMine_Seller_OrderDetail_ExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Seller_OrderDetail_ExpressCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            if(self.type == 2){// 2:待发货 3:已发货
                cell.expressNumberTF.enabled = YES;
            }else{
                cell.expressNumberTF.enabled = NO;
                cell.expressNumberTF.text = @"774738847788";
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
