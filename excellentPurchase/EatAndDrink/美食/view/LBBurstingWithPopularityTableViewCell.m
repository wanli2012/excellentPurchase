//
//  LBBurstingWithPopularityTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBurstingWithPopularityTableViewCell.h"
#import "LBBurstingWithPopularityCollectionViewCell.h"

@interface LBBurstingWithPopularityTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

static NSString *ID = @"LBBurstingWithPopularityCollectionViewCell";

@implementation LBBurstingWithPopularityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];

}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBBurstingWithPopularityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 36)/3.0, (UIScreenWidth - 36)/3.0 * EatrecommendScle + 25);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}



@end
