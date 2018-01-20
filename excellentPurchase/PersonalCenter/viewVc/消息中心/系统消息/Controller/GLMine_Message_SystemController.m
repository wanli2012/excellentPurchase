//
//  GLMine_Message_SystemController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_SystemController.h"
#import "GLMine_Message_TrendsCell.h"
#import "GLMine_Message_TrendsModel.h"

@interface GLMine_Message_SystemController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Message_SystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Message_TrendsCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Message_TrendsCell"];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Message_TrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Message_TrendsCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    return tableView.rowHeight;
    //    return 95;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    self.hidesBottomBarWhenPushed = YES;
    //    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    //    [self.navigationController pushViewController:dataVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        for (int i = 0; i < 10; i ++) {
            GLMine_Message_TrendsModel *model = [[GLMine_Message_TrendsModel alloc] init];
            model.typeName = [NSString stringWithFormat:@"通知"];
            model.date =[NSString stringWithFormat:@"2018-01-0%zd",i];
            model.content = [NSString stringWithFormat:@"世纪优购1.1.1版本更新啦!请下载最新版本以获取最好的购物体验"];
            if(i== 2){
                model.content = @"你好,我是一条短消息";
                model.typeName = @"测试";
            }
            
            
            [_models addObject:model];
            
        }
    }
    return _models;
}
@end
