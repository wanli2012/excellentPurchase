//
//  LBAccountManagementViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAccountManagementViewController.h"
#import "LBAccountManagementTableViewCell.h"
#import "GLAccountManagementModel.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

//#import "LBMineCenterAddAdreassViewController.h"//修改收货地址
#import "LBModifyingUsernameViewController.h"//用户名修改
#import "LBImprovePersonalInformationViewController.h"//完善资料
#import "GLRecommendController.h"//我的二维码
#import "LBMineCentermodifyAdressViewController.h"//收货地址列表

@interface LBAccountManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *headImge;//头像
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *titleArr2;
@property (nonatomic, strong)GLAccountManagementModel *model;
@property (nonatomic, strong)NSDictionary *dataDic;

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
    
    if (self.type == 1) {//编辑资料
        self.headNameLabel.text = @"头像";
    }else{//不可编辑
        self.headNameLabel.text = @"其他资料";
    }
    
    self.titleArr = @[@"真实姓名",@"身份",@"账号",@"推荐账号",@"推荐人用户名"];
    
    self.titleArr2 = @[@"用户名",@"账号状态",@"收货地址",@"我的二维码",@"所在地区"];
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:accountManagementTableViewCell bundle:nil] forCellReuseIdentifier:accountManagementTableViewCell];

    //底部视图高度
    self.tableview.tableFooterView.height = 60;
    
    //请求数据
    [self postData];
}

#pragma mark - 请求数据

- (void)postData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    
    NSString *url;
    if (self.type == 1) {
        url = kget_user_info;
    }else {
        url = kuser_relevant;
    }

    [NetworkManager requestPOSTWithURLStr:url paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.dataDic = responseObject[@"data"];
            
            self.model = [GLAccountManagementModel mj_objectWithKeyValues:responseObject[@"data"]];

            [self.headImge sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];

        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 跳转到可编辑资料
/** 跳转到可编辑资料*/
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
        
        cell.type = self.type;
        if (indexPath.row == 0) {
            cell.valueLabel.text = self.dataDic[@"nickname"];
        }else  if (indexPath.row == 1) {
            switch ([self.model.rzstatus integerValue]) {////认证状态 0没有认证 1:申请实名认证 2审核通过3失败',
                case 0:
                {
                    cell.valueLabel.text = @"没有认证";
                }
                    break;
                case 1:
                {
                    cell.valueLabel.text = @"实名认证中";
                }
                    break;
                case 2:
                {
                    cell.valueLabel.text = @"审核通过";
                }
                    break;
                case 3:
                {
                    cell.valueLabel.text = @"认证失败";
                }
                    break;
                    
                default:
                    break;
            }
        }else if(indexPath.row == 2){
            
            cell.valueLabel.text = self.dataDic[@"address"];
            
        }else if(indexPath.row == 3){//我的二维码
            cell.type = 2;
        }else if(indexPath.row == 4){
            
            cell.valueLabel.text = self.dataDic[@"detail_address"];
        }
        
    }else{
        cell.type = self.type;
        
        cell.titleLabel.text = self.titleArr[indexPath.row];
        if(indexPath.row == 0){
            cell.valueLabel.text = self.dataDic[@"truename"];
        }else if(indexPath.row == 1){
            cell.valueLabel.text = self.dataDic[@"group_name"];
        }else if(indexPath.row == 2){
            cell.valueLabel.text = self.dataDic[@"user_name"];
        }else if(indexPath.row == 3){
            cell.valueLabel.text = self.dataDic[@"tj_username"];
        }else if(indexPath.row == 4){
            cell.valueLabel.text = self.dataDic[@"tj_nickname"];
        }
        
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
                    
                    [weakSelf postData];
                    
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
                self.hidesBottomBarWhenPushed = YES;
                LBMineCentermodifyAdressViewController *addListVC = [[LBMineCentermodifyAdressViewController alloc] init];

                [self.navigationController pushViewController:addListVC animated:YES];
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
                    [weakSelf postData];
//                    NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
//
//                    [weakSelf.valueArr2 replaceObjectAtIndex:indexPath.row withObject:str];
//
//                    [weakSelf.tableview reloadData];
                }];
            }
                
            default:
                break;
        }
    }
}

#pragma mark - 懒加载
//- (NSMutableArray *)valueArr{
//    if (!_valueArr) {
//        _valueArr = [NSMutableArray array];
//
//    }
//    return _valueArr;
//}
//
//- (NSMutableArray *)valueArr2{
//    if (!_valueArr2) {
//        _valueArr2 = [NSMutableArray array];
//
//    }
//    return _valueArr2;
//}

@end
