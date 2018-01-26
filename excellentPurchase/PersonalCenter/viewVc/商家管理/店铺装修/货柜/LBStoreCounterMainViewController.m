
//
//  LBStoreCounterMainViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreCounterMainViewController.h"
#import "LBStoreCounterMaincell.h"
#import "LBStoreCounterViewController.h"
#import "LBAddCounterView.h"

@interface LBStoreCounterMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *ID = @"LBStoreCounterMaincell";

@implementation LBStoreCounterMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"货柜管理";
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"添加货柜" forState:UIControlStateNormal];
    [button setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(addCounter) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = ba;
}

/**
 添加huo gui
 */
-(void)addCounter{
    [LBAddCounterView addCounterFrame:self.view.frame textfBloack:^(NSString *textfiled) {
        NSLog(@"%@",textfiled);
    }];
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 3; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 55;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        LBStoreCounterMaincell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    LBStoreCounterViewController *vc = [[LBStoreCounterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

@end
