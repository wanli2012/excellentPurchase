//
//  LBBaseFinishProductsViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBBaseFinishProductsViewController.h"

NSNotificationName const ChildScrollViewDidScrollNSNotificationFinancial2 = @"ChildScrollViewDidScrollNSNotificationFinancial2";
NSNotificationName const ChildScrollViewRefreshStateNSNotificationFinancial2 = @"ChildScrollViewRefreshStateNSNotificationFinancial2";


@interface LBBaseFinishProductsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation LBBaseFinishProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //adjustsScrollViewInsets_NO(self.collectionView, self);
    [self.view addSubview:self.collectionView];
    self.scrollView = self.collectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewDidScrollNSNotificationFinancial2 object:nil userInfo:@{@"scrollingScrollView":scrollView,@"offsetDifference":@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}

-(UICollectionView*)collectionView{
    if (!_collectionView) {
        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight- 55) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.contentInset = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        //4.设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


@end
