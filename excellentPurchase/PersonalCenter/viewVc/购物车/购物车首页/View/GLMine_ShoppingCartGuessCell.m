//
//  GLMine_ShoppingCartGuessCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartGuessCell.h"
#import "GLMine_CartGuessCell.h"

@interface GLMine_ShoppingCartGuessCell()<GLMine_CartGuessCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GLMine_ShoppingCartGuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_CartGuessCell" bundle:nil] forCellWithReuseIdentifier:@"GLMine_CartGuessCell"];
    
}

#pragma mark - GLMine_CartGuessCellDelegate
//收藏
- (void)collecte:(NSInteger)index{
    
    NSLog(@"index = %zd",index);
}

#pragma mark - UICollectionViewDelegate
//返回对应section的item 的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

//创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    GLMine_CartGuessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMine_CartGuessCell" forIndexPath:indexPath];
    
    //赋值给cell
    cell.delegate = self;
    cell.index = indexPath.row;
    
//    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UIScreenWidth - 30)/2, (UIScreenWidth - 30)/2 + 85);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //在这里进行点击cell后的操作
    if ([self.delegate respondsToSelector:@selector(toGoodsDetail:)]) {
        [self.delegate toGoodsDetail:self.index];
    }
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


@end
