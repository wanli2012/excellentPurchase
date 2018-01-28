//
//  LBDefineRefrsh.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBDefineRefrsh : NSObject

+(void)defineRefresh:(id)tableview  headerrefresh:(void(^)(void))headerrefreshBlock footerRefresh:(void(^)(void))footerRefreshBlock;

+(void)defineRefresh:(id)tableview  headerrefresh:(void(^)(void))headerrefreshBlock ;

+(void)defineRefresh:(id)tableview   footerRefresh:(void(^)(void))footerRefreshBlock;

+(void)dismissRefresh:(id)tableview;

@end
