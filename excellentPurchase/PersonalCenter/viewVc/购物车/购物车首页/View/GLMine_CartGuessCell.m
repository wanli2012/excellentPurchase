//
//  GLMine_CartGuessCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_CartGuessCell.h"

@implementation GLMine_CartGuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)collecteOrCancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(collecte:)]) {
        [self.delegate collecte:self.index];
    }
}

@end
