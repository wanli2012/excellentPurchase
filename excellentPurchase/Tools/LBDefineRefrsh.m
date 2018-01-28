//
//  LBDefineRefrsh.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDefineRefrsh.h"

@implementation LBDefineRefrsh

+(void)defineRefresh:(id)tableview headerrefresh:(void (^)(void))headerrefreshBlock footerRefresh:(void (^)(void))footerRefreshBlock{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        headerrefreshBlock();
    
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        footerRefreshBlock();
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    if ([tableview isEqual:[UITableView class]]) {
        ((UITableView*)tableview).mj_header = header;
        ((UITableView*)tableview).mj_footer = footer;
    }else if ([tableview isEqual:[UICollectionView class]]){
        ((UICollectionView*)tableview).mj_header = header;
        ((UICollectionView*)tableview).mj_footer = footer;
    }
    
}

+(void)defineRefresh:(id)tableview footerRefresh:(void (^)(void))footerRefreshBlock{
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        footerRefreshBlock();
        
    }];
    
    if ([tableview isEqual:[UITableView class]]) {
   
        ((UITableView*)tableview).mj_footer = footer;
    }else if ([tableview isEqual:[UICollectionView class]]){
  
        ((UICollectionView*)tableview).mj_footer = footer;
    }
}

+(void)defineRefresh:(id)tableview headerrefresh:(void (^)(void))headerrefreshBlock{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        headerrefreshBlock();
        
    }];
    

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    if ([tableview isEqual:[UITableView class]]) {
        ((UITableView*)tableview).mj_header = header;
 
    }else if ([tableview isEqual:[UICollectionView class]]){
        ((UICollectionView*)tableview).mj_header = header;

    }

}

+(void)dismissRefresh:(id)tableview{
    
    if ([tableview isEqual:[UITableView class]]) {
        [((UITableView*)tableview).mj_header endRefreshing];
        [((UITableView*)tableview).mj_footer endRefreshing];
    }else if ([tableview isEqual:[UICollectionView class]]){
        [((UICollectionView*)tableview).mj_header endRefreshing];
        [((UICollectionView*)tableview).mj_footer endRefreshing];
    }
}

@end
