//
//  GLMine_Message_InteractController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_InteractController.h"
#import "GLMine_Message_InteractModel.h"
#import "GLMine_Message_InteractCell.h"

@interface GLMine_Message_InteractController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Message_InteractController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"互动消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Message_InteractCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Message_InteractCell"];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Message_InteractCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Message_InteractCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.estimatedRowHeight = 44;
//    return tableView.rowHeight;
    
    return 75;
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
            GLMine_Message_InteractModel *model = [[GLMine_Message_InteractModel alloc] init];
            model.picName = @"d";
            model.name = [NSString stringWithFormat:@"磊哥"];
            model.date =[NSString stringWithFormat:@"2018-01-0%zd",i];
            model.content = [NSString stringWithFormat:@"您关注了店铺[哈哈哈养生锅],请随时关注小店,祝您购物愉快,本小店随时欢迎您的下次光临!"];
            if(i== 2){
                model.content = @"你好,我是一条短消息";
                model.name = @"测试";
            }
            
            
            [_models addObject:model];
            
        }
    }
    return _models;
}

@end
