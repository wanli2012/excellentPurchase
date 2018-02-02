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

@interface LBRecommendRecoderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组
@end

@implementation LBRecommendRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"推荐";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBRecommendRecoderCell" bundle:nil] forCellReuseIdentifier:@"LBRecommendRecoderCell"];
    
}

#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBRecommendRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBRecommendRecoderCell"];
    cell.selectionStyle = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    LBRecommendRecoderDtailViewController *vc = [[LBRecommendRecoderDtailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 懒加载

-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {
        _userVcArr=[[NSMutableArray alloc]init];
    }
    
    return _userVcArr;
}
@end
