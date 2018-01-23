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

static NSString *mineOrderDetailAdressTableViewCell = @"LBMineOrderDetailAdressTableViewCell";
static NSString *mineOrderDetailproductsTableViewCell = @"LBMineOrderDetailproductsTableViewCell";
static NSString *mineOrderDetailprateTableViewCell = @"LBMineOrderDetailprateTableViewCell";
static NSString *mineOrderDetailpdiscountsTableViewCell = @"LBMineOrderDetailpdiscountsTableViewCell";
static NSString *mineSureOrdermessageTableViewCell = @"LBMineSureOrdermessageTableViewCell";
static NSString *mineOrderNumbersTableViewCell = @"LBMineOrderNumbersTableViewCell";

@interface LBMineSureOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *titileArr;

@end

@implementation LBMineSureOrdersViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registertableviewcell];//注册cell
    self.navigationItem.title = @"确认订单";
    
    
}

-(void)registertableviewcell{
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailAdressTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailAdressTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailproductsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailproductsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailprateTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailprateTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderDetailpdiscountsTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderDetailpdiscountsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineSureOrdermessageTableViewCell bundle:nil] forCellReuseIdentifier:mineSureOrdermessageTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:mineOrderNumbersTableViewCell bundle:nil] forCellReuseIdentifier:mineOrderNumbersTableViewCell];
    
    //    返回按钮
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    [button setImage:[UIImage imageNamed:@"return-w"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = ba;
    
}

-(void)popself{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 5; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return self.titileArr.count;
    }else if (section == 4){
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 70;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 1){
        return 90;
    }else if (indexPath.section == 2){
        return 50;
    }else if (indexPath.section == 3){
       
        return 50;
    }else if (indexPath.section == 4){
        return 100;
    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBMineOrderDetailAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailAdressTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        LBMineOrderDetailproductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailproductsTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        LBMineOrderDetailprateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailprateTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titileLb.text = @"让利";
        cell.valueLb.textColor = MAIN_COLOR;
        return cell;
    }else if (indexPath.section == 3){
        
        LBMineOrderDetailprateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrderDetailprateTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titileLb.text = self.titileArr[indexPath.row];
        cell.valueLb.textColor = LBHexadecimalColor(0x333333);
        return cell;
        
    }else if (indexPath.section == 4){
        LBMineSureOrdermessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineSureOrdermessageTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return label;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.000001;
    }else if (section == 1){
        return 1;
    }else {
        return 10;
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
    
    
}

-(NSArray*)titileArr{
    if (!_titileArr) {
        _titileArr = [NSArray arrayWithObjects:@"商品金额",@"运费",@"优券抵扣", nil];
    }
    return _titileArr;
}


@end
