//
//  LBDonationListView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDonationListView.h"
#import "LBDonationTableViewCell.h"

@interface LBDonationListView()<UITableViewDataSource,UITableViewDelegate>

@end

static NSString *donationTableViewCell = @"LBDonationTableViewCell";

@implementation LBDonationListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self initInterfac];//加载数据
    }
    
    return self;
}

-(void)initInterfac{
    [self addSubview:self.tableview];
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:donationTableViewCell bundle:nil] forCellReuseIdentifier:donationTableViewCell];
    
   
    
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBDonationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:donationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(UITableView*)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, self.frame.size.height) style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        
    }
    
    return _tableview;
}

@end
