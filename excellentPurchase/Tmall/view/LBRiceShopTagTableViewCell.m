//
//  LBRiceShopTagTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRiceShopTagTableViewCell.h"

@implementation LBRiceShopTagTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dwqTagV = [[LBRiceShopTagView alloc] initWithFrame:CGRectMake(10, 15, UIScreenWidth - 20, 0)];
        self.dwqTagV.selecindex = 0;
        [self addSubview:self.dwqTagV];
    }
    return self;
}

-(void)setHotSearchArr:(NSArray *)hotSearchArr
{
    _hotSearchArr = hotSearchArr;
    
    /** 注意cell的subView的重复创建！（内部已经做了处理了......） */
    [self.dwqTagV setTagWithTagArray:hotSearchArr];
    
}

@end
