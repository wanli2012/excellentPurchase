//
//  LBHomeOneDolphinDetailController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeOneDolphinDetailController.h"
#import "LBHomeOneDolphinDetailHeaderView.h"
#import "LBHomeDolphinDetailSectionHeader.h"

#define kHeaderViewH (410 + UIScreenWidth)

@interface LBHomeOneDolphinDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;


@property (nonatomic, assign) CGFloat lastPageMenuY;

@property (nonatomic, assign) CGPoint lastPoint;

@property (strong, nonatomic) LBHomeOneDolphinDetailHeaderView *headview;

@end

static NSString *ID = @"LBHomeDolphinDetailSectionHeader";

@implementation LBHomeOneDolphinDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"夺宝详情";
    adjustsScrollViewInsets_NO(self.tableview, self);
    [self.view addSubview:self.tableview];
    self.lastPageMenuY = kHeaderViewH;
    self.tableview.tableHeaderView = self.headview;

    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITabelViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 16;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 50;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"edev";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }
    return 0.000001f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        LBHomeDolphinDetailSectionHeader *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
        if (!headerview) {
            headerview = [[LBHomeDolphinDetailSectionHeader alloc]initWithReuseIdentifier:ID];
        }
        WeakSelf;
        headerview.refreshDataosurce = ^(NSInteger index) {
            [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return headerview;
    }
    return nil;
    
    
}

-(UITableView*)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableFooterView = [UIView new];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
    }
    return _tableview;
}

-(LBHomeOneDolphinDetailHeaderView*)headview{
    if (!_headview) {
        _headview = [[NSBundle mainBundle]loadNibNamed:@"LBHomeOneDolphinDetailHeaderView" owner:self options:nil].firstObject;
        _headview.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, kHeaderViewH);
        _headview.autoresizingMask = 0;

    }
    return _headview;
}

@end
