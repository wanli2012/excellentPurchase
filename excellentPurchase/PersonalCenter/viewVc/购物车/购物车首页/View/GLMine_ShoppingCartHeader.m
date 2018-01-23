//
//  GLMine_ShoppingCartHeader.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartHeader.h"

@interface GLMine_ShoppingCartHeader()

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, assign)NSInteger section;


@end

@implementation GLMine_ShoppingCartHeader

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_ShoppingCartHeader" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToStore)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectStoreGoods)];
        [self.selectView addGestureRecognizer:tap1];
        
        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

/**
 进店铺
 */
- (void)goToStore{
    
    if ([self.delegate respondsToSelector:@selector(goToStore:)]) {
        [self.delegate goToStore:self.section];
    }
}

/**
 全选该商店的商品
 */
- (void)selectStoreGoods{
    if ([self.delegate respondsToSelector:@selector(selectStoreGoods:)]) {
        [self.delegate selectStoreGoods:self.section];
    }
}

- (void)setModel:(GLMine_ShoppingCartDataModel *)model{
    
    if (model.shopIsSelected) {
        self.signImageV.image = [UIImage imageNamed:@"pay-select-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
    }
    
    self.section = model.shopSection;
    
}

@end
