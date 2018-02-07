//
//  LBVoucherCenterRecoderViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBVoucherCenterRecoderViewController.h"
#import "LBVoucherCenterRecoderTableViewCell.h"
#import "GLVoucherRecordModel.h"

@interface LBVoucherCenterRecoderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1

@end

static NSString *voucherCenterRecoderTableViewCell = @"LBVoucherCenterRecoderTableViewCell";

@implementation LBVoucherCenterRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值记录";
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:voucherCenterRecoderTableViewCell bundle:nil] forCellReuseIdentifier:voucherCenterRecoderTableViewCell];

    [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
//    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
//        [weakSelf postRequest:YES];
//    } footerRefresh:^{
////        [weakSelf postRequest:NO];
//    }];
    
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf postRequest:YES];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReceivingAddress) name:@"refreshReceivingAddress" object:nil];
    
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
    //    dic[@"page"] = @(self.page);
    
    [NetworkManager requestPOSTWithURLStr:kuser_recharge_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            if([responseObject[@"data"][@"page_data"] count] != 0){
                
                for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                    GLVoucherRecordModel *model = [GLVoucherRecordModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableview reloadData];
        
    }];
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
 
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBVoucherCenterRecoderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voucherCenterRecoderTableViewCell forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - 懒加载
-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
}

@end
