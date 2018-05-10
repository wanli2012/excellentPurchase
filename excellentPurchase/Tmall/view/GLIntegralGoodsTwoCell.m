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
@property (assign, nonatomic)BOOL isrefresh;//判断是否刷新过，以防滚动的时候一直刷新，出现卡顿

@end

static NSString *integralGoodsTwoCollectionViewCell = @"LBIntegralGoodsTwoCollectionViewCell";
@implementation GLIntegralGoodsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];

     [self.collectionV registerNib:[UINib nibWithNibName:integralGoodsTwoCollectionViewCell bundle:nil] forCellWithReuseIdentifier:integralGoodsTwoCollectionViewCell];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:integralGoodsTwoCollectionViewCell forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.refrshDatasorece = ^{
        [_collectionV reloadData];
    };

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate clickCheckGoodsinfo:((LBTmallhomepageDataStructureModel*)self.dataArr[indexPath.item]).goods_id is_active_challenge:((LBTmallhomepageDataStructureModel*)self.dataArr[indexPath.item]).is_active_challenge];

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
    
    if (self.isrefresh == NO) {
        self.dataArr = arr;
        if (arr.count > 0) {
            self.beautfHeight =  ((UIScreenWidth - 35)/2.0 + 110) * ((arr.count + 1)/2);
        }
        [self.collectionV reloadData];
        self.isrefresh = YES;
    }
    

}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}


@end
