//
//  GLMine_MessageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MessageController.h"
#import "GLMine_MessageCell.h"

#import "GLMine_Message_LogisticsController.h"//物流信息
#import "GLMine_Message_PropertyController.h"//我的资产
#import "GLMine_Message_TrendsController.h"//我的动态
#import "GLMine_Message_SystemController.h"//系统消息
#import "GLMine_Message_InteractController.h"//互动消息

@interface GLMine_MessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, strong)NSMutableArray *imageArr;
@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组

@end

@implementation GLMine_MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息中心";
     [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MessageCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MessageCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MessageCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.picImageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@"我的资产",@"我的动态",@"系统消息", nil];
        
    }
    return _titleArr;
}

- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        
//        _imageArr = [NSMutableArray arrayWithObjects:@"message_logistics",@"message_property",@"message_newsfeed",@"message_system",@"message_Interactive", nil];
        
        _imageArr = [NSMutableArray arrayWithObjects:@"message_property",@"message_newsfeed",@"message_system", nil];
    }
    return _imageArr;
}

-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {
        _userVcArr=[NSMutableArray arrayWithObjects:
                    @"GLMine_Message_PropertyController",
                    @"GLMine_Message_TrendsController",
                    @"GLMine_Message_SystemController",nil];
        
    }
    
    return _userVcArr;
}

@end
