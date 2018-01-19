//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.clipsToBounds = YES;
        self.imageV.image = [UIImage imageNamed:@"eat-picture1"];
        [self.contentView addSubview:self.imageV];

        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.width + 2, self.frame.size.width - 4, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.text = @"OK没你聪";
        [self.contentView addSubview:self.name];
    }
    return self;
}


@end
