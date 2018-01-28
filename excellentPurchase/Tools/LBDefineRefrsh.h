//
//  LBDefineRefrsh.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBDefineRefrsh : NSObject
//tableview的操作
+(void)defineRefresh:(UITableView*)tableview  headerrefresh:(void(^)(void))headerrefreshBlock footerRefresh:(void(^)(void))footerRefreshBlock;

+(void)defineRefresh:(UITableView*)tableview  headerrefresh:(void(^)(void))headerrefreshBlock ;

+(void)defineRefresh:(UITableView*)tableview   footerRefresh:(void(^)(void))footerRefreshBlock;

+(void)dismissRefresh:(UITableView*)tableview;

+(void)beginRefresh:(UITableView*)tableview;

//collectionview的操作
+(void)defineCollectionViewRefresh:(UICollectionView*)collectionView  headerrefresh:(void(^)(void))headerrefreshBlock footerRefresh:(void(^)(void))footerRefreshBlock;

+(void)defineCollectionViewRefresh:(UICollectionView*)collectionView  headerrefresh:(void(^)(void))headerrefreshBlock ;

+(void)defineCollectionViewRefresh:(UICollectionView*)collectionView   footerRefresh:(void(^)(void))footerRefreshBlock;

+(void)dismissCollectionViewRefresh:(UICollectionView*)collectionView;

+(void)beginCollectionViewRefresh:(UICollectionView*)collectionView;

@end
