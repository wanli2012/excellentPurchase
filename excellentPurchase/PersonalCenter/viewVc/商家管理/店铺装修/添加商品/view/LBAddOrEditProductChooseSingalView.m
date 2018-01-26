//
//  LBAddOrEditProductChooseSingalView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddOrEditProductChooseSingalView.h"
#import "LJCollectionViewFlowLayout.h"
#import "LeftTableViewCell.h"
#import "LBAddOrEditProductChoosecell.h"
#import "CollectionViewHeaderView.h"

static float kLeftTableViewWidth = 0.f;
static float kCollectionViewMargin = 3.f;
static float kCollectionHeaderViewH = 45.f;

@interface LBAddOrEditProductChooseSingalView()<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (strong , nonatomic)UIView *containerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

///选择回调
@property (nonatomic, copy) void (^bankBlock)(NSInteger section);

@end

@implementation LBAddOrEditProductChooseSingalView

+(instancetype)showWholeClassifyViewBlock:(void (^)(NSInteger ))bankBlock{
    return [self addWholeClassifyBlock:bankBlock];
}

+(instancetype)addWholeClassifyBlock:(void (^)(NSInteger ))bankBlock{
    LBAddOrEditProductChooseSingalView *view = [[LBAddOrEditProductChooseSingalView alloc]init];
    view.bankBlock = bankBlock;
    [view showView];//展示视图
    
    return view;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addInterface];//添加界面
    }
    return self;
}

-(void)addInterface{
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight );
    [self addSubview:self.containerView];
    
    UIView  *headView =[[NSBundle mainBundle]loadNibNamed:@"LBEat_WhloeClassifyHeaderView" owner:nil options:nil].firstObject;
    headView.frame = CGRectMake(0, 0, UIScreenWidth, kCollectionHeaderViewH);
    headView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:headView];
    
    UIButton *cancelBt =[headView viewWithTag:10];
    [cancelBt addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    
    _selectIndex = 0;
    _isScrollDown = YES;

    [self.containerView addSubview:self.collectionView];
    
    
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBAddOrEditProductChoosecell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBAddOrEditProductChoosecell" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((UIScreenWidth - kLeftTableViewWidth - 4 * kCollectionViewMargin) / 4.0,
                      60);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self hideView];
    self.bankBlock(indexPath.section);
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        self.containerView.y = UIScreenHeight * 1/3.0;
    }];
}
- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containerView.y = UIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(UIView*)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, UIScreenHeight * 2/3.0)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCollectionViewMargin + kLeftTableViewWidth, kCollectionViewMargin+kCollectionHeaderViewH, UIScreenWidth - kLeftTableViewWidth - 2 * kCollectionViewMargin, UIScreenHeight * 2/3.0 - kCollectionHeaderViewH - 2 * kCollectionViewMargin) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"LBAddOrEditProductChoosecell" bundle:nil] forCellWithReuseIdentifier:@"LBAddOrEditProductChoosecell"];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}
@end
