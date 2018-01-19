//
//  LBEat_StoreClassifyViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreClassifyViewController.h"
#import "GLNearby_classifyCell.h"
#import "LBEat_ActivityFooterView.h"


@interface LBEat_StoreClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;

@end

static NSString *nearby_classifyCell = @"GLNearby_classifyCell";

@implementation LBEat_StoreClassifyViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString *ID = @"eat_ActivityFooterView";
    LBEat_ActivityFooterView *footerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!footerview) {
        footerview = [[LBEat_ActivityFooterView alloc]initWithReuseIdentifier:ID];
    }
    
    return footerview;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 20 * 2 + 15;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
}

@end
