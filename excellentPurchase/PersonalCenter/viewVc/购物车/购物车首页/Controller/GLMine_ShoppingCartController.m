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
#import "GLMine_ShoppingCartFailtrueCell.h"

#import "GLMine_ShoppingCartModel.h"

#import "LBMineSureOrdersViewController.h"//提交订单
#import "LBProductDetailViewController.h"//海淘商城-商品详情
#import "LBEatShopProdcutClassifyViewController.h"//店铺详情
#import "GLMine_ShoppingCartfailureHeader.h"
#import "LBSnapUpDetailViewController.h"

@interface GLMine_ShoppingCartController ()<UITableViewDelegate,UITableViewDataSource,GLMine_ShoppingCartCellDelegate,GLMine_ShoppingCartHeaderDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *totalSendprice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editviewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearViewBottom;

@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic) GLMine_ShoppingCartDataModel *model;
@property (assign, nonatomic) BOOL  isEdit;//是否在编辑 默认为NO

@end

@implementation GLMine_ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartFailtrueCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartFailtrueCell"];
    
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

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    WeakSelf;
    [NetworkManager requestPOSTWithURLStr:kuser_cart_data paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.clearBtn setTitle:[NSString stringWithFormat:@"结算(0)"] forState:UIControlStateNormal];
            self.totalPriceLabel.text = [NSString stringWithFormat:@" ¥0.0"];
            self.totalSendprice.text = [NSString stringWithFormat:@"含运费: ¥0.0"];
            self.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
            self.signImageV2.image = [UIImage imageNamed:@"pay-select-n"];
            _isSelectedAll = NO;
            weakSelf.model = [GLMine_ShoppingCartDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (weakSelf.model.cart_data.count > 0) {
                [weakSelf setNav];
                if (UIScreenHeight == 812) {
                    weakSelf.clearViewBottom.constant = 34;
                    weakSelf.editviewBottom.constant = 34;
                }else{
                    weakSelf.clearViewBottom.constant = 0;
                    weakSelf.editviewBottom.constant = 0;
                }
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];
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
    [EasyShowLodingView hidenLoding];
}

/**
 导航栏设置
 */
- (void)setNav{
   
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
    self.isEdit = sender.isSelected;
    if (sender.isSelected) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.editView.hidden = NO;
        self.clearView.hidden = YES;
    }else{
        //像服务器更新添加或者减少的数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"app_handler"] = @"UPDATE";
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;

        NSMutableArray *cart_idArr = [NSMutableArray array];
        NSMutableArray *numArr = [NSMutableArray array];

        for (GLMine_ShoppingCartModel *sectionModel in self.model.cart_data) {

            for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods) {

                [cart_idArr addObject:model.specification_id];
                [numArr addObject:model.buy_num];
            }
        }

        dic[@"cart_id"] = [cart_idArr componentsJoinedByString:@","];
        dic[@"num"] = [numArr componentsJoinedByString:@","];
        [NetworkManager requestPOSTWithURLStr:ksave_cart paramDic:dic finish:^(id responseObject) {
            [LBDefineRefrsh dismissRefresh:self.tableView];
            [EasyShowLodingView hidenLoding];

            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
            }else{
                
            }
        } enError:^(NSError *error) {
           
        }];
        
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.editView.hidden = YES;
        self.clearView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark -  全选
- (IBAction)selectAll:(id )sender {
    
    if (self.model == nil ||  self.model.cart_data.count == 0) {
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
    
    
    for (GLMine_ShoppingCartModel *sectionModel in self.model.cart_data) {
        sectionModel.isSelect = _isSelectedAll;
        for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods) {
            model.isSelect = _isSelectedAll;
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
    
    for (GLMine_ShoppingCartModel *sectionModel in self.model.cart_data) {

        for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods)
        {
            if (model.isSelect)
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
    
    self.clearBtn.backgroundColor = [UIColor lightGrayColor];
    self.clearBtn.enabled = NO;
    [NetworkManager requestPOSTWithURLStr:OrderConfirm_product_order paramDic:dic finish:^(id responseObject) {
        
        self.clearBtn.backgroundColor = MAIN_COLOR;
        self.clearBtn.enabled = YES;
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.hidesBottomBarWhenPushed = YES;
            LBMineSureOrdersViewController *sureOrderVC = [[LBMineSureOrdersViewController alloc] init];
            sureOrderVC.DataArr = responseObject[@"data"];
            sureOrderVC.is_cart = 1;
            [self.navigationController pushViewController:sureOrderVC animated:YES];
         
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [EasyShowLodingView hidenLoding];
        
    } enError:^(NSError *error) {
        
        self.clearBtn.backgroundColor = MAIN_COLOR;
        self.clearBtn.enabled = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

#pragma mark -  移入收藏夹
- (IBAction)moveToCollector:(id)sender {
    NSLog(@"移入收藏夹");
}

#pragma mark - 删除
- (IBAction)deleteGoods:(id)sender {

    NSMutableArray *idArr = [NSMutableArray array];
    for (GLMine_ShoppingCartModel *sectionModel in self.model.cart_data) {
        
        for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods)
        {
            if (model.isSelect)
            {
                [idArr addObject:model.specification_id];
            }
        }
    }
    
    if(idArr.count == 0){
        [EasyShowTextView showInfoText:@"还未选中商品"];
        return;
    }
    
    WeakSelf;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要删除这些商品吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"app_handler"] = @"DELETE";
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;

        dic[@"cart_id"] = [idArr componentsJoinedByString:@","];
        [EasyShowLodingView showLoding];
        [NetworkManager requestPOSTWithURLStr:kdel_user_cart paramDic:dic finish:^(id responseObject) {
           
            [EasyShowLodingView hidenLoding];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
             
                [weakSelf postRequest:YES];
                [EasyShowTextView showSuccessText:@"删除成功"];
                [weakSelf.clearBtn setTitle:[NSString stringWithFormat:@"结算(0)"] forState:UIControlStateNormal];
                weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@" ¥0.0"];
                weakSelf.totalSendprice.text = [NSString stringWithFormat:@"含运费: ¥0.0"];
                weakSelf.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
                weakSelf.signImageV2.image = [UIImage imageNamed:@"pay-select-n"];
                _isSelectedAll = NO;
                
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

/**
 算出商品的总价格 和 商品数 并显示
 */
- (void)caculateThePriceAndGoodsNum{
    
    ///算出商品的总价格 和 商品数 和总运费
    NSInteger num = 0;
    CGFloat totalPrice = 0.0;
    CGFloat totalsnedPrice = 0.0;
    for (GLMine_ShoppingCartModel *sectionModel in self.model.cart_data) {
        for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods) {

            if (model.isSelect) {
                num += [model.buy_num integerValue];
                totalsnedPrice += [model.send_price floatValue] * [model.buy_num intValue];
                if ([model.active.active_status integerValue] == 1) {
                    if ([model.buy_num integerValue] > [model.challenge_max_count integerValue] || [model.active.u_count integerValue] >= [model.challenge_max_count integerValue]) {
                        totalPrice = totalPrice + [model.buy_num integerValue] * [model.marketprice floatValue];
                    }else{
                        totalPrice = totalPrice + [model.buy_num integerValue] * [model.costprice floatValue];
                    }
                }else{
                    totalPrice = totalPrice + [model.buy_num integerValue] * [model.marketprice floatValue];
                }
            }
        }
    }
    
    [self.clearBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",num] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@" ¥%.2f",totalPrice + totalsnedPrice];
    self.totalSendprice.text = [NSString stringWithFormat:@"含运费: ¥%.2f",totalsnedPrice];
}

///判断出购物车界面的全选按钮是否为选中状态  并显示相应的图标
- (void)isSelectAll{
    
    NSInteger totalNum = 0;
    NSInteger selectedNum = 0;
    for (GLMine_ShoppingCartModel *sectionM in self.model.cart_data) {
        
        for (GLMine_ShoppingPropertyCartModel *model in sectionM.goods) {
            if (model.isSelect) {
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
    
    if (self.model.cart_data.count == 0) {
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
    
    GLMine_ShoppingCartModel *sectionModel = self.model.cart_data[section];
    GLMine_ShoppingPropertyCartModel *model = sectionModel.goods[index];
    
    //改变cell的选中状态
    model.isSelect = !model.isSelect;

    ///判断出店铺的选中图标是否为选中状态
    NSInteger sectionNum = 0;
    for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods) {
        if (model.isSelect) {
            sectionNum += 1;
        }
    }

    if (sectionNum == sectionModel.goods.count) {
        sectionModel.isSelect = YES;
    }else{
        sectionModel.isSelect = NO;
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

/**
 加减数量
 @param index cell索引 isAdd 是否是加数量
 */
- (void)changeNum:(NSInteger)index andSection:(NSInteger)section andIsAdd:(BOOL)isAdd{
    GLMine_ShoppingCartModel *sectionModel = self.model.cart_data[section];
    GLMine_ShoppingPropertyCartModel *model = sectionModel.goods[index];

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
    ///算出商品的总价格 和 商品数
    [self caculateThePriceAndGoodsNum];

}

#pragma mark - GLMine_ShoppingCartHeaderDelegate 进店 选中该店所有商品

- (void)goToStore:(NSInteger)section{
    
    GLMine_ShoppingCartModel *model = nil;
    
    if (section > self.model.cart_data.count) {
        model = self.model.abate_data[section - self.model.cart_data.count - 1];
    }else{
        model = self.model.cart_data[section];
    }
    self.hidesBottomBarWhenPushed = YES;
    LBEatShopProdcutClassifyViewController *vc = [[LBEatShopProdcutClassifyViewController alloc] init];
    vc.store_id = model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

///选中该商店所有商品
- (void)selectStoreGoods:(NSInteger)section{

    GLMine_ShoppingCartModel *dataModel = self.model.cart_data[section];

    dataModel.isSelect = !dataModel.isSelect;
    for (GLMine_ShoppingPropertyCartModel *model in dataModel.goods) {
        model.isSelect = dataModel.isSelect;
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

#pragma mark - GLMine_ShoppingCartGuessCellDelegate 猜你喜欢 暂时没有这部分
- (void)toGoodsDetail:(NSInteger)index{
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.model.abate_data.count <= 0) {
         return self.model.cart_data.count;
    }else{
        return self.model.cart_data.count + self.model.abate_data.count + 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.model.abate_data.count <= 0) {
        return ((GLMine_ShoppingCartModel *)self.model.cart_data[section]).goods.count;
    }else{
        if (section < self.model.cart_data.count && section >= 0) {
            return ((GLMine_ShoppingCartModel *)self.model.cart_data[section]).goods.count;
        }else if (section == self.model.cart_data.count){
            return 0;
        }else{
             return ((GLMine_ShoppingCartModel *)self.model.abate_data[section - self.model.cart_data.count - 1]).goods.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section < self.model.cart_data.count && indexPath.section >= 0) {
        
        GLMine_ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartCell"];
        cell.delegate = self;
        cell.selectionStyle = 0;
        GLMine_ShoppingCartModel *modelone = self.model.cart_data[indexPath.section];
        GLMine_ShoppingPropertyCartModel *modeltwo = modelone.goods[indexPath.row];
        modeltwo.isEdit = self.isEdit;
        cell.model = modeltwo;
        cell.index=indexPath.row;
        cell.section = indexPath.section;
        return cell;
        
    }else if (indexPath.section == self.model.cart_data.count){
    }else{
        GLMine_ShoppingCartFailtrueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartFailtrueCell"];
        cell.selectionStyle = 0;
        GLMine_ShoppingCartModel *modelone = self.model.abate_data[indexPath.section- self.model.cart_data.count - 1];
        GLMine_ShoppingPropertyCartModel *modeltwo = modelone.goods[indexPath.row];
        cell.model = modeltwo;
        return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

             if (section == self.model.cart_data.count){
                 GLMine_ShoppingCartfailureHeader *haederv = [[NSBundle mainBundle]loadNibNamed:@"GLMine_ShoppingCartfailureHeader" owner:nil options:nil].firstObject;
                 haederv.pastlb.text = [NSString stringWithFormat:@"失效商品%ld件",self.model.abate_data.count];
                 haederv.dataarr = self.model.abate_data;
                 haederv.Target = self;
                 WeakSelf;
                 haederv.refreshData = ^{
                     [weakSelf postRequest:YES];
                 };
                 return haederv;
            }else{
                
                GLMine_ShoppingCartHeader *headerView;
                if (!headerView) {
                    headerView = [[GLMine_ShoppingCartHeader alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
                    headerView.delegate = self;
                    headerView.section = section;
                }
                if (section < self.model.cart_data.count && section >= 0) {
                    headerView.ishidesignImageV = NO;
                    headerView.model = (GLMine_ShoppingCartModel *)self.model.cart_data[section];
                }else{
                    headerView.ishidesignImageV = YES;
                     headerView.model = (GLMine_ShoppingCartModel *)self.model.abate_data[section - self.model.cart_data.count - 1];
                }
                return headerView;
            }

            return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.model.abate_data.count <= 0) {
       
    }else{
        if (indexPath.section < self.model.cart_data.count && indexPath.section >= 0) {
            
        }else if (indexPath.section == self.model.cart_data.count){
            return  50;
        }else{
          
        }
    }
    
    return 140;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section > self.model.cart_data.count) {
        GLMine_ShoppingCartModel *sectionModel = self.model.abate_data[indexPath.section - self.model.cart_data.count - 1];
        GLMine_ShoppingPropertyCartModel *model = sectionModel.goods[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        LBProductDetailViewController *vc = [[LBProductDetailViewController alloc] init];
        vc.goods_id = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GLMine_ShoppingCartModel *sectionModel = self.model.cart_data[indexPath.section];
        GLMine_ShoppingPropertyCartModel *model = sectionModel.goods[indexPath.row];
        if ([model.active.active_status integerValue] == 1) {//正在活动
            self.hidesBottomBarWhenPushed = YES;
            LBSnapUpDetailViewController *vc = [[LBSnapUpDetailViewController alloc] init];
            vc.goods_id = model.goods_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{//没有活动
            self.hidesBottomBarWhenPushed = YES;
            LBProductDetailViewController *vc = [[LBProductDetailViewController alloc] init];
            vc.goods_id = model.goods_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}


@end
