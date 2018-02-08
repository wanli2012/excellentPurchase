//
//  LBSwitchAccountViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSwitchAccountViewController.h"
#import "LBSwitchAccountTableViewCell.h"

#import "GLAccountModel.h"//数据库模型

@interface LBSwitchAccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) GLAccountModel *projiectmodel;//综合项目本地保存
@property (nonatomic, strong)NSMutableArray *fmdbArr;

@end

static NSString *switchAccountTableViewCell = @"LBSwitchAccountTableViewCell";

@implementation LBSwitchAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"帐号管理";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:switchAccountTableViewCell bundle:nil] forCellReuseIdentifier:switchAccountTableViewCell];
    
    [self getFmdbDatasoruce];//获取数据库信息
}

- (void)getFmdbDatasoruce{
    //获取本地搜索记录
    _projiectmodel = [GLAccountModel greateTableOfFMWithTableName:@"GLAccountModel"];
    
    self.fmdbArr = [NSMutableArray arrayWithArray:[_projiectmodel queryAllDataOfFMDB]];
    
    [self.tableview reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fmdbArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSwitchAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchAccountTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.fmdbArr[indexPath.row];
    
    [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"headPic"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    cell.IDNumberLabel.text = dic[@"userName"];
    cell.groupNameLabel.text = dic[@"groupName"];
    
    cell.phoneLabel.text = dic[@"phone"];
    NSString *str = dic[@"nickName"];
    
    if(str.length == 0){
        str = [NSString stringWithFormat:@"昵称:(未设置)"];
    }else{
        str = dic[@"nickName"];
    }
    
    cell.nickNameLabel.text = str;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
