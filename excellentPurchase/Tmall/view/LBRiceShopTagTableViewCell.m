//
//  LBRiceShopTagTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRiceShopTagTableViewCell.h"
#import "LBRiceShopTagCollectionCell.h"

@interface LBRiceShopTagTableViewCell()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

@implementation LBRiceShopTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionview registerNib:[UINib nibWithNibName:@"LBRiceShopTagCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"LBRiceShopTagCollectionCell"];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionview reloadData];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBRiceShopTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBRiceShopTagCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LBTmallSeconedClassifyModel *model = self.dataArr[indexPath.item];
    [self.delegate jumpGoodsClassify:model.cate_id cataname:model.catename];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(45, 70);
    
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
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
    
}
@end
