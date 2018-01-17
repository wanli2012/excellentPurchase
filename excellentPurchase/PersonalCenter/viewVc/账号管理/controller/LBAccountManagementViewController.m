//
//  LBAccountManagementViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAccountManagementViewController.h"
#import "LBAccountManagementTableViewCell.h"

@interface LBAccountManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *headImge;//头像

@end

static NSString *accountManagementTableViewCell = @"LBAccountManagementTableViewCell";

@implementation LBAccountManagementViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户管理";
//注册cell
    [self.tableview registerNib:[UINib nibWithNibName:accountManagementTableViewCell bundle:nil] forCellReuseIdentifier:accountManagementTableViewCell];
    
    adjustsScrollViewInsets_NO(self.tableview, self);
    
    //   底部视图高度
    self.tableview.tableFooterView.height = 60 ;
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 6;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        LBAccountManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:accountManagementTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
   
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
