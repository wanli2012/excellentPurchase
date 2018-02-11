//
//  LBReplyProductListsViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/6.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBReplyProductListsViewController.h"
#import "LBCommentHeaderTableViewCell.h"
#import "LBCommentListsTableViewCell.h"
#import "LBTmallProductDetailModel.h"
#import "LBTmallDetailgoodsCommentFrameModel.h"

@interface LBReplyProductListsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic)NSMutableArray *commentdataArr;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, assign) NSInteger  allCount;

@end

static NSString *commentHeaderTableViewCell = @"LBCommentHeaderTableViewCell";
static NSString *commentListsTableViewCell = @"LBCommentListsTableViewCell";

@implementation LBReplyProductListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"商品评价列表";
    
    [self.tableview registerNib:[UINib nibWithNibName:commentHeaderTableViewCell bundle:nil] forCellReuseIdentifier:commentHeaderTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:commentListsTableViewCell bundle:nil] forCellReuseIdentifier:commentListsTableViewCell];
    
    [self setupNpdata];//设置无数据的时候展示
    [self refreshdata];//刷新数据
    self.page = 1;
     [self loadData:self.page refreshDirect:YES];
    
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"goods_id"] = self.good_id;
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
        LBTmallDetailgoodsCommentFrameModel * model = self.commentdataArr[indexPath.row - 1];
        cell.model = model.CommentModel;
        if ([NSString StringIsNullOrEmpty:model.CommentModel.reply] == NO) {
            cell.replayBt.hidden = YES;
        }else{
            cell.replayBt.hidden = NO;
        }
        cell.indexpath = indexPath;
        WeakSelf;
        cell.replyComment = ^(NSIndexPath *indexpath, NSString *str) {
            [weakSelf replyCommentinde:indexpath str:str];
        };
        return cell;
    }
}

-(void)replyCommentinde:(NSIndexPath*)indexpath str:(NSString*)str{
    
    LBTmallDetailgoodsCommentFrameModel * model = self.commentdataArr[indexpath.row - 1];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"order_goods_id"] = model.CommentModel.order_goods_id;
    dic[@"reply"] = str;
    dic[@"comment_id"] = model.CommentModel.comment_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [EasyShowLodingView showLodingText:@"正在加载"];
    [NetworkManager requestPOSTWithURLStr:CommentStore_order_reply paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            model.CommentModel.reply = str;
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

-(NSMutableArray*)commentdataArr{
    if (!_commentdataArr) {
        _commentdataArr = [[NSMutableArray alloc]init];
    }
    return _commentdataArr;
}

@end
