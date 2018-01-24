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

#import "GLMine_Cart_PayController.h"//支付界面

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

@end

@implementation GLMine_ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ShoppingCartGuessCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ShoppingCartGuessCell"];
    
     [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
        
        for (GLMine_ShoppingCartModel *model in sectionModel.goodsArr) {
            model.isDone = !model.isDone;
            if (model.isSelected) {
                num += 1;
                totalPrice = totalPrice + [model.amount integerValue] * [model.price floatValue];
            }
            
        }
    }
 
    [self.clearBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",num] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
    
    [self.tableView reloadData];
    
}

#pragma mark -  全选
/**
 全选
 */
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
        for (GLMine_ShoppingCartModel *model in sectionModel.goodsArr) {
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

/**
 结算
 */
- (IBAction)clearCart:(id)sender {
    NSLog(@"结算");
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Cart_PayController *payVC = [[GLMine_Cart_PayController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
    
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

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要删除这些商品吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    __weak __typeof__(self) weakSelf = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         NSMutableArray *buyerTempArr = [[NSMutableArray alloc] init];
        
        for (GLMine_ShoppingCartDataModel *sectionModel in weakSelf.models) {
            if (sectionModel.shopIsSelected)
            {
                [buyerTempArr addObject:sectionModel];
            }
            else
            {
                NSMutableArray *productTempArr = [[NSMutableArray alloc] init];
                for (GLMine_ShoppingCartModel *model in sectionModel.goodsArr)
                {
                    if (model.isSelected)
                    {
                        [productTempArr addObject:model];
                    }
                }
               
                if (productTempArr.count != 0) {
                    
                    NSMutableArray *tempM = [NSMutableArray array];
                    [tempM addObjectsFromArray:sectionModel.goodsArr];
                    [tempM removeObjectsInArray:productTempArr];
                    
                    sectionModel.goodsArr = tempM;
                }
            }
        }
        
        [self.models removeObjectsInArray:buyerTempArr];
        
        [self updateInfomation];//删除之后一些列更新操作

        
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
        for (GLMine_ShoppingCartModel *model in sectionModel.goodsArr){
            if (model.isSelected) {
                count ++;
            }
        }
        if (count == sectionModel.goodsArr.count) {
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
 算出商品的总价格 和 商品数  并显示
 */
- (void)caculateThePriceAndGoodsNum{
    
    ///算出商品的总价格 和 商品数
    NSInteger num = 0;
    CGFloat totalPrice = 0.00;
    for (GLMine_ShoppingCartDataModel *sectionModel in self.models) {
        for (GLMine_ShoppingCartModel *model in sectionModel.goodsArr) {
            
            if (model.isSelected) {
                num += 1;
                totalPrice = totalPrice + [model.amount integerValue] * [model.price floatValue];
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
        
        for (GLMine_ShoppingCartModel *model in sectionM.goodsArr) {
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


#pragma mark - GLMine_ShoppingCartCellDelegate
/**
 选中 取消选中
 @param index cell索引
 */
- (void)changeStatus:(NSInteger)index andSection:(NSInteger)section{
    
    NSLog(@"---%zd------%zd",section,index);
    
    GLMine_ShoppingCartDataModel *sectionModel = self.models[section];
    GLMine_ShoppingCartModel *model = sectionModel.goodsArr[index];
    
    ///改变cell的选中状态
    model.isSelected = !model.isSelected;
    
    ///判断出店铺的选中图标是否为选中状态
    NSInteger sectionNum = 0;
    for (GLMine_ShoppingCartModel *model in sectionModel.goodsArr) {
        if (model.isSelected) {
            sectionNum += 1;
        }
    }
    
    if (sectionNum == sectionModel.goodsArr.count) {
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
    GLMine_ShoppingCartModel *model = sectionModel.goodsArr[index];
    
    NSInteger number = [model.amount integerValue];
    
    if (isAdd) {
        number += 1;
    }else{
        if(number <= 1){
            number = 1;
        }else{
            number -= 1;
        }
    }
    
    model.amount = [NSString stringWithFormat:@"%zd",number];
    
    [self.tableView reloadData];

}

#pragma mark - GLMine_ShoppingCartHeaderDelegate
- (void)goToStore:(NSInteger)section{
    NSLog(@"店铺名---%zd",section);
}
///选中该商店所有商品
- (void)selectStoreGoods:(NSInteger)section{

    GLMine_ShoppingCartDataModel *dataModel = self.models[section];

    dataModel.shopIsSelected = !dataModel.shopIsSelected;
    
    if (dataModel.shopIsSelected) {
        
        for (GLMine_ShoppingCartModel *model in dataModel.goodsArr) {
            model.isSelected = YES;
        }
    }else{
        for (GLMine_ShoppingCartModel *model in dataModel.goodsArr) {
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

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.models.count == 0) {//没有商品的时候
        return 2;
    }else{//有商品的时候
        
        return self.models.count + 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.models.count == 0) {//没有商品的时候
        return 1;
    }else{//有商品的时候
        if (section < self.models.count) {
            
            GLMine_ShoppingCartDataModel *model = self.models[section];
            return model.goodsArr.count;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.models.count == 0) {//没有商品的时候
        if (indexPath.section == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor redColor];
            return cell;
        }else{   ///有商品的时候
            GLMine_ShoppingCartGuessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartGuessCell"];
            cell.selectionStyle = 0;
            return cell;
        }
    }else{
        
        if (indexPath.section < self.models.count) {
            
            GLMine_ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartCell"];
            
            GLMine_ShoppingCartDataModel *model = self.models[indexPath.section];
            
            GLMine_ShoppingCartModel *goodsModel = model.goodsArr[indexPath.row];
            goodsModel.index = indexPath.row;
            goodsModel.section = indexPath.section;
            
            cell.model = goodsModel;
            cell.delegate = self;
            cell.selectionStyle = 0;
            
            return cell;
            
        }else{
            GLMine_ShoppingCartGuessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ShoppingCartGuessCell"];
            cell.selectionStyle = 0;
            return cell;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.models.count == 0) {//没有商品的时候
        if (section == 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.0001)];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }else{
            UIView *guessView;
            if (!guessView) {
                
                guessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
                guessView.backgroundColor = [UIColor whiteColor];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = LBHexadecimalColor(0x333333);
                label.text = @"猜你喜欢";
                
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 50 -1, UIScreenWidth, 1)];
                lineV.backgroundColor = [UIColor groupTableViewBackgroundColor];
                
                [guessView addSubview:label];
                [guessView addSubview:lineV];
                
            }
            
            return guessView;
        }
    }else{//有商品的时候
        if (section < self.models.count) {
            
            GLMine_ShoppingCartHeader *headerView;
            
            if (!headerView) {
                headerView = [[GLMine_ShoppingCartHeader alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
                headerView.delegate = self;
                
            }
            GLMine_ShoppingCartDataModel *sectionModel = self.models[section];
            sectionModel.shopSection = section;
            headerView.model = sectionModel;
            
            return headerView;
            
        }else{
            
            UIView *guessView;
            if (!guessView) {
                
                guessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
                guessView.backgroundColor = [UIColor whiteColor];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = LBHexadecimalColor(0x333333);
                label.text = @"猜你喜欢";
                
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 50 -1, UIScreenWidth, 1)];
                lineV.backgroundColor = [UIColor groupTableViewBackgroundColor];
                
                [guessView addSubview:label];
                [guessView addSubview:lineV];
                
            }
            
            return guessView;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.models.count == 0) {//没有商品的时候
        if (section == 0) {
            return 0.0001;
        }else{
            return 50;
        }
    }else{//有商品的时候
        
        return 50;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger goodsNum = 6;
    CGFloat collectionCellWidth = (UIScreenWidth - 30)/2;
    CGFloat collecitonCellHeight = collectionCellWidth + 85;
    
    CGFloat cellHeight = goodsNum/2 * collecitonCellHeight + (goodsNum/2 + 1)* 10;
    
    if (self.models.count == 0) {//没有商品的时候
        if (indexPath.section == 0) {
            return 200;
        }else{
            
            return cellHeight;
        }
    }else{//有商品的时候
        if (indexPath.section < self.models.count) {
            
            return 130;
        }else{
            return cellHeight;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"跳转到商品详情了!!!!!");
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
        for(int j = 0;j < 2;j++){
            GLMine_ShoppingCartDataModel *model = [[GLMine_ShoppingCartDataModel alloc] init];
        
            NSMutableArray *goodsArr = [NSMutableArray array];
            
            for (int i = 0; i < 3; i++) {
                GLMine_ShoppingCartModel * model = [[GLMine_ShoppingCartModel alloc] init];
                model.goodsName = [NSString stringWithFormat:@"商品%zd,该商品你值得拥有商品你值得拥有商品你值得拥",i];
                model.spec = [NSString stringWithFormat:@"绿色 M"];
                model.price = [NSString stringWithFormat:@"%zd",(i+1)*2];
                model.jifen = [NSString stringWithFormat:@"1%zd",i];
                model.coupon = [NSString stringWithFormat:@"2%zd",i];
                
                model.stock = [NSString stringWithFormat:@"10%zd",i];
                model.amount = [NSString stringWithFormat:@"%zd",i+1];
                model.isSelected = NO;
                model.isDone = YES;
                [goodsArr addObject:model];
            }
            
            model.goodsArr = goodsArr;
            model.shopName = [NSString stringWithFormat:@"店铺%zd",j];
            model.shopIsSelected = NO;
            model.shopSection = j;
            
            [_models addObject:model];
        }
    }
    return _models;
}

//- (GLMine_ShoppineCartHeader *)headerView {
//
//    if (!_headerView) {
//        _headerView = [[GLMine_ShoppineCartHeader alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, _kHeaderViewH)];
//        _headerView.delegate = self;
//    }
//    return _headerView;
//}

@end
