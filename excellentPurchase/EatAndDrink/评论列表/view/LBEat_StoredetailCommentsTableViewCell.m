//
//  LBEat_StoredetailCommentsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoredetailCommentsTableViewCell.h"

@interface LBEat_StoredetailCommentsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *contentlb;

@end

@implementation LBEat_StoredetailCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentlb.text = @" hefciejc年轻的小蜗牛吃番茄哦 i 除非你陪请我吃饭我全程服务";
}


@end
