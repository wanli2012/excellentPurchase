//
//  LBShowWinningPictureController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowWinningPictureController.h"
#import "LBShowWinningPictureCell.h"
#import "LBNotShowWinningPictureCell.h"
#import "LBNotShowWinningPicturemodel.h"
#import "LBShowWinningPicturemodel.h"
#import "LBSendShowPictureViewController.h"

@interface LBShowWinningPictureController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray    *dataArr;
@property (strong, nonatomic) NSMutableArray    *dataoneArr;
@property (nonatomic, assign) NSInteger  page;

@end

static NSString *showWinningPictureCell = @"LBShowWinningPictureCell";
static NSString *notShowWinningPictureCell = @"LBNotShowWinningPictureCell";

@implementation LBShowWinningPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"晒单列表";
    
     [self.tableview registerNib:[UINib nibWithNibName:showWinningPictureCell bundle:nil] forCellReuseIdentifier:showWinningPictureCell];
     [self.tableview registerNib:[UINib nibWithNibName:notShowWinningPictureCell bundle:nil] forCellReuseIdentifier:notShowWinningPictureCell];
    
    [self setupNpdata];//设置无数据的时候展示
    [self requestDatasorce];
    [self requestDatasorceone:YES];
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview footerRefresh:^{
        [weakSelf requestDatasorceone:NO];
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
        [weakSelf requestDatasorce];
        [weakSelf requestDatasorceone:YES];
    }];
}

-(void)requestDatasorce{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_wait_slide paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [self.dataArr removeAllObjects];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
           
            for (NSDictionary *dic  in responseObject[@"data"]) {
                LBNotShowWinningPicturemodel  *model = [LBNotShowWinningPicturemodel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        
    }];
}

-(void)requestDatasorceone:(BOOL)isrefresh{
    
    if (isrefresh == YES) {
        self.page = 1;
    }else{
        self.page = 1 + self.page;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(self.page);
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_slide_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if (isrefresh == YES) {
            [self.dataoneArr removeAllObjects];
        }
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dic  in responseObject[@"data"][@"page_data"]) {
                LBShowWinningPicturemodel  *model = [LBShowWinningPicturemodel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
        [LBDefineRefrsh dismissRefresh:self.tableview];
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  
    return 2; //返回值是多少既有几个分区
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 0) {
        return 2;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 113;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }
   
    tableView.estimatedRowHeight = 166;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBNotShowWinningPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:notShowWinningPictureCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WeakSelf;
        cell.jumpShowpic = ^(LBNotShowWinningPicturemodel *model) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            LBSendShowPictureViewController *vc = [[LBSendShowPictureViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else{
        LBShowWinningPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:showWinningPictureCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}
#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 30)];
        headerview.backgroundColor = [UIColor whiteColor];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UIScreenWidth - 20, 30)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.text = @"好运旺就要放肆晒,  拿晒单红包奖上奖哦!";
        headerLabel.font = [UIFont systemFontOfSize:12];
        headerLabel.textColor = MAIN_COLOR;
        [headerview addSubview:headerLabel];
        return headerview;
    }
    
    return nil;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
         return 30.0f;
    }else{
         return 10.0f;
    }
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray*)dataoneArr{
    if (!_dataoneArr) {
        _dataoneArr = [NSMutableArray array];
    }
    return _dataoneArr;
}
@end
