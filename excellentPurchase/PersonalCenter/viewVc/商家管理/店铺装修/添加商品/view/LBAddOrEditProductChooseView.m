//
//  LBAddOrEditProductChooseView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddOrEditProductChooseView.h"
#import "LJCollectionViewFlowLayout.h"
#import "LeftTableViewCell.h"
#import "LBAddOrEditProductChoosecell.h"
#import "CollectionViewHeaderView.h"

static float kLeftTableViewWidth = 80.f;
static float kCollectionViewMargin = 3.f;
static float kCollectionHeaderViewH = 45.f;

@interface LBAddOrEditProductChooseView()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (strong , nonatomic)UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy)NSArray *cateModels;

///选择回调
@property (nonatomic, copy) void (^bankBlock)(NSInteger section,NSInteger row);
///取消
@property (nonatomic, copy) void (^cancelBlock)(void);

@end

@implementation LBAddOrEditProductChooseView

//+(instancetype)showWholeClassifyViewBlock:(void (^)(NSInteger,NSInteger))bankBlock cancelBlock:(void (^)(void))cancelBlock{
//    return [self addWholeClassifyBlock:bankBlock cancelBlock:cancelBlock];
//}
+(instancetype)showWholeClassifyViewWith:(NSArray *)cateModels Block:(void (^)(NSInteger, NSInteger))bankBlock cancelBlock:(void (^)(void))cancelBlock{
     return [self addWholeClassifyWith:cateModels Block:bankBlock cancelBlock:cancelBlock];
}

+(instancetype)addWholeClassifyWith:(NSArray *)cateModels Block:(void (^)(NSInteger, NSInteger))bankBlock cancelBlock:(void (^)(void))cancelBlock{
    LBAddOrEditProductChooseView *view = [[LBAddOrEditProductChooseView alloc]init];
    
    view.bankBlock = bankBlock;
    view.cancelBlock = cancelBlock;
    view.cateModels = cateModels;
    
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
    
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.collectionView];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cateModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    cell.model = self.cateModels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    
    // http://stackoverflow.com/questions/22100227/scroll-uicollectionview-to-section-header-view
    // 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
    [self scrollToTopOfSection:_selectIndex animated:YES];
    
    //    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.cateModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LBEatClassifyModel *model = self.cateModels[section];
    return model.two_cate.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBAddOrEditProductChoosecell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBAddOrEditProductChoosecell" forIndexPath:indexPath];
    
    LBEatClassifyModel *model = self.cateModels[indexPath.section];
    LBEatTwoClassifyModel *two_model = model.two_cate[indexPath.row];
    cell.model = two_model;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((UIScreenWidth - kLeftTableViewWidth - 4 * kCollectionViewMargin) / 3,
                       60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        LBEatClassifyModel *model = self.cateModels[indexPath.section];
        view.title.text = model.catename;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(UIScreenWidth, 30);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section ];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self hideView];
    self.bankBlock(indexPath.section,indexPath.row);
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
    
    [self.collectionView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        self.containerView.y = UIScreenHeight * 1/3.0;
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
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, UIScreenHeight * 2/3.0)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kCollectionHeaderViewH, kLeftTableViewWidth, UIScreenHeight * 2/3.0 - kCollectionHeaderViewH - 2 * kCollectionViewMargin)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _tableView;
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
