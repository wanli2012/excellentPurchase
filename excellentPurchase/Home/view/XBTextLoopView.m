//
//  XBTextLoopView.m
//  文字轮播
//
//  Created by 周旭斌 on 2017/4/9.
//  Copyright © 2017年 周旭斌. All rights reserved.
//

#import "XBTextLoopView.h"
#import <Masonry/Masonry.h>
#import "LBHorseRaceLampCell.h"
#import "LBHorseRaceLampModel.h"

@interface XBTextLoopView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) NSInteger currentRowIndex;
@property (nonatomic, copy) selectTextBlock selectBlock;

@end

@implementation XBTextLoopView

#pragma mark - 初始化方法
+ (instancetype)textLoopViewWith:(NSArray *)dataSource loopInterval:(NSTimeInterval)timeInterval initWithFrame:(CGRect)frame selectBlock:(selectTextBlock)selectBlock {
    XBTextLoopView *loopView = [[XBTextLoopView alloc] initWithFrame:frame];
    loopView.dataSource = dataSource;
    loopView.selectBlock = selectBlock;
    loopView.interval = timeInterval ? timeInterval : 1.0;
    return loopView;
}
- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return bannerHeiget;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBHorseRaceLampCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBHorseRaceLampCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LBHorseRaceLampModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectBlock) {
        self.selectBlock(_dataSource[indexPath.row], indexPath.row);
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 以无动画的形式跳到第1组的第0行
    if (_currentRowIndex == _dataSource.count) {
        _currentRowIndex = 0;
        [_tableView setContentOffset:CGPointZero];
    }
}

#pragma mark - priviate method
- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    
    // 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timer) userInfo:nil repeats:YES];
    _myTimer = timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        // tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, frame.size.height)];
        _tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = frame.size.height;
        tableView.scrollEnabled =NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"LBHorseRaceLampCell" bundle:nil] forCellReuseIdentifier:@"LBHorseRaceLampCell"];
        [self addSubview:tableView];
    }
    
    return self;
}

- (void)timer {
    self.currentRowIndex++;
    [self.tableView setContentOffset:CGPointMake(0, _currentRowIndex * _tableView.rowHeight) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
