//
//  LBMineOrderObligationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//


#import "LBMineOrderObligationViewController.h"
#import "LBMineOrdersHeaderViewTableViewCell.h"
#import "LBMineOrdersHeaderView.h"
#import "LBMineOrdersFooterView.h"
#import "LBMineOrderDetailViewController.h"
#import "LBMineSureOrdersViewController.h"

static NSString *mineOrdersHeaderViewTableViewCell = @"LBMineOrdersHeaderViewTableViewCell";

@interface LBMineOrderObligationViewController ()<UITableViewDelegate,UITableViewDataSource,LBMineOrdersHeaderViewdelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView;

@end

@implementation LBMineOrderObligationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     [self.tableview registerNib:[UINib nibWithNibName:mineOrdersHeaderViewTableViewCell bundle:nil] forCellReuseIdentifier:mineOrdersHeaderViewTableViewCell];
    
}
#pragma mark - LBMineOrdersHeaderViewdelegete
-(void)selectpay:(BOOL)ishow{
    
    if (ishow == YES) {

        [UIView animateWithDuration:1 animations:^{
            self.bottomView.constant = 0;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:1 animations:^{
             self.bottomView.constant = -50;
        } completion:^(BOOL finished) {

        }];
    }
    
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 10; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBMineOrdersHeaderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineOrdersHeaderViewTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString *ID = @"mineOrdersFooterView";
    LBMineOrdersFooterView *footerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!footerview) {
        footerview = [[LBMineOrdersFooterView alloc]initWithReuseIdentifier:ID];
        footerview.typeindex = 1;
    }
    
    return footerview;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"mineOrdersHeaderView";
    LBMineOrdersHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerview) {
        headerview = [[LBMineOrdersHeaderView alloc]initWithReuseIdentifier:ID];
        headerview.typeindex = 1;
    }
    headerview.delegate = self;
    return headerview;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 90;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineSureOrdersViewController *vc = [[LBMineSureOrdersViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
