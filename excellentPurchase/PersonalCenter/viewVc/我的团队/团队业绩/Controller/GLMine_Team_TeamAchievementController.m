//
//  GLMine_Team_TeamAchievementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_TeamAchievementController.h"
//#import "GLMine_TeamAchievementModel.h"
#import "GLMine_Team_UnderLingModel.h"

#import "GLMine_TeamAchievementCell.h"
#import "GLIdentifySelectController.h"
#import "GLMine_Team_UnderlingDetailController.h"//下属绩效

@interface GLMine_Team_TeamAchievementController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *teamAchievementLabel;//团队总业绩

@property (nonatomic, strong)NSMutableArray *models;

@property (nonatomic, copy)NSString *group_id;

@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, assign)NSInteger selectIndex;//选中身份下标


@end

@implementation GLMine_Team_TeamAchievementController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"团队业绩";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_TeamAchievementCell" bundle:nil] forCellReuseIdentifier:@"GLMine_TeamAchievementCell"];
    [self postRequest];
}

#pragma mark 请求数据
- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"group_id"] = [UserModel defaultUser].group_id;
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kteam_achievement paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.teamAchievementLabel.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"team_performancer"]];
            
            if([responseObject[@"data"][@"data_up"] count] != 0){
                
                for (NSDictionary *dict in responseObject[@"data"][@"data_up"]) {
                    GLMine_TeamUnderLing_data_upModel *model = [GLMine_TeamUnderLing_data_upModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
            }
            
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
    self.navigationItem.title = @"团队业绩";
    
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
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_TeamAchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_TeamAchievementCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[UserModel defaultUser].group_id integerValue] == GROUP_SHOP ||
       [[UserModel defaultUser].group_id integerValue] == GROUP_USER ||
       [[UserModel defaultUser].group_id integerValue] == GROUP_TG){
        
        [EasyShowTextView showInfoText:@"该身份没有下级了"];
        return;
    }
    
    GLMine_TeamAchievementModel *model = self.models[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UnderlingDetailController *vc = [[GLMine_Team_UnderlingDetailController alloc] init];
    vc.cid = model.uid;
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
