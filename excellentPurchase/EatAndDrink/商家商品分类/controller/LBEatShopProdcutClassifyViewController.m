//
//  LBEatShopProdcutClassifyViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEatShopProdcutClassifyViewController.h"
#import "LBShopProductClassifyReusableView.h"
#import "LBShopProductClassifyMenuReusableView.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"
#import "LJCollectionViewFlowLayout.h"
#import "LBStoreInfoModel.h"
#import "LBTmallhomepageDataModel.h"
#import "LBProductDetailViewController.h"

@interface LBEatShopProdcutClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, assign) NSInteger  money;//1价格升序 2价格降序
@property (nonatomic, assign) NSInteger  num;//1销量升序 2销量降序
@property (nonatomic, strong) LBStoreInfoModel *dataModel;//数据模型

@end

@implementation LBEatShopProdcutClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"店铺信息";
    self.page = 1;
    self.num = 0;
    self.money = 0;
    [self registerollectionCell];//注册cell
    
    [self setupNpdata];//设置无数据的时候展示
    
    [self setuprefrsh];//刷新
    [self craetDispathGroup];//创建网络队列
}

-(void)craetDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLoding];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //任务一
    dispatch_group_async(group, queue, ^{
        [weakSelf loadStoreInfo:^{ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
            //一个任务结束时标记一个信号量
            dispatch_semaphore_signal(semaphore);
        }];
    });
    //任务二
    dispatch_group_async(group, queue, ^{
        [weakSelf loadData:^{ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
            //一个任务结束时标记一个信号量
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        //2个任务,2个信号等待.
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{//返回主线程
            [EasyShowLodingView hidenLoding];
            [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionView];
            //这里就是所有异步任务请求结束后执行的代码
            [_collectionView reloadData];
            
        });
    });
    
}

-(void)loadStoreInfo:(void(^)(void))finish{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"store_id"] = self.store_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingSea_store paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataModel = [LBStoreInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        }else{
            
        }
        
        finish();
    } enError:^(NSError *error) {
        finish();
    }];
    
}

-(void)loadData:(void(^)(void))finish {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"money"] = @(self.money);
    dic[@"num"] = @(self.num);
    dic[@"page"] = @(self.page);
    dic[@"store_id"] = self.store_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingStore_goods paramDic:dic finish:^(id responseObject) {
       
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBTmallhomepageDataStructureModel *model = [LBTmallhomepageDataStructureModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        finish();
    } enError:^(NSError *error) {
        finish();
    }];
    
}

-(void)setupNpdata{
    WeakSelf;
    
    self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.collectionView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.collectionView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.collectionView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.collectionView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.collectionView.ly_emptyView setTapContentViewBlock:^{
        [weakSelf craetDispathGroup];
    }];
}

-(void)setuprefrsh{
    WeakSelf;
    [LBDefineRefrsh defineCollectionViewRefresh:_collectionView headerrefresh:^{
        weakSelf.page = 1;
         [weakSelf craetDispathGroup];
    } footerRefresh:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf loadData:^{
            [weakSelf.collectionView reloadData];
            [LBDefineRefrsh dismissCollectionViewRefresh:weakSelf.collectionView];
        }];
    }];
    
}

-(void)registerollectionCell{
    // 注册表头
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBShopProductClassifyReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBShopProductClassifyReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBShopProductClassifyMenuReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBShopProductClassifyMenuReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBIntegralGoodsTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBIntegralGoodsTwoCollectionViewCell"];
    
    LJCollectionViewFlowLayout *layout = [[LJCollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.dataModel) {
        return 2;
    }
    return 0;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return self.dataArr.count;
    }
    
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(UIScreenWidth,UIScreenWidth/2.0 + 70);
    }else {
        return CGSizeMake(UIScreenWidth,60);
    }
    return CGSizeMake(0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsTwoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBIntegralGoodsTwoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.model =self.dataArr[indexPath.row];
    if ([cell.model.salenum floatValue] >= 10000) {
        cell.scanNum.text = [NSString stringWithFormat:@"%1.f@万人付款",[cell.model.salenum floatValue]/10000.0];
    }else{
        cell.scanNum.text = [NSString stringWithFormat:@"%@人付款",cell.model.salenum];
    }
    cell.refrshDatasorece = ^{
        [_collectionView reloadData];
    };
    
    return cell;
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 5)/2.0, (UIScreenWidth - 5)/2.0 + 100);
    
}

//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
    vc.goods_id = ((LBTmallhomepageDataStructureModel*)self.dataArr[indexPath.row]).goods_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *collectionReusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            LBShopProductClassifyReusableView  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:@"LBShopProductClassifyReusableView"
                                                                                         forIndexPath:indexPath];
            headview.model = self.dataModel;
            
            collectionReusableView = headview;
        }else{
            
            LBShopProductClassifyMenuReusableView  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                              withReuseIdentifier:@"LBShopProductClassifyMenuReusableView"
                                                                                                     forIndexPath:indexPath];
            WeakSelf;
            headview.refreshdata = ^(NSInteger index, NSInteger status) {
                switch (index) {
                    case 1:
                    {
                        weakSelf.money = 0;
                        weakSelf.num = 0;
                    }
                        break;
                    case 2:
                    {
                        weakSelf.money = 0;
                        weakSelf.num = status;
                    }
                        break;
                    case 3:
                    {
                        weakSelf.money = status;
                        weakSelf.num = 0;
                    }
                        break;
                        
                    default:
                        break;
                }
                weakSelf.page = 1;
                [EasyShowLodingView showLoding];
                [weakSelf loadData:^{
                     [weakSelf.collectionView reloadData];
                    [EasyShowLodingView hidenLoding];
                }];
            };
            
            collectionReusableView = headview;
        }
    }
    return collectionReusableView;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
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
- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
}
-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
