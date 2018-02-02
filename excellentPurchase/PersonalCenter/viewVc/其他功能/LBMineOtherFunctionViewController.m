//
//  LBMineOtherFunctionViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOtherFunctionViewController.h"
#import "LBSetUpTableViewCell.h"

@interface LBMineOtherFunctionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组
@end

@implementation LBMineOtherFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"其他功能";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBSetUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBSetUpTableViewCell"];
    
}

#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBSetUpTableViewCell"];
    cell.selectionStyle = 0;
    cell.headimage.hidden = YES;
    cell.cacheLB.hidden = YES;
    
    if (indexPath.row == 0) {
        cell.titleLb.text = @"推荐";
    }else if(indexPath.row == 1){
        cell.titleLb.text = @"收藏夹";
    }
    
    //    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vcstr = self.userVcArr[indexPath.row];
    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 懒加载

-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {
        _userVcArr=[NSMutableArray arrayWithObjects:
                    @"LBRecommendRecoderViewController",
                    @"LBMineCollectionViewController",nil];
        
    }
    
    return _userVcArr;
}

@end
