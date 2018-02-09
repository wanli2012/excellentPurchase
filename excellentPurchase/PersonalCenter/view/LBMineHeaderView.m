//
//  LBMineHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineHeaderView.h"
#import "UIButton+SetEdgeInsets.h"
#import "TXScrollLabelView.h"
#import "UIImage+GIF.h"
#import "LBMineDataCollectionViewCell.h"

@interface LBMineHeaderView()<UICollectionViewDelegate,
UICollectionViewDataSource,UIScrollViewDelegate,TXScrollLabelViewDelegate>

/**
 切换按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changeBt;

@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (weak, nonatomic) IBOutlet UIView *topView;//个人信息 view

@property (strong, nonatomic)TXScrollLabelView *scrollLabelView;//跑马灯view

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

/**
 初始化 界面
 */
-(void)initInerface{
    
    [self.changeBt horizontalCenterTitleAndImage:3];
    [self.scrollLabelView removeFromSuperview];
//    [self.noticeView addSubview:self.scrollLabelView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMyInfomation)];
    [self.topView addGestureRecognizer:tap];
    

    
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
    
    [self addWith:TXScrollLabelViewTypeFlipNoRepeat velocity:2 isArray:YES];
    
}

- (void)addWith:(TXScrollLabelViewType)type velocity:(CGFloat)velocity isArray:(BOOL)isArray {
    /** Step1: 滚动文字 */
    
    NSArray *scrollTexts = @[@" "];
    
    /** Step2: 创建 ScrollLabelView */
    _scrollLabelView = nil;
    if (isArray) {
        _scrollLabelView = [TXScrollLabelView scrollWithTextArray:scrollTexts type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    }
    
    /** Step3: 设置代理进行回调 */
    _scrollLabelView.scrollLabelViewDelegate = self;
    _scrollLabelView.frame = CGRectMake(CGRectGetMaxX(self.alertImage.frame) + 10, 0, UIScreenWidth - 55, 35);
     [self.noticeView addSubview:self.scrollLabelView];
    /** Step4: 布局(Required) */
    
    //偏好(Optional), Preference,if you want.
    //    _scrollLabelView.tx_centerX  = [UIScreen mainScreen].bounds.size.width * 0.5;
    _scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
    _scrollLabelView.scrollSpace = 10;
    _scrollLabelView.font = [UIFont systemFontOfSize:14];
    _scrollLabelView.textAlignment = NSTextAlignmentLeft;
    _scrollLabelView.scrollTitleColor =LBHexadecimalColor(0x333333);
    _scrollLabelView.backgroundColor = [UIColor clearColor];
    _scrollLabelView.layer.cornerRadius = 5;
    
    /** Step5: 开始滚动(Start scrolling!) */
    [_scrollLabelView beginScrolling];
}
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{

}


- (void)setNoticeArr:(NSArray *)noticeArr{
    _noticeArr = noticeArr;
    
    _scrollLabelView.dataArr = _noticeArr;
    /** Step5: 开始滚动(Start scrolling!) */
    [_scrollLabelView beginScrolling];

}
- (void)setValueArr:(NSArray *)valueArr{
    _valueArr = valueArr;
    
    [self.colletionView reloadData];
}

/**
 切换帐号
 */
- (IBAction)changeAccountEvent:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeAccountEvent)]) {
        [self.delegate changeAccountEvent];
    }
    
}

/**
 跳转到我的个人信息
 */
- (void)toMyInfomation{
    if ([self.delegate respondsToSelector:@selector(toMyInfomation)]) {
        [self.delegate toMyInfomation];
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

@end
