//
//  LBMineCollectionProductViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCollectionProductViewController.h"
#import "LBMineCollectionProductTableViewCell.h"
#import "POP.h"

@interface LBMineCollectionProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray    *listData;
@property (strong, nonatomic) UIView            *editingView;

@end

static NSString *mineCollectionProductTableViewCell = @"LBMineCollectionProductTableViewCell";

@implementation LBMineCollectionProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    adjustsScrollViewInsets_NO(self.tableview, self);
    [self Adds];
   
    self.listData = [NSMutableArray array];
    for (int i = 0; i<40; i++) {
        [self.listData addObject:@(i)];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showEditview) name:@"showEditview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissEditview) name:@"dismissEditview" object:nil];
}

-(void)dismissEditview{
    [self.tableview setEditing:NO animated:YES];
    
    [self showEitingView:NO];
}
-(void)showEditview{
    if (self.listData.count == 0) {
        return;
    }
    [self.tableview setEditing:YES animated:YES];
    [self showEitingView:YES];
    
}

#pragma mark -- event response

- (void)p__buttonClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"取消关注"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.tableview indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
        }];
        [self.listData removeObjectsAtIndexes:insets];
        [self.tableview deleteRowsAtIndexPaths:[self.tableview indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        /** 数据清空情况下取消编辑状态*/
        if (self.listData.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.tableview setEditing:NO animated:YES];
            [self showEitingView:NO];
            /** 带MJ刷新控件重置状态
             [self.tableView.footer resetNoMoreData];
             [self.tableView reloadData];
             */
        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        [self.tableview reloadData];
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}


#pragma mark -- addSubView
- (void)Adds{

    [self.view addSubview:self.editingView];
    [self.view addSubview:self.tableview];

    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.editingView.mas_top);
    }];
    
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view).offset(50);
    }];
}


- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:50);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCollectionProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCollectionProductTableViewCell forIndexPath:indexPath];

    cell.titileLb.text = @"就睡觉睡觉睡觉";
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (UIView *)editingView{
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = MAIN_COLOR;
        [button setTitle:@"取消关注" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(1);
        }];
        
    }
    return _editingView;
}
#pragma mark -- getters and setters
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.dataSource      = self;
        _tableview.delegate        = self;
        _tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableview.tableFooterView = [[UIView alloc] init];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
         [self.tableview registerNib:[UINib nibWithNibName:mineCollectionProductTableViewCell bundle:nil] forCellReuseIdentifier:mineCollectionProductTableViewCell];
    }
    return _tableview;
}
@end
