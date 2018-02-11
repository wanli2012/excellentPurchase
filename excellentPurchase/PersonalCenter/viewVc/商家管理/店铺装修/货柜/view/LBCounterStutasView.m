//
//  LBCounterStutasView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCounterStutasView.h"
#import "LBCounterStutasViewcell.h"

@interface LBCounterStutasView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableview;

@property (assign, nonatomic) CGFloat cellH;

@property (strong, nonatomic) NSArray *dataArr;

@property (nonatomic, copy) void (^indexBlock)(NSInteger index, NSString *text);

@end

static NSString *ID = @"LBCounterStutasViewcell";

@implementation LBCounterStutasView


-(instancetype)initWithFrame:(CGRect)frame dataSorce:(NSArray *)dataArr cellHeight:(CGFloat)cellH selectindex:(void (^)(NSInteger, NSString *))indexBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellH = cellH;
        self.dataArr = dataArr;
        self.indexBlock = indexBlock;
        [self initInterface];
    }
    return self;
}

-(void)initInterface{
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    
}

#pragma mark - 重写----设置有groupTableView有几个分区

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.cellH;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LBCounterStutasViewcell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titlelb.text = self.dataArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.indexBlock) {
        self.indexBlock(indexPath.row,self.dataArr[indexPath.row]);
        
    }
    
}

-(UITableView*)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.tableFooterView = [UIView new];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
    }
    
    return _tableview;
}

-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
