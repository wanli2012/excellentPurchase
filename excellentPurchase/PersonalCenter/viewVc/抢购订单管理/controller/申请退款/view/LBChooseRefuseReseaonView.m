//
//  LBChooseRefuseReseaonView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBChooseRefuseReseaonView.h"
#import "LBChooseRefuseReseaonCell.h"

@interface LBChooseRefuseReseaonView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) CGRect  rectF;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *containView;
@property (nonatomic, strong)UIButton *closeBt;
@property (nonatomic, strong)UILabel *titilelabe;
@property (nonatomic, copy)void(^menuBlock)(NSString *selectstr,NSString *row);

@end

@implementation LBChooseRefuseReseaonView

+(instancetype)showMenu:(NSArray *)dataArr controlFrame:(CGRect)rect andReturnBlock:(void (^)(NSString *, NSString *))menuBlock{
    
    return [self setshowMenu:dataArr controlFrame:rect andReturnBlock:menuBlock];
}

+(instancetype)setshowMenu:(NSArray *)dataArr controlFrame:(CGRect)rect andReturnBlock:(void (^)(NSString *, NSString *))menuBlock{
    LBChooseRefuseReseaonView *view = [[LBChooseRefuseReseaonView alloc]init];
    view.dataArr = dataArr;
    view.rectF = rect;
    view.menuBlock = menuBlock;
    [view refreshData];
    [view showView:rect];
    return view;
    
}
/**
 初始化View
 */
- (instancetype)init {
    if (self = [super init]) {
        
        [self gl_setView];
        
    }
    return self;
}

- (void)gl_setView {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    
    
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_containView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    
    [_tableView registerNib:[UINib nibWithNibName:@"LBChooseRefuseReseaonCell" bundle:nil] forCellReuseIdentifier:@"LBChooseRefuseReseaonCell"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_containView addSubview:_tableView];
    
    
    [_containView addSubview:self.closeBt];
    [_containView addSubview:self.titilelabe];
    
    [self.closeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_containView).offset(0);
        make.leading.equalTo(_containView).offset(0);
        make.height.equalTo(@50);
        make.bottom.equalTo(_containView).offset(0);
    }];
    
    [self.titilelabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_containView).offset(0);
        make.leading.equalTo(_containView).offset(0);
        make.height.equalTo(@20);
        make.top.equalTo(_containView).offset(10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_containView).offset(0);
        make.leading.equalTo(_containView).offset(0);
        make.top.equalTo(self.titilelabe.mas_bottom).offset(15);
        make.bottom.equalTo(self.closeBt.mas_top).offset(0);
    }];
    
}
/**
 刷新数据源
 */
- (void)refreshData {
    
    [self.tableView reloadData];
}

/**
 展示
 */
- (void)showView:(CGRect)rect{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.containView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, rect.size.height);
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containView.frame = CGRectMake(0, UIScreenHeight - rect.size.height, UIScreenWidth, rect.size.height);
        self.backgroundColor = CZHRGBColor(0x000000, 0.3);
        
    }];
}

/**
 隐藏
 */
- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
         self.containView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, _rectF.size.height);
        self.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.containView removeFromSuperview];
        [self.tableView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBChooseRefuseReseaonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBChooseRefuseReseaonCell"];
    cell.selectionStyle = 0;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight = 40;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBChooseRefuseReseaonModel *model = self.dataArr[indexPath.row];
    for (int i = 0; i < self.dataArr.count; i++) {
         LBChooseRefuseReseaonModel *model1 = self.dataArr[i];
        if (i != indexPath.row) {
            model1.isselect = NO;
        }else{
            model1.isselect = YES;
        }
    }
    
    if (self.menuBlock) {
        self.menuBlock(model.content, [NSString stringWithFormat:@"%ld",indexPath.row]);
    }

    [self.tableView reloadData];
}

-(UIButton*)closeBt{
    if (!_closeBt) {
        _closeBt = [[UIButton alloc]init];
        _closeBt.backgroundColor =MAIN_COLOR;
        [_closeBt setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBt addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBt;
}

-(UILabel*)titilelabe{
    if (!_titilelabe) {
        _titilelabe = [[UILabel alloc]init];
        _titilelabe.text = @"选择退款原因";
        _titilelabe.textColor = LBHexadecimalColor(0x333333);
        _titilelabe.font = [UIFont systemFontOfSize:15];
        _titilelabe.textAlignment = NSTextAlignmentCenter;
    }
    return _titilelabe;
}

@end
