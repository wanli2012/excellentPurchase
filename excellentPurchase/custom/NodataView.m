//
//  NodataView.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "NodataView.h"

@interface NodataView()



@end

@implementation NodataView
//重新加载
- (IBAction)reconfigureNetworking:(UIButton *)sender {
    
    if (self.cancekBlock) {
        self.cancekBlock();
    }
    
}


@end
