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
#import "GLMine_ShoppingCartHeader.h"
#import "GLMine_ShoppingCartGuessCell.h"

#import "GLMine_ShoppingCartModel.h"

#import "LBMineSureOrdersViewController.h"//提交订单
#import "LBProductDetailViewController.h"//海淘商城-商品详情
#import "LBEatShopProdcutClassifyViewController.h"//店铺详情

@interface GLMine_ShoppingCartController ()<UITableViewDelegate,UITableViewDataSource,GLMine_ShoppingCartCellDelegate,GLMine_ShoppingCartHeaderDelegate,GLMine_ShoppingCartGuessCellDelegate>
{
    BOOL _isSelectedAll;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;//结算按钮

@property (nonatomic, strong)UIButton *rightBtn;//导航栏右键
@property (nonatomic, strong)NSMutableArray *models;//数据源

@property (weak, nonatomic) IBOutlet UIView *clearView;//结算view
@property (weak, nonatomic) IBOutlet UIView *editView;//编辑view
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//选中标志(完成)
@property (weak, nonatomic) IBOutlet UIImageView *signImageV2;//选中标志(编辑)
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//总价


@property (strong, nonatomic)NodataView *nodataV;


@end

@implementation GLMine_ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartGuessCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartGuessCell"];
    
     [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self setupNpdata];//设置无数据的时候展示
    
    WeakSelf;

    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    }];
    
    [self postRequest:YES];

}

//刷新
-(void)refreshReceivingAddress{
    [self postRequest:YES];
}

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.tableView.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}


#pragma mark - 请求数据
-(void)postRequest:(BOOL)isRefresh{

    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [NetworkManager requestPOSTWithURLStr:kuser_cart_data paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                GLMine_ShoppingCartDataModel *model = [GLMine_ShoppingCartDataModel mj_objectWithKeyValues:dict];
                [self.models addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableView reloadData];
        
    }];
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

#pragma mark -  状态改变
/**
 状态改变
 */
- (void)setDone:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.editView.hidden = NO;
        self.clearView.hidden = YES;
    }else{
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.editView.hidden = YES;
        self.clearView.hidden = NO;
    }
    
    NSInteger num = 0;
    CGFloat totalPrice = 0.00;
    
    for (GLMine_ShoppingCartDataModel *sectionModel in self.models) {
        
        for (GLMine_ShoppingCartModel *model in sectionModel.goods) {
            model.isEdit = !model.isEdit;
            if (model.isSelected) {
                num += 1;
                totalPrice = totalPrice + [model.buy_num integerValue] * [model.marketprice floatValue];
            }
            
        }
    }
 
    [self.clearBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",num] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
    
    [self.tableView reloadData];
    
}

#pragma mark -  全选
- (IBAction)selectAll:(id )sender {
    
    if (self.models.count == 0) {
        return;
    }

    _isSelectedAll = !_isSelectedAll;
    
    if (_isSelectedAll) {
        self.signImageV.image = [UIImage imageNamed:@"pay-select-y"];
        self.signImageV2.image = [UIImage imageNamed:@"pay-select-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
        self.signImageV2.image = [UIImage imageNamed:@"pay-select-n"];
    }
    
    
    for (GLMine_ShoppingCartDataModel *sectionModel in self.models) {
        for (GLMine_ShoppingCartModel *model in sectionModel.goods) {
            if (_isSelectedAll) {
                model.isSelected = YES;
            }else{
                model.isSelected = NO;
            }
        }
        
        if (_isSelectedAll) {
            sectionModel.shopIsSelected = YES;
        }else{
            sectionModel.shopIsSelected = NO;
        }
    }
    
    [self caculateThePriceAndGoodsNum];
    
    [self.tableView reloadData];
    
}
#pragma mark - 结算
- (IBAction)clearCart:(id)sender {
    
    NSMutableArray *goods_idArr = [NSMutableArray array];
    NSMutableArray *specArr = [NSMutableArray array];
    NSMutableArray *countArr = [NSMutableArray array];
    
    for (GLMine_ShoppingCartDataModel *sectionModel in self.models) {

        for (GLMine_ShoppingCartModel *model in sectionModel.goods)
        {
            if (model.isSelected)
            {
                [goods_idArr addObject:model.goods_id];
                [specArr addObject:model.goods_option_id];
                [countArr addObject:model.buy_num];
            }
        }
    }
    
    if(goods_idArr.count == 0){
        [EasyShowTextView showInfoText:@"还未选中商品"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"goods_str"] = [goods_idArr componentsJoinedByString:@"_"];
    dic[@"spec_str"] = [specArr componentsJoinedByString:@"_"];
    dic[@"count_str"] = [countArr componentsJoinedByString:@"_"];
    
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderConfirm_product_order paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.hidesBottomBarWhenPushed = YES;
            LBMineSureOrdersViewController *sureOrderVC = [[LBMineSureOrdersViewController alloc] init];
            sureOrderVC.DataArr = responseObject[@"data"];
            [self.navigationController pushViewController:sureOrderVC animated:YES];
         
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
    
//    self.hidesBottomBarWhenPushed = YES;
//    LBMineSureOrdersViewController *payVC = [[LBMineSureOrdersViewController alloc] init];
//    [self.navigationController pushViewController:payVC animated:YES];
    
}

#pragma mark -  移入收藏夹
- (IBAction)moveToCollector:(id)sender {
    NSLog(@"移入收藏夹");
}

#pragma mark - 删除
- (IBAction)deleteGoods:(id)sender {

    WeakSelf;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要删除这些商品吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"app_handler"] = @"DELETE";
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
        
        NSMutableArray *idArr = [NSMutableArray array];
        
        for (GLMine_ShoppingCartDataModel *sectionModel in weakSelf.models) {
            for (GLMine_ShoppingCartModel *model in sectionModel.goods)
            {
                if (model.isSelected)
                {
                    [idArr addObject:model.id];
                }
            }
        }
        if(idArr.count == 0){
            [EasyShowTextView showInfoText:@"还未选中商品"];
            return;
        }
        
        dic[@"cart_id"] = [idArr componentsJoinedByString:@","];
        
        [EasyShowLodingView showLoding];
        [NetworkManager requestPOSTWithURLStr:kdel_user_cart paramDic:dic finish:^(id responseObject) {
           
            [EasyShowLodingView hidenLoding];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
             
                NSMutableArray *buyerTempArr = [[NSMutableArray alloc] init];
                
                for (GLMine_ShoppingCartDataModel *sectionModel in weakSelf.models) {
                    if (sectionModel.shopIsSelected)
                    {
                        [buyerTempArr addObject:sectionModel];
                        
                    }else{
                        
                        NSMutableArray *productTempArr = [[NSMutableArray alloc] init];
                        for (GLMine_ShoppingCartModel *model in sectionModel.goods)
                        {
                            if (model.isSelected)
                            {
                                [productTempArr addObject:model];
                            }
                        }
                        
                        if (productTempArr.count != 0) {
                            
                            NSMutableArray *tempM = [NSMutableArray array];
                            [tempM addObjectsFromArray:sectionModel.goods];
                            [tempM removeObjectsInArray:productTempArr];
                            
                            sectionModel.goods = tempM;
                        }
                    }
                }
                
                [EasyShowTextView showSuccessText:@"删除成功"];
                [weakSelf.models removeObjectsInArray:buyerTempArr];
                
                [weakSelf updateInfomation];//删除之后一些列更新操作
                
            }else{
                [EasyShowTextView showErrorText:responseObject[@"message"]];
            }
       
        } enError:^(NSError *error) {
       
            [EasyShowLodingView hidenLoding];
            [EasyShowTextView showErrorText:error.localizedDescription];
          
        }];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - 删除之后一些列更新操作
- (void)updateInfomation{
    // 会影响到对应的买手选择
    for (GLMine_ShoppingCartDataModel *sectionModel in self.models) {
        NSInteger count = 0;
        for (GLMine_ShoppingCartModel *model in sectionModel.goods){
            if (model.isSelected) {
                count ++;
            }
        }
        if (count == sectionModel.goods.count) {
            sectionModel.shopIsSelected = YES;
        }
    }

    // 再次影响到全部选择按钮
    [self isSelectAll];
    [self caculateThePriceAndGoodsNum];
    
    [self.tableView reloadData];
    
    // 如果删除干净了
    if (self.models.count == 0) {
        [self setDone:self.rightBtn];
        self.rightBtn.enabled = NO;
    }
}

/**
 算出商品的总价格 和 商品数 并显示
 */
- (void)caculateThePriceAndGoodsNum{
    
    ///算出商品的总价格 和 商品数
    NSInteger num = 0;
    CGFloat totalPrice = 0.00;
    for (GLMine_ShoppingCartDataModel *sectionModel in self.models) {
        for (GLMine_ShoppingCartModel *model in sectionModel.goods) {
            
            if (model.isSelected) {
                num += 1;
                totalPrice = totalPrice + [model.buy_num integerValue] * [model.marketprice floatValue];
            }
        }
    }
    
    [self.clearBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",num] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
    
}

///判断出购物车界面的全选按钮是否为选中状态  并显示相应的图标
- (void)isSelectAll{
    
    NSInteger totalNum = 0;
    NSInteger selectedNum = 0;
    for (GLMine_ShoppingCartDataModel *sectionM in self.models) {
        
        for (GLMine_ShoppingCartModel *model in sectionM.goods) {
            if (model.isSelected) {
                selectedNum += 1;
            }
            totalNum += 1;
        }
    }
    
    if (totalNum == selectedNum) {
        self.signImageV.image = [UIImage imageNamed:@"pay-select-y"];
        self.signImageV2.image = [UIImage imageNamed:@"pay-select-y"];
        _isSelectedAll = YES;
    }else{
        self.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
        self.signImageV2.image = [UIImage imageNamed:@"pay-select-n"];
        _isSelectedAll = NO;
    }
    
    if (self.models.count == 0) {
        self.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
        self.signImageV2.image = [UIImage imageNamed:@"pay-select-n"];
        _isSelectedAll = NO;
    }
}

#pragma mark - GLMine_ShoppingCartCellDelegate 选中或取消 加减数量
/**
 选中 取消选中
 @param index cell索引
 */
- (void)changeStatus:(NSInteger)index andSection:(NSInteger)section{
    
    NSLog(@"---%zd------%zd",section,index);
    
    GLMine_ShoppingCartDataModel *sectionModel = self.models[section];
    GLMine_ShoppingCartModel *model = sectionModel.goods[index];
    
    ///改变cell的选中状态
    model.isSelected = !model.isSelected;
    
    ///判断出店铺的选中图标是否为选中状态
    NSInteger sectionNum = 0;
    for (GLMine_ShoppingCartModel *model in sectionModel.goods) {
        if (model.isSelected) {
            sectionNum += 1;
        }
    }
    
    if (sectionNum == sectionModel.goods.count) {
        sectionModel.shopIsSelected = YES;
    }else{
        sectionModel.shopIsSelected = NO;
    }
    
    ///算出商品的总价格 和 商品数
    [self caculateThePriceAndGoodsNum];
    
    ///判断出购物车界面的全选按钮是否为选中状态
    [self isSelectAll];
    
//    [self.tableView reloadData];
    CGPoint offset = self.tableView.contentOffset;
    
    [UIView performWithoutAnimation:^{
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.tableView layoutIfNeeded]; // 强制更新
    [self.tableView setContentOffset:offset];
}

/**
 加减数量
 @param index cell索引 isAdd 是否是加数量
 */
- (void)changeNum:(NSInteger)index andSection:(NSInteger)section andIsAdd:(BOOL)isAdd{
    GLMine_ShoppingCartDataModel *sectionModel = self.models[section];
    GLMine_ShoppingCartModel *model = sectionModel.goods[index];
    
    NSInteger number = [model.buy_num integerValue];
    
    if (isAdd) {
        number += 1;
    }else{
        if(number <= 1){
            number = 1;
        }else{
            number -= 1;
        }
    }
    
    model.buy_num = [NSString stringWithFormat:@"%zd",number];
    
    [self.tableView reloadData];

}

#pragma mark - GLMine_ShoppingCartHeaderDelegate 进店 选中该店所有商品

- (void)goToStore:(NSInteger)section{
    
    GLMine_ShoppingCartDataModel *model = self.models[section];

    LBEatShopProdcutClassifyViewController *vc = [[LBEatShopProdcutClassifyViewController alloc] init];
    vc.store_id = model.store_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

///选中该商店所有商品
- (void)selectStoreGoods:(NSInteger)section{

    GLMine_ShoppingCartDataModel *dataModel = self.models[section];

    dataModel.shopIsSelected = !dataModel.shopIsSelected;
    
    if (dataModel.shopIsSelected) {
        
        for (GLMine_ShoppingCartModel *model in dataModel.goods) {
            model.isSelected = YES;
        }
    }else{
        for (GLMine_ShoppingCartModel *model in dataModel.goods) {
            model.isSelected = NO;
        }
    }

    ///算出商品的总价格 和 商品数
    [self caculateThePriceAndGoodsNum];

    ///判断出购物车界面的全选按钮是否为选中状态
    [self isSelectAll];
    
    CGPoint offset = self.tableView.contentOffset;
    [UIView performWithoutAnimation:^{

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.tableView layoutIfNeeded]; // 强制更新
    [self.tableView setContentOffset:offset];

}

#pragma mark - GLMine_ShoppingCartGuessCellDelegate 猜你喜欢
//跳转到商品详情
- (void)toGoodsDetail:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController *payVC = [[LBProductDetailViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

        return self.models.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    GLMine_ShoppingCartDataModel *model = self.models[section];
    return model.goods.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartCell"];
    
    GLMine_ShoppingCartDataModel *model = self.models[indexPath.section];
    
    GLMine_ShoppingCartModel *goodsModel = model.goods[indexPath.row];
    
    goodsModel.index = indexPath.row;
    goodsModel.section = indexPath.section;
    
    cell.model = goodsModel;
    cell.delegate = self;
    cell.selectionStyle = 0;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  GLMine_ShoppingCartHeader *headerView;
            
            if (!headerView) {
                headerView = [[GLMine_ShoppingCartHeader alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
                headerView.delegate = self;
                
            }
            
            GLMine_ShoppingCartDataModel *sectionModel = self.models[section];
            sectionModel.shopSection = section;
            headerView.model = sectionModel;
            
            return headerView;
            
//
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 50;


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GLMine_ShoppingCartDataModel *sectionModel = self.models[indexPath.section];
    GLMine_ShoppingCartModel *model = sectionModel.goods[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController *vc = [[LBProductDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}


@end
