//
//  LBTimeLimitHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTimeLimitHeaderView.h"
#import "LBTimeLimitView.h"

@implementation LBTimeLimitHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self initsubsview];//_init表示初始化方法
    }
    
    return self;
}

-(void)initsubsview{
 
    LBTimeLimitView *view = [[NSBundle mainBundle]loadNibNamed:@"LBTimeLimitHeaderView" owner:nil options:nil].firstObject;
    view.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
}

@end
