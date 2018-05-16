//
//  LBShowWinningPictureCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowWinningPictureCell.h"
#import "LBDolphinDetailShowPicCollectionCell.h"
@interface LBShowWinningPictureCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic)NSArray *imagearr;
@property (weak, nonatomic) IBOutlet UILabel *infolb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;


@end

@implementation LBShowWinningPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self.collectionview registerNib:[UINib nibWithNibName:@"LBDolphinDetailShowPicCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"LBDolphinDetailShowPicCollectionCell"];
}

-(void)setModel:(LBShowWinningPicturemodel *)model{
    _model = model;
    self.contentlb.text = _model.indiana_slide_content;
    self.infolb.text = [NSString stringWithFormat:@"%@    %@    期号 : %@",[formattime formateTime:_model.indiana_slide_time],_model.indiana_goods_spec_name,_model.indiana_slide_indiana_number];
    self.imagearr = _model.indiana_slide_thumb;
    [self.collectionview reloadData];
    
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imagearr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBDolphinDetailShowPicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBDolphinDetailShowPicCollectionCell" forIndexPath:indexPath];
    
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:_imagearr[indexPath.row]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bigpicture) {
        self.bigpicture(indexPath.row,self.imagearr);
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 90);
    
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
    return 5.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSArray*)imagearr{
    if (!_imagearr) {
        _imagearr = [NSArray array];
    }
    return _imagearr;
}
@end
