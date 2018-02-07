//
//  LBMineEvaluateViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineEvaluateViewController : UIViewController
//商品评论参数
@property (strong , nonatomic)NSString *order_goods_id;//订单商品ID
@property (strong , nonatomic)NSString *goods_id;//商品ID
@property (strong , nonatomic)NSString *goods_name;//商品名
@property (strong , nonatomic)NSString *goods_pic;//商品图片
//评论商家
@property (strong , nonatomic)NSString *line_id;//线下订单ID
@property (strong , nonatomic)NSString *line_store_uid;//商家uid

@property (assign , nonatomic)NSInteger replyType;//评论商品 1 商店为2

@property (copy , nonatomic)void (^replyFinish)(void);//评论成功

@end
