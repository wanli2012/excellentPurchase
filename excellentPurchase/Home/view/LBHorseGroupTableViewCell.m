//
//  LBHorseGroupTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHorseGroupTableViewCell.h"

@implementation LBHorseGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initDataFace];
    }
    
    return self;
}

-(void)initDataFace{
    
    [self.loopView removeFromSuperview];
    [self.imagev removeFromSuperview];
    [self addSubview:self.imagev];
    
    __weak typeof(self) wself = self;
    [self.imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_equalTo(wself.imagev.mas_height).multipliedBy(1);//设置等比宽高
    }];
    
    if (!self.loopView) {
        CGFloat h = bannerHeiget;
        CGFloat w = UIScreenWidth - h;
        self.loopView = [XBTextLoopView textLoopViewWith:@[@"1",@"1",@"1",@"1"] loopInterval:3.0 initWithFrame:CGRectMake(h , 0, w, h) selectBlock:^(NSString *selectString, NSInteger index) {
            NSLog(@"%@===index%ld", selectString, (long)index);
        }];
    }

    [self addSubview:self.loopView];
    
}

-(UIImageView*)imagev{
    
    if (!_imagev) {
        _imagev = [[UIImageView alloc]init];
        _imagev.backgroundColor = [UIColor redColor];
    }
    return _imagev;
}

@end
