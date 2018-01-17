//
//  GLIntegralGoodsTwoCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsTwoCell.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"

@interface GLIntegralGoodsTwoCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;


@end

static NSString *integralGoodsTwoCollectionViewCell = @"LBIntegralGoodsTwoCollectionViewCell";
@implementation GLIntegralGoodsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];

     [self.collectionV registerNib:[UINib nibWithNibName:integralGoodsTwoCollectionViewCell bundle:nil] forCellWithReuseIdentifier:integralGoodsTwoCollectionViewCell];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:integralGoodsTwoCollectionViewCell forIndexPath:indexPath];


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 35)/2.0, (UIScreenWidth - 35)/2.0 + 100);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)refreshdataSource:(NSArray *)arr{
    
    self.dataArr = arr;
    [self.collectionV reloadData];

}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}


@end
