//
//  LBMyActivityNumbersViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/21.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyActivityNumbersViewController.h"
#import "LBMyactivityTimeCollectionViewCell.h"
#import "LBMyactivityNumbersCollectionViewCell.h"
#import "LBMyActivityCollectionReusableView.h"
#import "LBMineCenterFlyNoticeDetailViewController.h"
#import "LBMyActivityNumbersViewAdressVc.h"

typedef NS_ENUM(NSInteger, collectionViewType) {
    LBMyActivityNumbersTypeDefault ,   // 默认参与时间
    LBMyActivityNumbersTypeOne,      // 我的号码
};

@interface LBMyActivityNumbersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (assign, nonatomic) collectionViewType showType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *tableFlowLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowyout;
@property (strong, nonatomic) NSArray *onceArr;
@property (strong, nonatomic) NSArray *numberArr;

@end

@implementation LBMyActivityNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的号码";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBMyactivityTimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBMyactivityTimeCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBMyactivityNumbersCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBMyactivityNumbersCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBMyActivityCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBMyActivityCollectionReusableView"];
    self.showType = LBMyActivityNumbersTypeOne;
    [self.collectionView setCollectionViewLayout:self.collectionFlowyout];
    
    [self requstNumbers];
    [self requstonce];
}

-(void)requstNumbers{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"indiana_id"] = _model.indiana_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kIndianalucky_number_detail paramDic:dic finish:^(id responseObject) {
       [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
           
            self.numberArr = responseObject[@"data"];

        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.collectionView reloadData];
    } enError:^(NSError *error) {
         [EasyShowLodingView hidenLoding];

    }];
}

-(void)requstonce{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"indiana_id"] = _model.indiana_id;
    
    [NetworkManager requestPOSTWithURLStr:kIndianabuy_detail paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.onceArr = responseObject[@"data"];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.collectionView reloadData];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        
    }];
}

#pragma UICollectionDelegate UICollectionDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.showType == LBMyActivityNumbersTypeDefault) {
        return self.onceArr.count;
    }else{
       return self.numberArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.showType == LBMyActivityNumbersTypeDefault) {
        
        LBMyactivityTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMyactivityTimeCollectionViewCell" forIndexPath:indexPath];
        
        cell.timelb.text = [formattime formateTime:self.onceArr[indexPath.item][@"indiana_order_paytime"]];
        cell.onecelb.text = [NSString stringWithFormat:@"%@人/次",self.onceArr[indexPath.item][@"indiana_order_person_count"]];
        
        return cell;
    }else{
        LBMyactivityNumbersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMyactivityNumbersCollectionViewCell" forIndexPath:indexPath];
        
        cell.numberlb.text = self.numberArr[indexPath.item];
        return cell;
    }
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(UIScreenWidth, 135);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *collectionReusableView = nil;
        if (indexPath.section == 0) {
            LBMyActivityCollectionReusableView  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:@"LBMyActivityCollectionReusableView"
                                                                                         forIndexPath:indexPath];
            WeakSelf;
            __weak typeof(headview) wheader = headview;
            headview.model = self.model;
            headview.changeCollectionType = ^{

             weakSelf.showType =  weakSelf.showType == LBMyActivityNumbersTypeDefault?LBMyActivityNumbersTypeOne:LBMyActivityNumbersTypeDefault;
            weakSelf.collectionView.collectionViewLayout = weakSelf.showType == LBMyActivityNumbersTypeDefault?weakSelf.tableFlowLayout:weakSelf.collectionFlowyout;
                wheader.timelb.text = weakSelf.showType == LBMyActivityNumbersTypeDefault?@"参与时间":@"我的号码";
                wheader.peoplelb.hidden = weakSelf.showType == LBMyActivityNumbersTypeDefault?NO:YES;
                
                [weakSelf.collectionView reloadData];
            };
            //查看物流
            headview.chechfly = ^{
                weakSelf.hidesBottomBarWhenPushed = YES;
                LBMineCenterFlyNoticeDetailViewController *vc = [[LBMineCenterFlyNoticeDetailViewController alloc]init];
                vc.codestr = weakSelf.model.indiana_wl_ord_number;
                vc.imageStr = weakSelf.model.indiana_goods_thumb;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
//            选择地址
            headview.chooseAdress = ^{
                weakSelf.hidesBottomBarWhenPushed = YES;
                LBMyActivityNumbersViewAdressVc *vc = [[LBMyActivityNumbersViewAdressVc alloc]init];
                vc.model = weakSelf.model;
                vc.popvc = ^{
                    weakSelf.model.indiana_address_id = @"1";//随便设的值，不为0就行
                    [weakSelf.collectionView reloadData];
                    if (weakSelf.popvc) {
                        weakSelf.popvc();
                    }
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            collectionReusableView = headview;
        }
        
        return collectionReusableView;
    }
    return nil;
}


-(UICollectionViewFlowLayout *)tableFlowLayout{
    
    if (_tableFlowLayout == nil) {
        
        _tableFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _tableFlowLayout.itemSize = CGSizeMake(UIScreenWidth, 40);
        
        _tableFlowLayout.minimumInteritemSpacing = 0;
        
        _tableFlowLayout.minimumLineSpacing = 0;
        
    }
    
    return _tableFlowLayout;
    
}

-(UICollectionViewFlowLayout *)collectionFlowyout{
    
    if (_collectionFlowyout == nil) {
        
        _collectionFlowyout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionFlowyout.itemSize = CGSizeMake((UIScreenWidth)/3.0, 30);
        
        _collectionFlowyout.minimumLineSpacing = 0;
        
        _collectionFlowyout.minimumInteritemSpacing = 0;
        
        [_collectionFlowyout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    
    return _collectionFlowyout;
    
}

-(NSArray*)numberArr{
    if (!_numberArr) {
        _numberArr = [NSArray array];
    }
    return _numberArr;
}
-(NSArray*)onceArr{
    if (!_onceArr) {
        _onceArr = [NSArray array];
    }
    return _onceArr;
}

@end
