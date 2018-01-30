//
//  LBEatClassifyModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBEatTwoClassifyModel;

@interface LBEatClassifyModel : NSObject

@property (copy , nonatomic)NSString *cate_id;//分类id
@property (copy , nonatomic)NSString *catename;//分类名
@property (copy , nonatomic)NSArray<LBEatTwoClassifyModel *> *two_cate;//分类名

@end

@interface LBEatTwoClassifyModel : NSObject

@property (copy , nonatomic)NSString *cate_id;//分类id
@property (copy , nonatomic)NSString *catename;//分类名
@property (copy , nonatomic)NSString *cate_img;//分类图片

@end
