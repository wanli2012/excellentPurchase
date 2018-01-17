//
//  LBCommentListsView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/16.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCommentListsView.h"
#import "LBCommentHeaderTableViewCell.h"
#import "LBCommentListsTableViewCell.h"

@interface LBCommentListsView()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic)UIView *MainView;
@property (strong , nonatomic)UITableView *tableview;

@end

static NSString *commentHeaderTableViewCell = @"LBCommentHeaderTableViewCell";
static NSString *commentListsTableViewCell = @"LBCommentListsTableViewCell";

@implementation LBCommentListsView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
         [self lb_setView];//加载视图
        [self getData];//获取数据
        [self showView];//展示视图
    }
    return self;
}

-(void)getData{
    
}

-(void)lb_setView{
    [self.tableview registerNib:[UINib nibWithNibName:commentHeaderTableViewCell bundle:nil] forCellReuseIdentifier:commentHeaderTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:commentListsTableViewCell bundle:nil] forCellReuseIdentifier:commentListsTableViewCell];
    
    [self addSubview:self.MainView];
    [self.MainView addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.MainView).offset(0);
        make.leading.equalTo(self.MainView).offset(0);
        make.top.equalTo(self.MainView).offset(0);
        make.bottom.equalTo(self.MainView).offset(0);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    tableView.estimatedRowHeight = 110;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LBCommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentHeaderTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LBCommentListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentListsTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)showView {

    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.MainView.x = 0;
    }];
}
- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.MainView.x = UIScreenWidth;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UIView*)MainView{
    if (!_MainView) {
        _MainView = [[UIView alloc]initWithFrame:CGRectMake(UIScreenWidth, SafeAreaTopHeight , UIScreenWidth, UIScreenHeight - (SafeAreaTopHeight + 60))];
        _MainView.backgroundColor = [UIColor whiteColor];
    }
    return _MainView;
}

-(UITableView*)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}

@end
