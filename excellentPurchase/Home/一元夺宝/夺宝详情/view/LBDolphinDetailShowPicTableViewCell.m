//
//  LBDolphinDetailShowPicTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailShowPicTableViewCell.h"
#import "LBDolphinDetailShowPicCollectionCell.h"

@interface LBDolphinDetailShowPicTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionv;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UILabel *numbers;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIImageView *iamgev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *userid;

@property (strong, nonatomic)NSArray *imagearr;

@end

@implementation LBDolphinDetailShowPicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionv registerNib:[UINib nibWithNibName:@"LBDolphinDetailShowPicCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"LBDolphinDetailShowPicCollectionCell"];
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
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(63, 63);
    
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
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(void)setDatadic:(NSDictionary *)datadic{
    _datadic = datadic;
    
    self.numbers.text = [NSString stringWithFormat:@"第%@期",_datadic[@"indiana_number"]];
    self.timelb.text = [NSString stringWithFormat:@"开奖时间:%@",[formattime formateTimeYM:_datadic[@"indiana_endtime"]]];
    [self.iamgev sd_setImageWithURL:[NSURL URLWithString:_datadic[@"pic"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = [NSString stringWithFormat:@"%@",_datadic[@"nickname"]];
    self.contentlb.text = [NSString stringWithFormat:@"%@",_datadic[@"content"]];
    self.imagearr = _datadic[@"thumb"];
    [self.collectionv reloadData];
    
}

-(NSArray*)imagearr{
    if (!_imagearr) {
        _imagearr = [NSArray array];
    }
    return _imagearr;
}

@end
