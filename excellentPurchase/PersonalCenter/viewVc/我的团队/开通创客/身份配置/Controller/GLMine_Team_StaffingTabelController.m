//
//  GLMine_Team_StaffingTabelController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_StaffingTabelController.h"

#import "GLMine_Team_StaffingCell.h"

@interface GLMine_Team_StaffingTabelController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@end

@implementation GLMine_Team_StaffingTabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"身份配置";
    
    [self.tabelView registerNib:[UINib nibWithNibName:@"GLMine_Team_StaffingCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Team_StaffingCell"];

}


#pragma mark - 提交分配
- (IBAction)submit:(id)sender {
    
    for (int i = 0 ; i < self.models.count; i++) {
        GLMine_Team_OpenSet_subModel *model = self.models[i];
        
        if (model.personNum <= 0) {
            NSString *str = [NSString stringWithFormat:@"请正确设置%@的数量", self.models[i].name];
            [EasyShowTextView showInfoText:str];
            return;
        }
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (GLMine_Team_OpenSet_subModel *model in self.models) {
        [arrM addObject:@(model.personNum)];
    }
    
    if (self.block) {
        self.block(arrM);
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - UITabelViewDelegate UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_Team_StaffingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Team_StaffingCell"];
    cell.model = self.models[indexPath.row];
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
