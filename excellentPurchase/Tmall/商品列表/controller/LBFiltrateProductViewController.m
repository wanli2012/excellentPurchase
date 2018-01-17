//
//  LBFiltrateProductViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFiltrateProductViewController.h"
#import "LBFilterMallShopCollectionViewCell.h"
#import "LBFilterMailShopCollectionReusableView.h"
#import "LBFilterMailShopHeader1ViewReusableView.h"

@interface LBFiltrateProductViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

//设置标识
static NSString *LBFilterMailShopView = @"LBFilterMailShopCollectionReusableView";
static NSString *LBFilterMallShopCell = @"LBFilterMallShopCollectionViewCell";
static NSString *filterMailShopHeader1ViewReusableView = @"LBFilterMailShopHeader1ViewReusableView";

@implementation LBFiltrateProductViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"筛选宝贝";

#pragma mark -- 注册单元格
    [_collectionview registerNib:[UINib nibWithNibName:LBFilterMallShopCell bundle:nil] forCellWithReuseIdentifier:LBFilterMallShopCell];
#pragma mark -- 注册头部视图
    [_collectionview registerNib:[UINib nibWithNibName:LBFilterMailShopView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LBFilterMailShopView];
    [_collectionview registerNib:[UINib nibWithNibName:filterMailShopHeader1ViewReusableView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterMailShopHeader1ViewReusableView];
    
}

#pragma UICollectionDelegate UICollectionDataSource
//有多少个Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBFilterMallShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LBFilterMallShopCell forIndexPath:indexPath];
  
    return cell;
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    
    if (kind ==UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            //定制头部视图的内容
            LBFilterMailShopHeader1ViewReusableView *headerV = (LBFilterMailShopHeader1ViewReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterMailShopHeader1ViewReusableView forIndexPath:indexPath];
            
            reusableView = headerV;
        }else{
            //定制头部视图的内容
            LBFilterMailShopCollectionReusableView *headerV = (LBFilterMailShopCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LBFilterMailShopView forIndexPath:indexPath];
            
            reusableView = headerV;
        }
    }
    
    return reusableView;
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(UIScreenWidth,220);
    }else {
        return CGSizeMake(self.view.width, 30);
    }
    return CGSizeMake(0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((self.view.width - 50)/4, 40);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
