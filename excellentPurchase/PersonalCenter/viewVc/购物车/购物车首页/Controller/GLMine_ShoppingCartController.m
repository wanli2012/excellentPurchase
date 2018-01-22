//
//  GLMine_ShoppingCartController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartController.h"
#import "GLMine_ShoppingCartCell.h"
#import "GLMine_ShoppingCartModel.h"

@interface GLMine_ShoppingCartController ()<UITableViewDelegate,UITableViewDataSource,GLMine_ShoppingCartCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;//结算按钮

@property (nonatomic, strong)UIButton *rightBtn;//导航栏右键

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

/**
 导航栏设置
 */
- (void)setNav{
    self.navigationItem.title = @"购物车";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(setDone:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

/**
 状态改变
 */
- (void)setDone:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    for (GLMine_ShoppingCartModel *model in self.models) {
        model.isDone = !model.isDone;
    }
    [self.tableView reloadData];
    
}


/**
 全选
 */
- (IBAction)selectAll:(id)sender {
    NSLog(@"全选");
}

/**
 结算
 */
- (IBAction)clearCart:(id)sender {
    NSLog(@"结算");
}

/**
 移入收藏夹
 */

- (IBAction)moveToCollector:(id)sender {
    NSLog(@"移入收藏夹");
}

/**
 删除
 */
- (IBAction)deleteGoods:(id)sender {
    NSLog(@"删除");
}

#pragma mark - GLMine_ShoppingCartCellDelegate 选中 取消选中
- (void)changeStatus:(NSInteger)index{
    GLMine_ShoppingCartModel *model = self.models[index];
    model.isSelected = !model.isSelected;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartCell"];
    
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    GLMine_ShoppingCartModel *model = self.models[indexPath.row];
//    model.isSelected = !model.isSelected;
//    [tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
        for (int i = 0; i < 8; i++) {
            GLMine_ShoppingCartModel * model = [[GLMine_ShoppingCartModel alloc] init];
            model.goodsName = [NSString stringWithFormat:@"商品%zd,该商品你值得拥有商品你值得拥有商品你值得拥",i];
            model.spec = [NSString stringWithFormat:@"绿色 M"];
            model.price = [NSString stringWithFormat:@"100%zd",i];
            model.jifen = [NSString stringWithFormat:@"1%zd",i];
            model.coupon = [NSString stringWithFormat:@"2%zd",i];
            
            model.stock = [NSString stringWithFormat:@"10%zd",i];
            model.amount = [NSString stringWithFormat:@"1%zd",i];
            model.isSelected = NO;
            model.isDone = YES;
            [_models addObject:model];
        }
    }
    return _models;
}

@end
