//
//  GLIntegralHeaderTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralHeaderTableViewCell.h"


@interface GLIntegralHeaderTableViewCell  ()



@end

@implementation GLIntegralHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

 
    
}
//查看更多商品
- (IBAction)checkMoreProducts:(UIButton *)sender {
    WeakSelf;
    if (self.checkMoreProducts) {
        weakSelf.checkMoreProducts(weakSelf.section);
    }
    
}


@end
