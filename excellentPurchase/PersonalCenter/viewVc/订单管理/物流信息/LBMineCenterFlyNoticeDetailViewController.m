//
//  LBMineCenterFlyNoticeDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeDetailViewController.h"
#import "LBMineCenterFlyNoticeDetailTableViewCell.h"
#import "LBMineCenterFlyNoticeDetailOneTableViewCell.h"
#import "LBMineCenterFlyNoticeModel.h"

@interface LBMineCenterFlyNoticeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)LBMineCenterFlyNoticeModel *model;

@end

@implementation LBMineCenterFlyNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流详情";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailTableViewCell"];
    
     [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell"];
    
    [self setupNpdata];//设置无数据的时候展示
    [self initdatasorce];

}

-(void)initdatasorce{

    if ([NSString StringIsNullOrEmpty:self.codestr]) {
        self.codestr = @"";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"number"] = self.codestr;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [NetworkManager requestPOSTWithURLStr:AccessGet_logisits_info paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model = [LBMineCenterFlyNoticeModel mj_objectWithKeyValues:responseObject[@"data"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
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

        [weakSelf initdatasorce];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.model) {
        return 1 + self.model.wl_info.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 105;
    }else{
        self.tableview.estimatedRowHeight = 70;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        LBMineCenterFlyNoticeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    }else{
        LBMineCenterFlyNoticeDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 1 ) {
            cell.lineview.hidden = YES;
            cell.bottomV.hidden = NO;
        }else if(indexPath.row == [self.model.wl_info count] ){
            cell.lineview.hidden = NO;
            cell.bottomV.hidden = YES;
        }else{
           cell.lineview.hidden = NO;
          cell.bottomV.hidden = NO;
        }
        
        cell.model = self.model.wl_info[indexPath.row - 1];
       
        return cell;
    }
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
  
    
}


@end
