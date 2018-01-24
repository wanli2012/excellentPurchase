//
//  LBAccountManagementViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAccountManagementViewController.h"
#import "LBAccountManagementTableViewCell.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

#import "LBModifyingUsernameViewController.h"//用户名修改
#import "LBMineCenterAddAdreassViewController.h"//修改收货地址
#import "LBImprovePersonalInformationViewController.h"//完善资料
#import "GLRecommendController.h"//我的二维码

@interface LBAccountManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *headImge;//头像
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *valueArr;

@property (nonatomic, copy)NSArray *titleArr2;
@property (nonatomic, strong)NSMutableArray *valueArr2;

//@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组

@end

static NSString *accountManagementTableViewCell = @"LBAccountManagementTableViewCell";

@implementation LBAccountManagementViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    
    if (self.type == 1) {
        self.headNameLabel.text = @"头像";
    }else{
        self.headNameLabel.text = @"其他资料";
    }
    
    self.titleArr = @[@"真实姓名",@"身份",@"账号",@"推荐账号",@"推荐人用户名"];
    self.valueArr = @[@"磊哥",@"会员",@"342423",@"22342344",@"你大爷"];
    
    self.titleArr2 = @[@"用户名",@"账号状态",@"收货地址",@"我的二维码",@"所在地区"];
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:accountManagementTableViewCell bundle:nil] forCellReuseIdentifier:accountManagementTableViewCell];

    //底部视图高度
    self.tableview.tableFooterView.height = 60 ;
}

/**
 跳转到可编辑资料
 */
- (IBAction)editInfo:(id)sender {
    
    if (self.type == 1) {
        
        NSLog(@"修改头像");
        
    }else if(self.type == 0){
        self.hidesBottomBarWhenPushed = YES;
        LBAccountManagementViewController *vc = [[LBAccountManagementViewController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1; //返回值是多少既有几个分区
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if(self.type == 1){
        return self.titleArr2.count;
    }else{
        
        return self.titleArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LBAccountManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:accountManagementTableViewCell forIndexPath:indexPath];
    
    if (self.type == 1) {
        cell.titleLabel.text = self.titleArr2[indexPath.row];
        cell.valueLabel.text = self.valueArr2[indexPath.row];
        if(indexPath.row == 3){//我的二维码
            cell.type = 2;
        }else{
            cell.type = self.type;
        }
    }else{
        cell.type = self.type;
        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.valueLabel.text = self.valueArr[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 1) {
        
        __block typeof(self)weakSelf = self;
        switch (indexPath.row) {
            case 0://用户名修改
            {
                self.hidesBottomBarWhenPushed = YES;
                LBModifyingUsernameViewController *modifyUserNameVC = [[LBModifyingUsernameViewController alloc] init];
                
                modifyUserNameVC.block = ^(NSString *name) {
                    
                    [weakSelf.valueArr2 replaceObjectAtIndex:indexPath.row withObject:name];
                    
                    [weakSelf.tableview reloadData];
                    
                };
                
                [self.navigationController pushViewController:modifyUserNameVC animated:YES];
            }
                break;
            case 1://未审核  跳转到 完善信息
            {
                self.hidesBottomBarWhenPushed = YES;
                LBImprovePersonalInformationViewController *vc = [[LBImprovePersonalInformationViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2://收货地址
            {
//                self.hidesBottomBarWhenPushed = YES;
//                LBModifyingUsernameViewController *modifyUserNameVC = [[LBModifyingUsernameViewController alloc] init];
//
//                modifyUserNameVC.block = ^(NSString *name) {
//
//                    [weakSelf.valueArr2 replaceObjectAtIndex:indexPath.row withObject:name];
//
//                    [weakSelf.tableview reloadData];
//
//                };
//
//                [self.navigationController pushViewController:modifyUserNameVC animated:YES];
            }
                break;
            case 3://我的二维码
            {
                self.hidesBottomBarWhenPushed = YES;
                GLRecommendController *vc = [[GLRecommendController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4://所在地区
            {
                [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
                    
                    NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
                    
                    [weakSelf.valueArr2 replaceObjectAtIndex:indexPath.row withObject:str];
                    
                    [weakSelf.tableview reloadData];
                }];
            }
                
            default:
                break;
        }
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)valueArr2{
    if (!_valueArr2) {
        _valueArr2 = [NSMutableArray array];
        
        NSArray *arr = @[@"24K纯帅",@"未审核",@"金牛区万达正中间",@"22342344",@"四川省成都市"];
        
        for (int i = 0; i < 5; i ++) {
            [_valueArr2 addObject:arr[i]];
        }
        
    }
    return _valueArr2;
}

@end
