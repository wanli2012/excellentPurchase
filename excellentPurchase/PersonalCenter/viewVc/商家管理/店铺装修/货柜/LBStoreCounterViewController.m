//
//  LBStoreCounterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreCounterViewController.h"
#import "LBStoreCounterTableViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBCounterStutasView.h"
#import "LBAddCounterProductView.h"
#import "LBAddOrEditProductViewController.h"

@interface LBStoreCounterViewController ()<UITableViewDataSource,UITableViewDelegate,LBStoreCounterdelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
/**
 数据
 */
@property (strong, nonatomic) NSArray *dataArr;

@property (strong, nonatomic) UIButton *rightbutton;

@property (strong, nonatomic) UIView *masckView;

@property (strong, nonatomic) LBCounterStutasView *counterStutasView;

@end

static NSString *ID = @"LBStoreCounterTableViewCell";

@implementation LBStoreCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"货柜";
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
    _rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_rightbutton setTitle:@"全部" forState:UIControlStateNormal];
    [_rightbutton setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
    [_rightbutton setImage:[UIImage imageNamed:@"shop-货柜筛选-n"] forState:UIControlStateNormal];
    [_rightbutton setImage:[UIImage imageNamed:@"shop-货柜筛选-y"] forState:UIControlStateSelected];
    _rightbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightbutton addTarget:self action:@selector(shooseStutas:) forControlEvents:UIControlEventTouchUpInside];
    [_rightbutton horizontalCenterTitleAndImageRight:5];
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:_rightbutton];
    self.navigationItem.rightBarButtonItem = ba;
    
    _counterStutasView = [[LBCounterStutasView alloc]initWithFrame:CGRectMake(UIScreenWidth - 150, SafeAreaTopHeight, 150, 250) dataSorce:@[@"全部",@"上架中",@"审核中",@"审核失败",@"已下架"] cellHeight:50 selectindex:^(NSInteger index, NSString *text) {
        NSLog(@"%ld",index);
    }];
    _counterStutasView.layer.position = CGPointMake(UIScreenWidth, SafeAreaTopHeight);
    _counterStutasView.layer.anchorPoint = CGPointMake(1,0);
    
    
    [self.view addSubview:self.masckView];
    [self.view addSubview:self.counterStutasView];
    self.masckView.hidden = YES;
    self.counterStutasView.hidden = YES;
    
}

/**
 筛选状态
 */
-(void)shooseStutas:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
            self.masckView.hidden = NO;
            self.counterStutasView.hidden = NO;
        
    }else{
        [self tapgestureMaskView];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBStoreCounterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegete = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    LBAddOrEditProductViewController *vc = [[LBAddOrEditProductViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- LBStoreCounterdelegete

/**
 下架

 @param index <#index description#>
 */
-(void)saleOutProduct:(NSInteger)index{
    
    
}
/**
 编辑
 
 @param index <#index description#>
 */
-(void)EditProduct:(NSInteger)index{
    
    
}
/**
 添加商品
 
 @param index <#index description#>
 */
- (IBAction)addProducts:(UIButton *)sender {
    
    [LBAddCounterProductView addCounterProductloack:^(NSInteger index) {
        NSLog(@"%ld",index);
    }];
}
/**
删除商品
 
 @param index <#index description#>
 */
- (IBAction)deleteProducts:(UIButton *)sender {
    
    
}

/**
 隐藏筛选
 */
-(void)tapgestureMaskView{
    self.masckView.hidden = YES;
    self.counterStutasView.hidden = YES;
    self.rightbutton.selected = NO;
}



-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"修改密码",@"修改二级密码",@"修改手机号",@"修改绑定银行卡", nil];
    }
    return _dataArr;
}

-(UIView*)masckView{
    if (!_masckView) {
        _masckView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, self.view.width, self.view.height)];
        _masckView.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMaskView)];
        [_masckView addGestureRecognizer:tap];
        
    }
    return _masckView;
}


@end
