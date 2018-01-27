//
//  DropMenu.m
//  dropMenu
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "DropMenu.h"
#import "GLDropCell.h"



#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define CZHRGBColor(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface DropMenu ()<UITableViewDataSource,UITableViewDelegate>

///容器view
@property (nonatomic, weak) UIView *containView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign)CGRect rect;

@property (nonatomic, assign)CGFloat menuHeight;

@property (nonatomic, copy)NSArray *dataArr;

///回调
@property (nonatomic, copy) void(^menuBlock)(NSString *selectName,NSString *type_id);

@end

@implementation DropMenu

+ (instancetype)showMenu:(NSArray *)titlesArr controlFrame:(CGRect)rect MenuHeight:(CGFloat)menuHeight andReturnBlock:(void(^)(NSString *selectName,NSString *type_id))menuBlock{
    
    return [DropMenu setShowPosition:titlesArr controlFrame:rect MenuHeight:menuHeight andReturnBlock:menuBlock];
}

+(instancetype)setShowPosition:(NSArray *)titlesArr controlFrame:(CGRect)rect MenuHeight:(CGFloat)menuHeight andReturnBlock:(void(^)(NSString *selectName,NSString *type_id))menuBlock{
    
    DropMenu *_memu = [[DropMenu alloc] init];
    
    _memu.rect = rect;
    _memu.menuBlock = menuBlock;
    _memu.menuHeight = menuHeight;
    _memu.dataArr = titlesArr;
    
    [_memu updateConstraints];
    [_memu refreshData];
    [_memu showView:rect];
    return _memu;
}

/**
 更新约束
 */
- (void)updateConstraints{
    [super updateConstraints];
    
    self.containView.frame = CGRectMake(self.rect.origin.x, CGRectGetMaxY(self.rect), self.rect.size.width, 0);
    self.tableView.frame = CGRectMake(0, 0, self.containView.width, self.containView.height);
    
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
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = CZHRGBColor(0x000000, 0);
        
        if (self.menuHeight > 200) {
            self.menuHeight = 200;
        }
        
        self.containView.height = self.menuHeight;
        self.tableView.height = self.containView.height;
        
//        NSLog(@"%@-------rect = %@",NSStringFromCGRect(self.containView.frame),NSStringFromCGRect(self.containView.frame));
        
    }];
}

/**
 隐藏
 */
- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.tableView.height = 0;
        self.containView.height = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
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
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(hideView)];
//    [self addGestureRecognizer:tap];
    
    UIView *containView = [[UIView alloc] init];
    containView.layer.cornerRadius = 5.f;
    containView.clipsToBounds = YES;
    
    [self addSubview:containView];
    self.containView = containView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    
    [tableView registerNib:[UINib nibWithNibName:@"GLDropCell" bundle:nil] forCellReuseIdentifier:@"GLDropCell"];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.containView addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLDropCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLDropCell"];
    DropMenuModel *model = self.dataArr[indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     DropMenuModel *model = self.dataArr[indexPath.row];
    
    if (self.menuBlock) {
        
        self.menuBlock(model.name,model.type_id);
    }
    
    [self hideView];
}

@end
