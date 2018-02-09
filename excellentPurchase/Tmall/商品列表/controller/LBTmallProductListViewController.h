//
//  LBTmallProductListViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTmallProductListViewController : UIViewController
@property (assign , nonatomic)NSInteger jumpType;//1 为首页跳转过来
//淘淘商城跳转过来
@property (strong , nonatomic)NSString *cate_id;
@property (strong , nonatomic)NSString *catename;
@property (assign , nonatomic)NSInteger goods_type;//1每日推荐 2精品优选
//首页跳转过来



@end
