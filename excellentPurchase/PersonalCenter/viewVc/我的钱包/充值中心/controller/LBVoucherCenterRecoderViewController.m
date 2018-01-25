//
//  LBVoucherCenterRecoderViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBVoucherCenterRecoderViewController.h"
#import "LBVoucherCenterRecoderTableViewCell.h"

@interface LBVoucherCenterRecoderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *voucherCenterRecoderTableViewCell = @"LBVoucherCenterRecoderTableViewCell";

@implementation LBVoucherCenterRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值记录";
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:voucherCenterRecoderTableViewCell bundle:nil] forCellReuseIdentifier:voucherCenterRecoderTableViewCell];
    
    adjustsScrollViewInsets_NO(self.tableview, self);
    
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
    
    LBVoucherCenterRecoderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voucherCenterRecoderTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


@end
