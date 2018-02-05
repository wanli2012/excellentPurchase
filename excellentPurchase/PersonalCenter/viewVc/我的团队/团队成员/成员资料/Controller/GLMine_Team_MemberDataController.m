//
//  GLMine_Team_MemberDataController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_MemberDataController.h"
#import "GLMine_Team_MemberDetailModel.h"

#import "GLMine_Team_AchieveManageCell.h"
#import "GLMine_Team_MemberModel.h"

@interface GLMine_Team_MemberDataController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//状态(审核中,审核成功,审核失败)
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//账号ID
@property (weak, nonatomic) IBOutlet UILabel *groupTypeLabel;//身份
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址

@property (weak, nonatomic) IBOutlet UIView *licenseView;//营业执照
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//执照

@property (nonatomic, strong)GLMine_Team_MemberDetailModel *model;

@property (strong, nonatomic)NSMutableArray *models;
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation GLMine_Team_MemberDataController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNav];
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest];
        [weakSelf postListRequest:YES];
    }];
    
    [self postRequest];
    [self postListRequest:YES];
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
        [weakSelf postListRequest:YES];
    }];
}

//请求数据
-(void)postListRequest:(BOOL)isRefresh{
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"select_uid"] = self.leaguer_uid;
    dic[@"tg_status"] = @"1";//1 通过 2审核中 3失败
    
    [NetworkManager requestPOSTWithURLStr:kleaguer_index paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            if ([responseObject[@"data"] count] != 0) {
                
                for (NSDictionary *dict in responseObject[@"data"]) {
                    GLMine_Team_MemberModel *model = [GLMine_Team_MemberModel mj_objectWithKeyValues:dict];
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

//请求数据
- (void)postRequest {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"leaguer_uid"] = self.leaguer_uid;
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kleaguer_info paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
  
            GLMine_Team_MemberDetailModel *model = [GLMine_Team_MemberDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.model = model;
            
            [self assignment];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}


//赋值
- (void)assignment{
    
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    self.trueNameLabel.text = self.model.truename;
    
    if([self.model.tg_status integerValue] == 1){//推广员审核状态 1 通过 2审核中 3失败
        self.signLabel.text = @"已通过";
    }else if([self.model.tg_status integerValue] == 2){
        self.signLabel.text = @"审核中";
    }else if([self.model.tg_status integerValue] == 2){
        self.signLabel.text = @"失败";
        
    }
    
    self.IDNumberLabel.text = self.model.user_name;
    self.groupTypeLabel.text = self.model.group_name;
    self.phoneLabel.text = self.model.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",self.model.p_name,self.model.c_name,self.model.a_name];
    
    if ([self.leaguer_uid integerValue] == 8) {
        self.licenseView.hidden = NO;
    }else{
        self.licenseView.hidden = YES;
    }
}

/**
 导航栏设置
 */
- (void)setNav{
    self.navigationItem.title = @"成员资料";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"联系他" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(contact) forControlEvents:UIControlEventTouchUpInside];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 联系他
 */
- (void)contact{
    
    if (@available(iOS 10.0, *)) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",self.phoneLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"ddd2222"]];
    }
}


#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Team_AchieveManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Team_AchieveManageCell"];
    cell.selectionStyle = 0;
    cell.memberModel = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.model.group_id integerValue] == GROUP_TG) {
        [EasyShowTextView showInfoText:@"此身份暂无下级"];
        return;
    }
    
    GLMine_Team_MemberModel *model = self.models[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    
    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    dataVC.leaguer_uid = model.uid;
    [self.navigationController pushViewController:dataVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
