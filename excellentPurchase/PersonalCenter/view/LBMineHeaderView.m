//
//  LBMineHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineHeaderView.h"
#import "UIButton+SetEdgeInsets.h"
#import "CCPScrollView.h"
#import "UIImage+GIF.h"
#import "LBMineDataCollectionViewCell.h"

@interface LBMineHeaderView()<UICollectionViewDelegate,
UICollectionViewDataSource,UIScrollViewDelegate>

/**
 切换按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changeBt;

@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (strong, nonatomic)CCPScrollView *ccpView;//跑马灯view

@property (weak, nonatomic) IBOutlet UIImageView *alertImage;

@property (weak, nonatomic)IBOutlet UICollectionView *colletionView;

@end

static NSString *ID = @"LBMineDataCollectionViewCell";

#define  DATACONTENT   (UIScreenWidth - 50)

@implementation LBMineHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
     [self.colletionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self initInerface];//初始化
    
}

-(void)initInerface{
    
    [self.changeBt horizontalCenterTitleAndImage:3];
    [self.ccpView removeFromSuperview];
    [self.noticeView addSubview:self.ccpView];
    
    _ccpView.titleArray = [NSArray arrayWithObjects:@"iPhone6s上线32G内存手机你怎么看？",@"亲爱的朋友们2016年还有100天就要过去了,2017年您准备好了吗?",@"今年双11您预算了几个月的工资？",@"高德与百度互掐，你更看好哪方？", nil];
    
    _ccpView.titleFont = 14;
    
    _ccpView.titleColor = [UIColor blackColor];
    
    _ccpView.BGColor = [UIColor whiteColor];
    
    
    [_ccpView clickTitleLabel:^(NSInteger index,NSString *titleString) {
        
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *path = [[NSBundle mainBundle] pathForResource:@"消息提醒" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            self.alertImage.image = image;
        });
        
    });
    
}

/**
 切换帐号
 */
- (IBAction)changeAccountEvent:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeAccountEvent)]) {
        [self.delegate changeAccountEvent];
    }
    
}

#pragma mark - UICollectionViewDelegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // must be dequeueReusableCellWithReuseIdentifier !!!!
    LBMineDataCollectionViewCell *cell = (LBMineDataCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID
                                                                            forIndexPath:indexPath];
    cell.titleNameLabel.text = self.titleArr[indexPath.row];
    cell.valueLabel.text = self.valueArr[indexPath.row];
 
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(DATACONTENT/3.0, 70);

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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(toMyProperty)]) {
        [self.delegate toMyProperty];
    }
}
//#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    

}

-(CCPScrollView*)ccpView{
    
    if (!_ccpView) {
        _ccpView = [[CCPScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.alertImage.frame) + 10, 0, UIScreenWidth - 55, 35)];
    
    }
    
    return _ccpView;
}

@end
