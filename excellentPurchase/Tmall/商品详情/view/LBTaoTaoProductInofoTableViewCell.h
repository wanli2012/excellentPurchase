//
//  LBTaoTaoProductInofoTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTmallProductDetailModel.h"

@protocol  LBTaoTaoProductInofoDelegate <NSObject>

-(void)chooseSpecification;//选择规格

-(void)shareInfo;//分享

@end

@interface LBTaoTaoProductInofoTableViewCell : UITableViewCell

@property (nonatomic, assign)id<LBTaoTaoProductInofoDelegate> delegate;

@property (strong , nonatomic)LBTmallProductDetailModel *model;

@end
