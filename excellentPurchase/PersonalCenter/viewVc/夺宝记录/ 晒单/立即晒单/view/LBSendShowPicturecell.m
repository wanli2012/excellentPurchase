//
//  LBSendShowPicturecell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendShowPicturecell.h"
#import "LBSendShowPictureCollectionCell.h"

#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIImage+ZLPhotoLib.h"

@interface LBSendShowPicturecell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic)NSMutableArray *imagearr;

@end

static NSString *ID = @"LBSendShowPictureCollectionCell";

@implementation LBSendShowPicturecell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.collectionview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
}

-(void)setImagearrdata:(NSArray *)imagearrdata{
    _imagearrdata = imagearrdata;
    [self.imagearr removeAllObjects];
    [self.imagearr addObjectsFromArray:_imagearrdata];
    [self.imagearr addObject:@"addphotograph"];
    [self.collectionview reloadData];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imagearr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBSendShowPictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.indexpath = indexPath;
    if (self.imagearr.count == indexPath.row + 1) {
        cell.imagev.image = [UIImage imageNamed:self.imagearr[indexPath.row]];
        cell.deletebt.hidden = YES;
    }else{
        cell.deletebt.hidden = NO;
        
        if ([self.imagearr objectAtIndex:indexPath.row] != nil && [[self.imagearr objectAtIndex:indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *assets = [self.imagearr objectAtIndex:indexPath.row];
            
            cell.imagev.image = [assets thumbImage];
            
        }else if([[self.imagearr objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
            
            cell.imagev.image = [self.imagearr objectAtIndex:indexPath.row];
        }
        
    }
    WeakSelf;
    cell.deletepic = ^(NSIndexPath *indexpath) {
        [weakSelf.delegete delegetepicture:indexpath.row];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.imagearr.count == indexPath.row + 1) {
        [self.delegete choosepicture];
    }else{
        [self.delegete bigpicture:indexPath.row];
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(UIScreenWidth/3.0, UIScreenWidth/3.0);
    
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
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSMutableArray*)imagearr{
    if (!_imagearr) {
        _imagearr = [NSMutableArray arrayWithObjects:@"addphotograph", nil];
    }
    return _imagearr;
}

@end
