//
//  GLMine_PaySucessController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_PaySucessController.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"
#import "GLMine_PaySuccessView.h"
#import "GLMine_PayFailedView.h"

@interface GLMine_PaySucessController ()<GLMine_PayFailedViewDelegate,GLMine_PaySuccessViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GLMine_PaySucessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    
    if(self.type == 1){
        
        flowLayout.headerReferenceSize = CGSizeMake(0, 430);
        self.navigationItem.title = @"付款成功";
    }else{
        flowLayout.headerReferenceSize = CGSizeMake(0, 340);
        self.navigationItem.title = @"付款失败";
    }
    
    //注册头视图
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_PaySuccessView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLMine_PaySuccessView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_PayFailedView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLMine_PayFailedView"];
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBIntegralGoodsTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBIntegralGoodsTwoCollectionViewCell"];
}

#pragma mark - GLMine_PayFailedViewDelegate
///返回订单
- (void)backToOrder{
    NSLog(@"返回订单");
}
//继续购物
- (void)goOn{
     NSLog(@"继续购物");
}
///重试
- (void)tryAgain{
     NSLog(@"重试");
}

#pragma mark - GLMine_PaySuccessViewDelegate
/**
 完成
 */
- (void)completed{
     NSLog(@"完成");
}
/**
 查看订单
 */
- (void)checkOutOrder{
     NSLog(@"查看订单");
}

#pragma mark - UICollectionDelegate
//返回对应section的item 的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}
//创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBIntegralGoodsTwoCollectionViewCell" forIndexPath:indexPath];
    //赋值给cell
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UIScreenWidth - 30)/2, (UIScreenWidth - 30)/2 + 85);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //在这里进行点击cell后的操作
    
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 1) {
        
        GLMine_PaySuccessView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLMine_PaySuccessView"
                                                                                    forIndexPath:indexPath];
        headView.delegate = self;
        return headView;
    }else{
        GLMine_PayFailedView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLMine_PayFailedView"
                                                                                    forIndexPath:indexPath];
        headView.delegate = self;
        return headView;
    }
    
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type == 1) {
            
            return CGSizeMake(self.view.frame.size.width, 430);
        }else{
            return CGSizeMake(self.view.frame.size.width, 340);
        }
    }
    else {
        return CGSizeMake(0, 0);
    }
}


@end
