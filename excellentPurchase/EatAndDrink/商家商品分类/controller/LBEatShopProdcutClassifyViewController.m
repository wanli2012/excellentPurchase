//
//  LBEatShopProdcutClassifyViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEatShopProdcutClassifyViewController.h"
#import "LBShopProductClassifyReusableView.h"
#import "LBShopProductClassifyMenuReusableView.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"
#import "LJCollectionViewFlowLayout.h"

@interface LBEatShopProdcutClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;

@end

@implementation LBEatShopProdcutClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
// 注册表头
     [self.collectionView registerNib:[UINib nibWithNibName:@"LBShopProductClassifyReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBShopProductClassifyReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBShopProductClassifyMenuReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBShopProductClassifyMenuReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBIntegralGoodsTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBIntegralGoodsTwoCollectionViewCell"];
    
    LJCollectionViewFlowLayout *layout = [[LJCollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
    
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(UIScreenWidth,UIScreenWidth/2.0 + 70);
    }else {
        return CGSizeMake(UIScreenWidth,50);
    }
    return CGSizeMake(0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsTwoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBIntegralGoodsTwoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
   
    
    return cell;
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 5)/2.0, (UIScreenWidth - 5)/2.0 + 100);
    
}

//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *collectionReusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            LBShopProductClassifyReusableView  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:@"LBShopProductClassifyReusableView"
                                                                                         forIndexPath:indexPath];
            
            collectionReusableView = headview;
        }else{
            
            LBShopProductClassifyMenuReusableView  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                              withReuseIdentifier:@"LBShopProductClassifyMenuReusableView"
                                                                                                     forIndexPath:indexPath];
            
            collectionReusableView = headview;
        }
    }
    return collectionReusableView;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
}

@end
