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
#import "LBAddCounterProductView.h"//

#import "GLStoreCounterModel.h"//货柜界面模型

#import "LBCounterStutasView.h"//状态选择
#import "LBAddOrEditProductViewController.h"//添加商品

@interface LBStoreCounterViewController ()<UITableViewDataSource,UITableViewDelegate,LBStoreCounterdelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *containerNameLabel;//货柜名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;//货柜商品件数
@property (weak, nonatomic) IBOutlet UILabel *onShelfLabel;//上架数
@property (weak, nonatomic) IBOutlet UILabel *aduitLabel;//审核数
@property (weak, nonatomic) IBOutlet UILabel *offShelfLabel;//下架数

@property (strong, nonatomic) UIButton *rightbutton;
@property (strong, nonatomic) UIView *masckView;
@property (strong, nonatomic) LBCounterStutasView *counterStutasView;

@property (strong, nonatomic)NSMutableArray *models;
@property (nonatomic, strong)GLStoreCounterModel *headerModel;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@property (nonatomic, assign)NSInteger type;//当前商品状态 1获取全部 2上架中 3下架中 4审核中 5审核失败

@end

static NSString *ID = @"LBStoreCounterTableViewCell";

@implementation LBStoreCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];

    [self.view addSubview:self.masckView];
    [self.view addSubview:self.counterStutasView];
    
    self.masckView.hidden = YES;
    self.counterStutasView.hidden = YES;
    
    [self setupNpdata];//设置无数据的时候展示
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"AddOrEditGoodsNotification" object:nil];

}


/**
 设置导航栏
 */
- (void)setNav{
    self.navigationItem.title = @"货柜";
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
}

//刷新
-(void)refresh{
    [self postRequest:YES];
}

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
    self.tableview.tableFooterView = [UIView new];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableview.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableview.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableview.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableview.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    self.type = 1;
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"conid"] = self.store_id;
    dic[@"type"] = @(self.type);
    
    [NetworkManager requestPOSTWithURLStr:kcontainer_goods_list paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            
            GLStoreCounterModel *headerModel = [GLStoreCounterModel mj_objectWithKeyValues:responseObject[@"data"][@"con"]];
            
            self.headerModel = headerModel;
            
            for (NSDictionary *dict in responseObject[@"data"][@"goods"][@"page_data"]) {
                GLStoreCounter_goodsModel *model = [GLStoreCounter_goodsModel mj_objectWithKeyValues:dict];
                [self.models addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self assignmentHeaerV];
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableview reloadData];
        
    }];
}

//头部视图赋值
- (void)assignmentHeaerV {
    
    self.containerNameLabel.text = [NSString stringWithFormat:@"货柜:%@",self.headerModel.conname];
    self.goodsNumLabel.text = [NSString stringWithFormat:@"货柜商品:%@件",self.headerModel.goodscount];
    self.onShelfLabel.text = [NSString stringWithFormat:@"上架:%@件",self.headerModel.theshelves];
    self.aduitLabel.text = [NSString stringWithFormat:@"审核:%@件",self.headerModel.auditing];
    self.offShelfLabel.text = [NSString stringWithFormat:@"下架:%@件",self.headerModel.offtheshelf];
    
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
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBStoreCounterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegete = self;
    cell.rowindex = indexPath.row;
    cell.model = self.models[indexPath.row];
    
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
 */
-(void)saleOutProduct:(NSInteger)index{
    
    GLStoreCounter_goodsModel *model = self.models[index];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"conid"] = self.store_id;
    dic[@"goodsid"] = model.goods_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kcontainer_goods_lower paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"下架成功"];
            model.status = @"2";
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableview reloadData];
        
    }];
}

/**
 编辑
 */
-(void)EditProduct:(NSInteger)index{
    
    
}

/**
 添加商品
 */
- (IBAction)addProducts:(UIButton *)sender {
    
    WeakSelf;
    [LBAddCounterProductView addCounterProductloack:^(NSInteger index) {

        LBAddOrEditProductViewController *vc = [[LBAddOrEditProductViewController alloc] init];
        vc.type = index;
        vc.store_id = self.store_id;
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
}

/**
删除商品
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

#pragma mark - 懒加载
//
//-(NSArray*)dataArr{
//    if (!_dataArr) {
//        _dataArr = [NSArray arrayWithObjects:@"修改密码",@"修改二级密码",@"修改手机号",@"修改绑定银行卡", nil];
//    }
//    return _dataArr;
//}

-(UIView*)masckView{
    if (!_masckView) {
        _masckView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, self.view.width, self.view.height)];
        _masckView.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMaskView)];
        [_masckView addGestureRecognizer:tap];
        
    }
    return _masckView;
}

- (LBCounterStutasView *)counterStutasView{
    if (!_counterStutasView) {

        _counterStutasView = [[LBCounterStutasView alloc]initWithFrame:CGRectMake(UIScreenWidth - 150, SafeAreaTopHeight, 150, 250) dataSorce:@[@"全部",@"上架中",@"审核中",@"审核失败",@"已下架"] cellHeight:50 selectindex:^(NSInteger index, NSString *text) {
            
            NSLog(@"%ld",index);
        }];
        
        _counterStutasView.layer.position = CGPointMake(UIScreenWidth, SafeAreaTopHeight);
        _counterStutasView.layer.anchorPoint = CGPointMake(1,0);
    }
    return _counterStutasView;
}

-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
}

@end
