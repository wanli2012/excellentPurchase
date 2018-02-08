//
//  LBUerUnderlineOrdersViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBUerUnderlineOrdersViewController.h"
#import "LBUerUnderLineOrdersCell.h"
#import "LBUerUnderLineOrderModel.h"
#import "LBMineEvaluateViewController.h"

@interface LBUerUnderlineOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;


@end

static NSString *uerUnderLineOrdersCell = @"LBUerUnderLineOrdersCell";

@implementation LBUerUnderlineOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.page = 1;
    self.navigationItem.title = @"吃喝玩乐订单";
    [self.tableview registerNib:[UINib nibWithNibName:uerUnderLineOrdersCell bundle:nil] forCellReuseIdentifier:uerUnderLineOrdersCell];
    
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
    
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

-(void)setuprefrsh{
    WeakSelf;
    [self loadData:self.page refreshDirect:YES];
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:weakSelf.tableview];
        }else{
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
        }
    }];
    
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(page);
     dic[@"uid"] = [UserModel defaultUser].uid;
     dic[@"token"] = [UserModel defaultUser].token;
    
    [NetworkManager requestPOSTWithURLStr:OrderUser_face_order_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            if (isDirect) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBUerUnderLineOrderModel *model = [LBUerUnderLineOrderModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
           
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}

-(void)replyComment:(NSIndexPath*)indexpath{
    LBUerUnderLineOrderModel *model = self.dataArr[indexpath.section];
    self.hidesBottomBarWhenPushed = YES;
    LBMineEvaluateViewController *vc = [[LBMineEvaluateViewController alloc]init];
    vc.line_id = model.face_id;
    vc.line_store_uid = model.face_shop_uid;
    vc.replyType = 2;
    vc.is_face = model.is_face;
    vc.goods_name = model.store_name;
    vc.goods_pic = model.store_thumb;
    vc.replyFinish = ^{
         model.is_comment = @"1";
        [_tableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.dataArr.count; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        LBUerUnderLineOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:uerUnderLineOrdersCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.section];
    cell.inexpath = indexPath;
    cell.replyFinish = ^(NSIndexPath *indexpath) {
        [self replyComment:indexPath];
    };
    
        return cell;
    
}


#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}

@end
