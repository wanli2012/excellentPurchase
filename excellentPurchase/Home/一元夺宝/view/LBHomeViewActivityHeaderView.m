//
//  LBHomeViewActivityHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewActivityHeaderView.h"
#import "LBHomeViewActivityCollectionViewCell.h"

@interface LBHomeViewActivityHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

@implementation LBHomeViewActivityHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.collectionview registerNib:[UINib nibWithNibName:@"LBHomeViewActivityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBHomeViewActivityCollectionViewCell"];

}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBHomeViewActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBHomeViewActivityCollectionViewCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LBHomeViewActivityHistoryModel *model = _dataArr[indexPath.item];
    if (self.jumpactivitydetail) {
        self.jumpactivitydetail(model);
    }

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 22)/3.0, (UIScreenWidth - 22)/3.0  +  55);
    
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
    return 1.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)setDataArr:(NSArray<LBHomeViewActivityHistoryModel *> *)dataArr{
    _dataArr = dataArr;
    [_collectionview reloadData];
    
}


@end
