//
//  LBHorseGroupTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHorseGroupTableViewCell.h"
#import "LBHorseRaceLampModel.h"

@interface LBHorseGroupTableViewCell ()

@property (nonatomic, copy)NSArray *dataSource;

@end

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
        WeakSelf;
        self.loopView = [XBTextLoopView textLoopViewWith:self.dataSource loopInterval:3.0 initWithFrame:CGRectMake(h , 0, w, h) selectBlock:^(NSString *selectString, NSInteger index) {
            
            if([weakSelf.delegate respondsToSelector:@selector(toDetail:infoIndex:)]){
                [weakSelf.delegate toDetail:self.index infoIndex:index];
            }
            
//            NSLog(@"%@===index%ld", selectString, (long)index);
        }];
    }
    
    [self addSubview:self.loopView];
    
}

- (void)setNewsModels:(NSArray<GLHome_newsModel *> *)newsModels{
    _newsModels = newsModels;

    NSMutableArray *arrM = [NSMutableArray array];
    for (GLHome_newsModel *model in newsModels) {
        LBHorseRaceLampModel *newModel = [[LBHorseRaceLampModel alloc] init];
        newModel.contentstr = model.content;
        newModel.content_id = model.news_id;
        [arrM addObject:newModel];
    }
    self.loopView.dataSource = arrM;
}


- (void)setOrderModels:(NSArray<GLHome_ordersModel *> *)orderModels{
    _orderModels = orderModels;
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLHome_ordersModel *model in orderModels) {
        
        LBHorseRaceLampModel *newModel = [[LBHorseRaceLampModel alloc] init];
        newModel.contentstr = model.content;
        [arrM addObject:newModel];
    }
    self.loopView.dataSource = arrM;
    
}

-(UIImageView*)imagev{
    
    if (!_imagev) {
        _imagev = [[UIImageView alloc]init];
        _imagev.backgroundColor = [UIColor redColor];
    }
    return _imagev;
}

@end
