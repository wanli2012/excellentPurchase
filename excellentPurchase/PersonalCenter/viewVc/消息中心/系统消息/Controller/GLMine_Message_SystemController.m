//
//  GLMine_Message_SystemController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_SystemController.h"
#import "GLMine_Message_TrendsCell.h"
#import "GLMine_Message_SystemModel.h"
#import "LLWebViewController.h"

@interface GLMine_Message_SystemController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Message_SystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Message_TrendsCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Message_TrendsCell"];

    [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
//    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
//        [weakSelf postRequest:YES];
//    } footerRefresh:^{
////        [weakSelf postRequest:NO];
//    }];
    
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    }];
    
//    self.page = 1;
    [self postRequest:YES];
    
}

//刷新
-(void)refreshReceivingAddress{
    [self postRequest:YES];
}

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.tableView.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
//    if(isRefresh){
//        self.page = 1;
//    }else{
//        self.page ++;
//    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"page"] = @(self.page);
    
    [EasyShowLodingView showLoding];
    
    [NetworkManager requestPOSTWithURLStr:ksystem_bulletin paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            
            if ([responseObject[@"data"][@"page_data"] count] != 0) {
                
                for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                    GLMine_Message_SystemModel *model = [GLMine_Message_SystemModel mj_objectWithKeyValues:dict];
                    
                    [self.models addObject:model];
                }
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableView reloadData];
        
    }];
}


#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Message_TrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Message_TrendsCell"];
    cell.selectionStyle = 0;
    cell.systemModel = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    return tableView.rowHeight;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
      GLMine_Message_SystemModel *model =  self.models[indexPath.row];
    LLWebViewController *vc = [[LLWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@%@",URL_Base,DataNew_data,@"/news_id/",model.news_id]];
    vc.titilestr = @"公告详情";
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}
@end
