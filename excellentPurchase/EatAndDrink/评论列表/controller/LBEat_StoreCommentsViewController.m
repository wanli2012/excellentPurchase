//
//  LBEat_StoreCommentsViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentsViewController.h"
#import "LBEat_StoreCommentHeaderView.h"
#import "GLNearby_classifyCell.h"

static NSString *nearby_classifyCell = @"GLNearby_classifyCell";

@interface LBEat_StoreCommentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBEat_StoreCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价列表";
    [self.tableview registerNib:[UINib nibWithNibName:nearby_classifyCell bundle:nil] forCellReuseIdentifier:nearby_classifyCell];
    
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
    
    return 120;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:nearby_classifyCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"eat_StoreCommentHeaderView";
    LBEat_StoreCommentHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerview) {
        headerview = [[LBEat_StoreCommentHeaderView alloc]initWithReuseIdentifier:ID];
    }
    
    return headerview;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, UIScreenWidth - 80, 1)];
    footer.backgroundColor = [UIColor redColor];
    
    return footer;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 100.0;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

@end
