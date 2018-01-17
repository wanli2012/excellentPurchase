//
//  LBTmallProductListViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallProductListViewController.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"
#import "LBShowProductListCollectionViewCell.h"
#import "LBFiltrateProductViewController.h"

typedef NS_ENUM(NSInteger, CollectionViewType) {
    LBCollectionViewTypeDefault ,   // 默认一排两个item
    LBCollectionViewTypeOne,      // 一排一个item
};

@interface LBTmallProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**
 记录菜单选中
 */
@property (strong, nonatomic) UIButton *currentBt;

@property (weak, nonatomic) IBOutlet UIButton *saleBt;
@property (weak, nonatomic) IBOutlet UIButton *priceBt;
@property (weak, nonatomic) IBOutlet UIButton *filtrateBt;

@property (assign, nonatomic) CollectionViewType showType;

@property (strong, nonatomic) UICollectionViewFlowLayout *tableFlowLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowyout;

@end

static NSString *ID = @"LBIntegralGoodsTwoCollectionViewCell";
static NSString *ID2 = @"LBShowProductListCollectionViewCell";

@implementation LBTmallProductListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *search=[[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, 20, 20)];
    search.contentMode = UIViewContentModeScaleAspectFit;
    search.image=[UIImage imageNamed:@"taotao-saerch"];
    self.searchTf.leftView = search;
     self.searchTf.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机


    UIButton *selectBt = [self.view viewWithTag:10];
    selectBt.selected = YES;
    self.currentBt = selectBt;
//    设置按钮文字与图片的距离
     [self.saleBt horizontalCenterTitleAndImage:5];
     [self.priceBt horizontalCenterTitleAndImage:5];
     [self.filtrateBt horizontalCenterTitleAndImage:5];
//    注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.collectionView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellWithReuseIdentifier:ID2];
//    默认展示样式
    self.showType = LBCollectionViewTypeDefault;
    [self.collectionView setCollectionViewLayout:self.collectionFlowyout];
    
}
#pragma mark --- 商品菜单点击
- (IBAction)comprehensiveEvent:(UIButton *)sender {
    
    sender.selected = YES;
    self.currentBt.selected = NO;
    self.currentBt = sender;
    
    switch (sender.tag ) {
        case 10://综合
            
            break;
        case 11://销量
            
            break;
        case 12://价格
            
            break;
        case 13://筛选
        {
            self.hidesBottomBarWhenPushed = YES;
            LBFiltrateProductViewController *vc =[[LBFiltrateProductViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark --- 商品列表展示效果
- (IBAction)productsListShowType:(UIButton *)sender {
    
    if (self.showType == LBCollectionViewTypeDefault) {
        self.showType = LBCollectionViewTypeOne;
        [self.collectionView setCollectionViewLayout:self.tableFlowLayout];
    }else{
        self.showType = LBCollectionViewTypeDefault;
        [self.collectionView setCollectionViewLayout:self.collectionFlowyout];
    }
    [self.collectionView reloadData];
   
}


#pragma mark --- 退出
- (IBAction)backEvent:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.showType == LBCollectionViewTypeDefault) {
        
        LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        return cell;
    }else{
        LBShowProductListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID2 forIndexPath:indexPath];
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


-(UICollectionViewFlowLayout *)tableFlowLayout{
    
    if (_tableFlowLayout == nil) {
        
        _tableFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _tableFlowLayout.itemSize = CGSizeMake(UIScreenWidth, 100);
        
        _tableFlowLayout.minimumInteritemSpacing = 0;
        
        _tableFlowLayout.minimumLineSpacing = 0;
        
    }
    
    return _tableFlowLayout;
    
}

-(UICollectionViewFlowLayout *)collectionFlowyout{
    
    if (_collectionFlowyout == nil) {
        
        _collectionFlowyout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionFlowyout.itemSize = CGSizeMake((UIScreenWidth - 35)/2.0, (UIScreenWidth - 35)/2.0 + 100);
        
        _collectionFlowyout.minimumLineSpacing = 15;
        
        _collectionFlowyout.minimumInteritemSpacing = 10;
        
        [_collectionFlowyout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
    }
    
    return _collectionFlowyout;
    
}


@end
