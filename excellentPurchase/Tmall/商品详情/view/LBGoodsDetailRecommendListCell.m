//
//  LBGoodsDetailRecommendListCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBGoodsDetailRecommendListCell.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"


@interface LBGoodsDetailRecommendListCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, strong)NSArray *dataArr;

@end

static NSString *ID = @"LBIntegralGoodsTwoCollectionViewCell";
@implementation LBGoodsDetailRecommendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collection registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth-1)/2.0, (UIScreenWidth-1)/2.0 + 100);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)refreshDataSorce:(NSArray *)arr{
    if (arr.count > 0) {
//        self.shiftGoodsH =  ((SCREEN_WIDTH - 30)/2.0 + 85) * (([arr count]  - 1) / 3 + 1) + 5;
    }
    self.dataArr = arr;
    [self.collection reloadData];
    
}

-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    
    return _dataArr;
}


@end
