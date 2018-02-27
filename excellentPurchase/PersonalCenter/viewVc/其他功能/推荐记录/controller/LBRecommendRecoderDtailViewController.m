//
//  LBRecommendRecoderDtailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRecommendRecoderDtailViewController.h"
#import "LBRecommendRecoderDetailCell.h"
#import "LBRecommendRecoderListModel.h"

@interface LBRecommendRecoderDtailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *userArr;//数组
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;

@end

@implementation LBRecommendRecoderDtailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"推荐收益";
    self.page = 1;
    [self.tableview registerNib:[UINib nibWithNibName:@"LBRecommendRecoderDetailCell" bundle:nil] forCellReuseIdentifier:@"LBRecommendRecoderDetailCell"];
    
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
    
    [self loadData:self.page refreshDirect:YES];
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.userArr.count && weakSelf.userArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:self.tableview];
        }else{
            weakSelf.page = weakSelf.page + 1;
            [weakSelf loadData:weakSelf.page refreshDirect:NO];
        }
    }];
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"page"] = @(page);
    dic[@"g_uid"] = self.g_uid;
    
    [NetworkManager requestPOSTWithURLStr:UserGroomGroom_gain paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            
            if (isDirect) {
                [self.userArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBRecommendRecoderListModel *model = [LBRecommendRecoderListModel mj_objectWithKeyValues:dic];
                [self.userArr addObject:model];
            }
            
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.userArr.count; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.estimatedRowHeight = 40;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBRecommendRecoderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBRecommendRecoderDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.userArr[indexPath.row];
  
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return label;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

-(NSMutableArray *)userArr{
    if (!_userArr) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}

@end
