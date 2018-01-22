//
//  GLMine_Message_PropertyListController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_PropertyListController.h"
#import "GLMine_Message_PropertyCell.h"
#import "GLMine_Message_PropertyModel.h"

@interface GLMine_Message_PropertyListController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Message_PropertyListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Message_PropertyCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Message_PropertyCell"];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Message_PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Message_PropertyCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
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
            GLMine_Message_PropertyModel *model = [[GLMine_Message_PropertyModel alloc] init];
            model.changeType = [NSString stringWithFormat:@"购买%zd",i];
            model.date =[NSString stringWithFormat:@"2018-01-0%zd",i];
            model.orderNum = [NSString stringWithFormat:@"10000%zd",i];
            model.amount = [NSString stringWithFormat:@"44%zd",i];
            model.goodsName = [NSString stringWithFormat:@"貂皮大衣%zd",i];
     
            [_models addObject:model];
            
        }
    }
    return _models;
}

@end
