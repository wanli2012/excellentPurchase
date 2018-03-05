//
//  LBTodayTimeLimitViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTodayTimeLimitViewController.h"
#import "LBTimeLimitHorseTableViewCell.h"
#import "LBTimeLimitHeaderView.h"
#import "LBTimeLimitQinggouTableViewCell.h"
#import "LBTimeLimitCrazingTableViewCell.h"

@interface LBTodayTimeLimitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *timeLimitHorseTableViewCell = @"LBTimeLimitHorseTableViewCell";
static NSString *timeLimitQinggouTableViewCell = @"LBTimeLimitQinggouTableViewCell";
static NSString *timeLimitCrazingTableViewCell = @"LBTimeLimitCrazingTableViewCell";

@implementation LBTodayTimeLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     [self.tableview registerNib:[UINib nibWithNibName:timeLimitHorseTableViewCell bundle:nil] forCellReuseIdentifier:timeLimitHorseTableViewCell];
      [self.tableview registerNib:[UINib nibWithNibName:timeLimitQinggouTableViewCell bundle:nil] forCellReuseIdentifier:timeLimitQinggouTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:timeLimitCrazingTableViewCell bundle:nil] forCellReuseIdentifier:timeLimitCrazingTableViewCell];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 3; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 6;
    }else if (section == 2){
         return 6;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    }else  if (indexPath.section == 1) {
        return 114;
    }else if (indexPath.section == 2){
         return 114;
    }
    return 0;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        LBTimeLimitHorseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitHorseTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        LBTimeLimitCrazingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitCrazingTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
        LBTimeLimitQinggouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitQinggouTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headerLabel;
    }else{
        LBTimeLimitHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBTimeLimitHeaderView"];
        if (!headerview) {
            headerview = [[LBTimeLimitHeaderView alloc] initWithReuseIdentifier:@"LBTimeLimitHeaderView"];
        }
        
        return headerview;
    }
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
   
    if (section == 0) {
        return 10;
    }
    return 108.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

@end
