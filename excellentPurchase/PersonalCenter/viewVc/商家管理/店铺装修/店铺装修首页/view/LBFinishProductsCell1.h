//
//  LBFinishProductsCell1.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLFinishGoodsDetailModel.h"

@interface LBFinishProductsCell1 : UICollectionViewCell

@property (nonatomic, strong)GLFinishGoodsDetailModel *model;

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (copy , nonatomic)void(^replyComment)(NSIndexPath *indexpath);

@property (weak, nonatomic) IBOutlet UIButton *replyBt;


@end
