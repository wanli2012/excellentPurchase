//
//  GLMine_TeamController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_TeamController.h"
#import "GLMine_Team_TeamAchievementController.h"//团队业绩
#import "GLMine_Team_AchievementManageController.h"//绩效管理
#import "GLMine_Team_OpenMakerController.h"//开通创客
#import "GLMine_Team_MembersController.h"//团队成员
#import "GLMine_Team_OpenSellerController.h"//开通商家

#import "GLMine_TeamModel.h"

#import "GLMine_ManagementCell.h"

@interface GLMine_TeamController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
//@property (weak, nonatomic) IBOutlet UILabel *IDLabel;//ID
//@property (weak, nonatomic) IBOutlet UILabel *monthConsumeLabel;//本月消费
//@property (weak, nonatomic) IBOutlet UILabel *recommendUserConsumeLabel;//推荐用户消费
//@property (weak, nonatomic) IBOutlet UILabel *subordinatesConsumeLabel;//下属创客业绩
//@property (weak, nonatomic) IBOutlet UILabel *getRewardLabel;//获得奖励

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthConsumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendUserConsumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subordinatesConsumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getRewardLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy)NSArray *imageArr;
@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组

@property (nonatomic, strong)GLMine_TeamModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVWidth;


@end

@implementation GLMine_TeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的团队";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentViewWidth.constant = UIScreenWidth;
    self.contentVWidth.constant = UIScreenWidth * 2 - 120.0/750.0 * UIScreenWidth;
    self.firstView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.firstView.layer.shadowOffset = CGSizeMake(0,0);//
    self.firstView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.firstView.layer.shadowRadius = 6;//阴影半径，默认3
    
    self.secondView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.secondView.layer.shadowOffset = CGSizeMake(0,0);
    self.secondView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.secondView.layer.shadowRadius = 6;//阴影半径，默认3
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    [self postRequest];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_ManagementCell" bundle:nil] forCellWithReuseIdentifier:@"GLMine_ManagementCell"];
}

//请求数据
- (void)postRequest {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"group_id"] = [UserModel defaultUser].group_id;
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kmy_team paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            GLMine_TeamModel *model = [GLMine_TeamModel mj_objectWithKeyValues:responseObject[@"data"]];
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

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.nameLabel.text = self.model.truename;
    self.IDLabel.text = self.model.user_name;
    
    self.monthConsumeLabel.text = self.model.consume;
    self.recommendUserConsumeLabel.text = self.model.tj_con;
    self.subordinatesConsumeLabel.text = self.model.maker_con;
    
    if(self.model.reg_reward.length == 0){
        self.getRewardLabel.text = @"0.00";
    }else{
        self.getRewardLabel.text = self.model.reg_reward;
    }
   
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



#pragma mark - UICollectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_ManagementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMine_ManagementCell" forIndexPath:indexPath];
    
    if(indexPath.row > 3){
        cell.lineView.hidden = YES;
    }
    
    cell.picImageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.nameLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *vcstr = self.userVcArr[indexPath.row];
    
    //    if([vcstr isEqualToString:@"GLMine_TeamController"] || [vcstr isEqualToString:@"GLMine_ManagementController"]){//我的团队 商家管理
    //        if([[UserModel defaultUser].rzstatus integerValue] == 0){////用户 认证状态 0没有认证 1:申请实名认证 2审核通过3失败
    //            [EasyShowTextView showInfoText:@"请先实名认证"];
    //            return;
    //        }else if([[UserModel defaultUser].rzstatus integerValue] == 1){
    //            [EasyShowTextView showInfoText:@"实名认证审核中"];
    //            return;
    //        }else if([[UserModel defaultUser].rzstatus integerValue] == 3){
    //            [EasyShowTextView showInfoText:@"实名认证失败"];
    //            return;
    //        }
    //    }
    
    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.width - 30)/4, 105);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 20, 15);
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - 懒加载
- (NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"团队业绩_我的团队",@"绩效管理_我的团队",@"开通下级_我的团队",@"团队成员_我的团队",@"开通商户_我的团队"];
    }
    return _imageArr;
}

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"团队业绩",@"绩效管理",@"开通下级",@"团队成员",@"开通商户"];
    }
    return _titleArr;
}
- (NSMutableArray *)userVcArr{
    if (!_userVcArr) {
        
        _userVcArr=[NSMutableArray arrayWithObjects:
                    @"GLMine_Team_TeamAchievementController",
                    @"GLMine_Team_AchievementManageController",
                    @"GLMine_Team_OpenMakerController",
                    @"GLMine_Team_MembersController",
                    @"GLMine_Team_OpenSellerController",nil];
    }
    return _userVcArr;
}

@end
