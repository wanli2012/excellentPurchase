//
//  GLIntegralGoodsOneCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsOneCell.h"
#import "LBIntegralGoodsOneCollectionViewCell.h"

@interface GLIntegralGoodsOneCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionv;
@property (strong, nonatomic)NSMutableArray *imagearr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *srolleHeght;

@end

static NSString *ID = @"LBIntegralGoodsOneCollectionViewCell";

@implementation GLIntegralGoodsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    [self.collectionv registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.collectionv reloadData];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.refrshDatasorece = ^{
        [_collectionv reloadData];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegete clickGoodsdetail:((LBTmallhomepageDataStructureModel*)self.dataArr[indexPath.item]).goods_id];
 
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(150, 150 * 2/3.0 + 90);
    
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
    return 20.0f;
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
-(NSMutableArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = [NSMutableArray array];
    }
    
    return _imagearr;
    
}


@end
