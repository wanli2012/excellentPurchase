//
//  LBRecommendRecoderViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRecommendRecoderViewController.h"
#import "LBRecommendRecoderCell.h"
#import "LBRecommendRecoderDtailViewController.h"
#import "LBRecommendRecoderModel.h"

@interface LBRecommendRecoderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *userArr;//数组
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;

@end

@implementation LBRecommendRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"推荐";
    self.page = 1;
    [self.tableview registerNib:[UINib nibWithNibName:@"LBRecommendRecoderCell" bundle:nil] forCellReuseIdentifier:@"LBRecommendRecoderCell"];
    
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
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
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
    
    [NetworkManager requestPOSTWithURLStr:UserGroomUser_groom_list paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            
            if (isDirect) {
                [self.userArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBRecommendRecoderModel *model = [LBRecommendRecoderModel mj_objectWithKeyValues:dic];
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



#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userArr.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBRecommendRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBRecommendRecoderCell"];
    cell.selectionStyle = 0;
    cell.model = self.userArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LBRecommendRecoderModel *model = self.userArr[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    LBRecommendRecoderDtailViewController *vc = [[LBRecommendRecoderDtailViewController alloc]init];
    vc.g_uid = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 懒加载

-(NSMutableArray*)userArr{
    
    if (!_userArr) {
        _userArr=[[NSMutableArray alloc]init];
    }
    
    return _userArr;
}
@end
