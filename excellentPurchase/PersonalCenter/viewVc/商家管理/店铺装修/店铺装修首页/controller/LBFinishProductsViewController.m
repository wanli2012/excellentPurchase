//
//  LBFinishProductsViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinishProductsViewController.h"
#import "LBFinishProductsCell1.h"
#import "GLFinishGoodsDetailModel.h"
#import "LBReplyProductListsViewController.h"

@interface LBFinishProductsViewController ()

@property (nonatomic, strong)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@end

static NSString *ID = @"finishProductsCell1";

@implementation LBFinishProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     [self.collectionView registerNib:[UINib nibWithNibName:@"LBFinishProductsCell1" bundle:nil] forCellWithReuseIdentifier:ID];
    [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
    [LBDefineRefrsh defineCollectionViewRefresh:self.collectionView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
}

//刷新
-(void)refreshReceivingAddress{
    [self postRequest:YES];
}

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
//    self.collectionView.tableFooterView = [UIView new];
    
    self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.collectionView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.collectionView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.collectionView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.collectionView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.collectionView.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"type"] = @(self.type);
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_goods_list paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionView];
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            
            if ([responseObject[@"data"][@"page_data"] count] != 0) {
                
                for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                    GLFinishGoodsDetailModel *model = [GLFinishGoodsDetailModel mj_objectWithKeyValues:dict];
                    
                    [self.models addObject:model];
                }
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionView];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.collectionView reloadData];
        
    }];
}

-(void)pushReplyProducts:(NSIndexPath*)indexpath{
    GLFinishGoodsDetailModel *model = self.models[indexpath.row];
    self.hidesBottomBarWhenPushed = YES;
    LBReplyProductListsViewController *vc = [[LBReplyProductListsViewController alloc]init];
    vc.good_id = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBFinishProductsCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    cell.indexpath = indexPath;
    if (self.type == 1) {
        cell.replyBt.hidden = NO;
    }else{
        cell.replyBt.hidden = YES;
    }
    cell.replyComment = ^(NSIndexPath *indexpath) {
        [self pushReplyProducts:indexpath];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 5)/2.0, (UIScreenWidth - 5)/2.0 + 85);
    
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
    
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}


@end
