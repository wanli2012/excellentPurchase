//
//  LBEat_StoreCommentFooterView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentFooterView.h"

@interface LBEat_StoreCommentFooterView()

@property (strong , nonatomic)UIImageView *headimage;//头像

@property (strong , nonatomic)UIView *lineview;//回复按钮

@end

@implementation LBEat_StoreCommentFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    [self addSubview:self.lineview];
    
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(60);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@1);
        
    }];
}

-(UIView*)lineview{
    if (!_lineview) {
        _lineview = [[UIImageView alloc]init];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return _lineview;
}
@end
