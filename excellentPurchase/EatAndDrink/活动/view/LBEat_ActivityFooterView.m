//
//  LBEat_ActivityFooterView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_ActivityFooterView.h"
#import "LBEat_Activity_TgasTableViewCell.h"

@interface LBEat_ActivityFooterView()<UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic)UITableView *tableivew;

@property (strong , nonatomic)UIView *lineView;

@end

static NSString *eat_Activity_TgasTableViewCell = @"LBEat_Activity_TgasTableViewCell";

@implementation LBEat_ActivityFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterface];//初始化
    }
    return self;
}

-(void)initInterface{
    
    [self.tableivew registerNib:[UINib nibWithNibName:eat_Activity_TgasTableViewCell bundle:nil] forCellReuseIdentifier:eat_Activity_TgasTableViewCell];
    
    [self addSubview:self.tableivew];
    [self addSubview:self.lineView];
    
    CGFloat  x = EatCellH - 10;//距离左边距
    [self.tableivew mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(x);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@1);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        LBEat_Activity_TgasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_Activity_TgasTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

-(UITableView*)tableivew{
    if (!_tableivew) {
        _tableivew = [[UITableView alloc]init];
        _tableivew.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableivew.tableFooterView = [UIView new];
        _tableivew.dataSource = self;
        _tableivew.delegate = self;
        _tableivew.backgroundColor = [UIColor whiteColor];
        _tableivew.scrollEnabled = NO;
    }
    return _tableivew;
}

-(UIView*)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _lineView;
}

@end
