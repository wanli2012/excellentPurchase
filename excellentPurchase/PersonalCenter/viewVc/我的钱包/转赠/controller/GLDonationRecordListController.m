//
//  GLDonationRecordListController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/6.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationRecordListController.h"
#import "GLDonationRecordModel.h"
#import "LBDonationTableViewCell.h"

@interface GLDonationRecordListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger page;//页数
@property (nonatomic, strong)NSMutableArray *models;



@end

@implementation GLDonationRecordListController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"LBDonationTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBDonationTableViewCell"];
    
    [self setupNpdata];//设置无数据的时候展示
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    }];
    
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
    
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"type"] = @(self.type);//转赠还是获赠 1.获赠 2.转赠
    
    [NetworkManager requestPOSTWithURLStr:kreceive_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            if ([responseObject[@"data"] count] != 0) {
                
                for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                    GLDonationRecordModel *model = [GLDonationRecordModel mj_objectWithKeyValues:dict];
                    model.recordType = self.type;
                    
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
    
    LBDonationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDonationTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}


@end
