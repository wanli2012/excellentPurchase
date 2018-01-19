//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] init];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:14];
        self.name.textColor = YYSRGBColor(130, 130, 130, 1);
        self.name.highlightedTextColor = MAIN_COLOR;
        self.name.text = @"好玩的啊";
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];

        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.trailing.equalTo(self).offset(-5);
            make.leading.equalTo(self).offset(5);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
