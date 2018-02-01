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
#import "LBTmallProductDetailModel.h"
#import "LBTmallDetailgoodsCommentFrameModel.h"

@interface LBCommentListsView()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic)UIView *MainView;
@property (strong , nonatomic)UITableView *tableview;
@property (strong , nonatomic)NSMutableArray *commentdataArr;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, assign) NSInteger  allCount;

@end

static NSString *commentHeaderTableViewCell = @"LBCommentHeaderTableViewCell";
static NSString *commentListsTableViewCell = @"LBCommentListsTableViewCell";

@implementation LBCommentListsView

-(void)setGoods_id:(NSString *)goods_id{
    _goods_id = goods_id;
    [self loadData:self.page refreshDirect:YES];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
         [self lb_setView];//加载视图
        [self showView];//展示视图
        [self setupNpdata];//设置无数据的时候展示
        [self refreshdata];//刷新数据

    }
    return self;
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"goods_id"] = self.goods_id;
    dic[@"page"] = @(page);
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [EasyShowLodingView showLodingText:@"正在加载"];
    [NetworkManager requestPOSTWithURLStr:SeaShoppingGoods_comment_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            if (isDirect) {
                [self.commentdataArr removeAllObjects];
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBTmallProductDetailgoodsCommentModel * model = [LBTmallProductDetailgoodsCommentModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            
            [self.commentdataArr addObjectsFromArray: [LBTmallDetailgoodsCommentFrameModel getIndustryModels:arr]];
            
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [LBDefineRefrsh dismissRefresh:self.tableview];
        
    }];
    
}
-(void)setupNpdata{
    WeakSelf;
    self.tableview.tableFooterView = [UIView new];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableview.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableview.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableview.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableview.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    }];
}
-(void)refreshdata{
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.commentdataArr.count && weakSelf.commentdataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:self.tableview];
        }else{
            weakSelf.page = weakSelf.page + 1;
            [weakSelf loadData:weakSelf.page refreshDirect:NO];
        }
    }];
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
    
    return 1 + self.commentdataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 40;
    }
   
    return  ((LBTmallDetailgoodsCommentFrameModel*)self.commentdataArr[indexPath.row - 1]).cellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LBCommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentHeaderTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.repalyNum.text = [NSString stringWithFormat:@"(共%ld条)",self.allCount];
        return cell;
    }else{
        LBCommentListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentListsTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = ((LBTmallDetailgoodsCommentFrameModel*)self.commentdataArr[indexPath.row - 1]).CommentModel;
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

-(NSMutableArray*)commentdataArr{
    if (!_commentdataArr) {
        _commentdataArr  = [[NSMutableArray alloc]init];
    }
    return _commentdataArr;
}
@end
