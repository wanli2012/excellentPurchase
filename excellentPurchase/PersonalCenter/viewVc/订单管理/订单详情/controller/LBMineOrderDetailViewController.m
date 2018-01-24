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

@end

@implementation LBMineOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registertableviewcell];//注册cell
    self.navigationItem.title = @"订单详情";
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

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else{
        return 6 + self.productArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else{
        if (indexPath.row >= 0 && indexPath.row < self.productArr.count) {
            return 90;
        }else if ((indexPath.row >= self.productArr.count) && (indexPath.row < self.productArr.count + 2)){
            return 60;
        }else if ((indexPath.row >= self.productArr.count+2) && (indexPath.row < self.productArr.count + 4)){
            if (self.typeindex != 1 && indexPath.row == self.productArr.count + 3) {
                return 80;
            }
            return 50;
        }else if (indexPath.row == self.productArr.count+4){
            tableView.estimatedRowHeight = 20;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else if (indexPath.row == self.productArr.count+5){
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
        cell.rightimge.hidden = YES;
        cell.rightImgeW.constant = 0;
        cell.adressConstrait.constant = 0;
        return cell;
    }else{
        if (indexPath.row >= 0 && indexPath.row < self.productArr.count) {
            LBMineOrderDetailproductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailproductsTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ((indexPath.row >= self.productArr.count) && (indexPath.row < self.productArr.count + 2)){
            LBMineOrderDetailprateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailprateTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titileLb.text = @"让利";
            cell.valueLb.textColor = MAIN_COLOR;
            return cell;
        }else if ((indexPath.row >= self.productArr.count+2) && (indexPath.row < self.productArr.count + 4)){
            if (self.typeindex != 1 && indexPath.row == self.productArr.count + 3) {
                LBMineOrderDetailpdiscountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailpdiscountsTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            LBMineOrderDetailPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailPriceTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.titileLb.text = self.titileArr[indexPath.row];
//            cell.valueLb.textColor = LBHexadecimalColor(0x333333);
            return cell;
        }else if (indexPath.row == self.productArr.count+4){
            LBMineOrderDetailpmessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailpmessageTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == self.productArr.count+5){
            LBMineOrderNumbersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderNumbersTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    if (self.typeindex == 1) {
        self.viewoneTop.constant = 0;
    }else if (self.typeindex == 2){
        self.viewTwoTop.constant = 0;
    }else if (self.typeindex == 3){
        self.viewTwoTop.constant = 0;
    }else if (self.typeindex == 4){
        self.viewThreeTop.constant = 0;
    }
}

-(NSArray*)titileArr{
    if (!_titileArr) {
        _titileArr = [NSArray arrayWithObjects:@"商品金额",@"运费",@"优券抵扣", nil];
    }
    return _titileArr;
}

-(NSArray*)productArr{
    if (!_productArr) {
        _productArr = [NSArray arrayWithObjects:@"商品金额",@"运费",@"优券抵扣", nil];
    }
    return _productArr;
}

@end
