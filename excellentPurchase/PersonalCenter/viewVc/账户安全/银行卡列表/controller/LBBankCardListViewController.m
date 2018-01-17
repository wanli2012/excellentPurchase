
//
//  LBBankCardListViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBBankCardListViewController.h"
#import "LBBankCardListTableViewCell.h"
#import "LBAddBankCardViewController.h"

@interface LBBankCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
/**
 数据
 */
@property (strong, nonatomic) NSArray *dataArr;

@end

static NSString *bankCardListTableViewCell = @"LBBankCardListTableViewCell";

@implementation LBBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"银行卡";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:bankCardListTableViewCell bundle:nil] forCellReuseIdentifier:bankCardListTableViewCell];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"添加银行卡"] style:UIBarButtonItemStylePlain target:self action:@selector(addBanCard)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

/**
 添加银行卡
 */
-(void)addBanCard{
    
    self.hidesBottomBarWhenPushed = YES;
    LBAddBankCardViewController *vc =[[LBAddBankCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 10; //返回值是多少既有几个分区
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBBankCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCardListTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    return cell;
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerLabel = [[UIView alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor whiteColor];
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
