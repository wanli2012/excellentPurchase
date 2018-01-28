//
//  LBDefineRefrsh.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDefineRefrsh.h"

@implementation LBDefineRefrsh

+(void)defineRefresh:(UITableView*)tableview headerrefresh:(void (^)(void))headerrefreshBlock footerRefresh:(void (^)(void))footerRefreshBlock{

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
    

     tableview.mj_header = header;
    tableview.mj_footer = footer;
    
    
}

+(void)defineRefresh:(UITableView*)tableview footerRefresh:(void (^)(void))footerRefreshBlock{
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        footerRefreshBlock();
        
    }];
    
    tableview.mj_footer = footer;
    
}

+(void)defineRefresh:(UITableView*)tableview headerrefresh:(void (^)(void))headerrefreshBlock{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        headerrefreshBlock();
        
    }];
    

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
        tableview.mj_header = header;
 
    

}

+(void)dismissRefresh:(UITableView*)tableview{
    

       [tableview.mj_header endRefreshing];
       [tableview.mj_footer endRefreshing];
   
}

+(void)beginRefresh:(UITableView *)tableview{
    [tableview.mj_header beginRefreshing];
}


+(void)defineCollectionViewRefresh:(UICollectionView *)collectionView headerrefresh:(void (^)(void))headerrefreshBlock footerRefresh:(void (^)(void))footerRefreshBlock{
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
    
    
    collectionView.mj_header = header;
    collectionView.mj_footer = footer;
}

+(void)defineCollectionViewRefresh:(UICollectionView *)collectionView footerRefresh:(void (^)(void))footerRefreshBlock{

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        footerRefreshBlock();
        
    }];
    
    
    collectionView.mj_footer = footer;
}
+(void)defineCollectionViewRefresh:(UICollectionView *)collectionView headerrefresh:(void (^)(void))headerrefreshBlock{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        headerrefreshBlock();
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    collectionView.mj_header = header;

}
+(void)dismissCollectionViewRefresh:(UICollectionView *)collectionView{
    [collectionView.mj_header endRefreshing];
    [collectionView.mj_footer endRefreshing];
}
+(void)beginCollectionViewRefresh:(UICollectionView *)collectionView{
     [collectionView.mj_header beginRefreshing];
}

@end
