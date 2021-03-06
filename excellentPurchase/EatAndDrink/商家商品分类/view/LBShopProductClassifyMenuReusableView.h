//
//  LBShopProductClassifyMenuReusableView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBShopProductClassifyMenuReusableView : UICollectionReusableView

/**
 index ：1，表示全部 2，表示销量 3，价格
 status：1升序 2，降序
 */
@property (copy , nonatomic)void(^refreshdata)(NSInteger index,NSInteger status);

@end
