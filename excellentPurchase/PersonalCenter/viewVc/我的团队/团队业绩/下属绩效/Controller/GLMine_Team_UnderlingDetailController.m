//
//  GLMine_Team_UnderlingDetailController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_UnderlingDetailController.h"
#import "GLMine_Team_UnderLingModel.h"
#import "GLMine_TeamAchievementCell.h"
#import "GLIdentifySelectController.h"

@interface GLMine_Team_UnderlingDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *truenameLabel;//真实姓名
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//ID号
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;//自身本月消费
@property (weak, nonatomic) IBOutlet UILabel *tj_conLabel;//推荐用户消费
@property (weak, nonatomic) IBOutlet UILabel *maker_conLabel;//下属业绩
@property (weak, nonatomic) IBOutlet UILabel *reg_rewardLabel;//获得奖励

@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, assign)NSInteger selectIndex;//选中身份下标

@property (nonatomic, strong)GLMine_Team_UnderLingModel *model;

@end

@implementation GLMine_Team_UnderlingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"下级业绩";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_TeamAchievementCell" bundle:nil] forCellReuseIdentifier:@"GLMine_TeamAchievementCell"];
    
    [self postRequest];
}

- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"group_id"] = [UserModel defaultUser].group_id;
    dic[@"cid"] = self.cid;
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kmen_achievement paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            GLMine_Team_UnderLingModel *model = [GLMine_Team_UnderLingModel mj_objectWithKeyValues:responseObject[@"data"]];
    
            self.model = model;
            
            [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.team_performancer.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
            self.consumeLabel.text = self.model.team_performancer.consume;
            self.tj_conLabel.text = self.model.team_performancer.tj_con;
            self.maker_conLabel.text = self.model.team_performancer.maker_con;
            self.reg_rewardLabel.text = self.model.team_performancer.reg_reward;
            self.truenameLabel.text = self.model.team_performancer.truename;
            self.IDNumberLabel.text = self.model.team_performancer.user_name;
            
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

/**
 导航栏设置
 */
- (void)setNav{
    self.navigationItem.title = @"下属业绩";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

/**
 筛选
 */
- (void)filter{
    
    self.hidesBottomBarWhenPushed = YES;
    GLIdentifySelectController *idSelectVC = [[GLIdentifySelectController alloc] init];
    idSelectVC.selectIndex = [self.group_id integerValue];
    __weak typeof(self) weakSelf = self;
    idSelectVC.block = ^(NSString *name,NSString *group_id,NSInteger selectIndex) {
        
        [weakSelf.rightBtn setTitle:name forState:UIControlStateNormal];
        weakSelf.group_id = group_id;
        weakSelf.selectIndex = selectIndex;
        
    };
    
    [self.navigationController pushViewController:idSelectVC animated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data_up.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_TeamAchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_TeamAchievementCell" forIndexPath:indexPath];
    
    cell.model = self.model.data_up[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_TeamUnderLing_data_upModel *model = self.model.data_up[indexPath.row];
    
    if([model.group_id integerValue] == GROUP_TG){
        [EasyShowTextView showInfoText:@"没有更多了"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UnderlingDetailController *vc = [[GLMine_Team_UnderlingDetailController alloc] init];
    vc.cid = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
