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

#import "GLAddOrEditProductChooseSingalCell.h"

static float kLeftTableViewWidth = 0.f;
static float kCollectionViewMargin = 3.f;
static float kCollectionHeaderViewH = 45.f;
static float kbottomViewH = 50.f;

#define kContainerViewW (UIScreenWidth - 40)
#define kContainerViewH UIScreenHeight / 2

@interface LBAddOrEditProductChooseSingalView()<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (strong , nonatomic)UIView *containerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UIView *headView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, copy)NSArray *titlesArr;
@property (nonatomic, assign)NSInteger type;//1:单选  2:复选

///选择回调
@property (nonatomic, copy) void (^bankBlock)(NSInteger section);
///取消
@property (nonatomic, copy) void (^cancelBlock)(void);

@end

@implementation LBAddOrEditProductChooseSingalView

+(instancetype)showWholeClassifyViewWith:(NSArray *)titlesArr type:(NSInteger)type Block:(void (^)(NSInteger ))bankBlock cancelBlock:(void (^)(void))cancelBlock{
    return [self addWholeClassifyWith:titlesArr type:type Block:bankBlock cancelBlock:cancelBlock];
}

+(instancetype)addWholeClassifyWith:(NSArray *)titlesArr type:(NSInteger)type Block:(void (^)(NSInteger ))bankBlock cancelBlock:(void (^)(void))cancelBlock{
    LBAddOrEditProductChooseSingalView *view = [[LBAddOrEditProductChooseSingalView alloc]init];
    view.bankBlock = bankBlock;
    view.cancelBlock = cancelBlock;
    view.titlesArr = titlesArr;
    view.type = type;
    
    [view refreshUI];
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
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [self addSubview:self.containerView];
    
//    UIView  *headView =[[NSBundle mainBundle]loadNibNamed:@"LBEat_WhloeClassifyHeaderView" owner:nil options:nil].firstObject;
//    headView.frame = CGRectMake(0, 0, kContainerViewW, kCollectionHeaderViewH);
//    headView.backgroundColor = [UIColor whiteColor];
    
    [self.containerView addSubview:self.headView];
    [self.containerView addSubview:self.bottomView];
    
    
//    UIButton *cancelBt =[headView viewWithTag:10];
//    [cancelBt addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    _selectIndex = 0;
    _isScrollDown = YES;

    [self.containerView addSubview:self.collectionView];
    
}
//刷新UI
- (void)refreshUI{
    
    [self.collectionView reloadData];
}

- (void)ensureChoose{
    NSLog(@"确定");
    [self hideView];
    
}

- (void)cancelChoose{
    NSLog(@"取消");
    [self hideView];
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.titlesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GLAddOrEditProductChooseSingalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLAddOrEditProductChooseSingalCell" forIndexPath:indexPath];
    
    if (self.type == 1) {
        
        cell.brandModel = self.titlesArr[indexPath.row];
    }else if (self.type == 2){
        
        cell.labeModel = self.titlesArr[indexPath.row];
    }else if(self.type == 3){
        
        cell.attrModel = self.titlesArr[indexPath.row];
    }
    
//    cell.titleLabel.text = self.titlesArr[indexPath.row];
    
//    cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    cell.contentView.layer.cornerRadius = 5.f;
//    cell.contentView.clipsToBounds = YES;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kContainerViewW - 30)/3,30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        [self hideView];
    }else{
        
    }
    
    if (self.bankBlock) {
        self.bankBlock(indexPath.row);
    }
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
        self.containerView.y = UIScreenHeight * 1/4.0;
    }];
}

- (void)hideView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containerView.y = UIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(UIView*)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(20, UIScreenHeight, kContainerViewW, kContainerViewH)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5.f;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContainerViewW, kCollectionHeaderViewH)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kContainerViewW, kCollectionHeaderViewH)];
        titleL.textColor = [UIColor blackColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont systemFontOfSize:14];
        titleL.text = @"属性选择";
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCollectionHeaderViewH-1, kContainerViewW, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_headView addSubview:titleL];
        [_headView addSubview:line];
    }
    return _headView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kContainerViewH - kbottomViewH, kContainerViewW, kbottomViewH)];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContainerViewW, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kContainerViewW/2, 0, 1, kbottomViewH)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIButton *ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContainerViewW/2 - 1, kbottomViewH)];
        [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [ensureBtn addTarget:self action:@selector(ensureChoose) forControlEvents:UIControlEventTouchUpInside];
        [ensureBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        ensureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kContainerViewW/2 + 1, 0, kContainerViewW/2 - 1, kbottomViewH)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        [_bottomView addSubview:ensureBtn];
        [_bottomView addSubview:cancelBtn];
        [_bottomView addSubview:line];
        [_bottomView addSubview:line2];
        
    }
    return _bottomView;
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
        CGFloat x = 0;
        CGFloat y = kCollectionHeaderViewH;
        CGFloat width = kContainerViewW;
        CGFloat height = kContainerViewH - kCollectionHeaderViewH - kbottomViewH;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(x,y,width,height) collectionViewLayout:self.flowLayout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"GLAddOrEditProductChooseSingalCell" bundle:nil] forCellWithReuseIdentifier:@"GLAddOrEditProductChooseSingalCell"];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}
@end
