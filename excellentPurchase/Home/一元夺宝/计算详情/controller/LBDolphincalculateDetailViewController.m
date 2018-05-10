//
//  LBDolphincalculateDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphincalculateDetailViewController.h"
#import "NSMutableAttributedString+LBSpecialAttributedString.h"
#import "LBDolphincalculateDetailSectionView.h"
#import "LBDolphincalculateDetailTitileCell.h"
#import "LBDolphincalculateDetailvalueCell.h"
#import "LBDolphincalculateDetailmodel.h"
#import "NSMutableAttributedString+LBSpecialAttributedString.h"

@interface LBDolphincalculateDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *luckNumbers;
@property (assign , nonatomic)BOOL ishow;
@property (strong , nonatomic)LBDolphincalculateDetailmodel *model;
@property (weak, nonatomic) IBOutlet UIImageView *calculateimage;


@end

@implementation LBDolphincalculateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"计算详情";
    self.luckNumbers.attributedText = [NSMutableAttributedString addoriginstr:self.luckNumbers.text specilstr:@[@"幸运号码:"] strFont:[UIFont systemFontOfSize:12] strColor:LBHexadecimalColor(0x808080)];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphincalculateDetailTitileCell" bundle:nil] forCellReuseIdentifier:@"LBDolphincalculateDetailTitileCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphincalculateDetailvalueCell" bundle:nil] forCellReuseIdentifier:@"LBDolphincalculateDetailvalueCell"];
    
    [self.calculateimage sd_setImageWithURL:[NSURL URLWithString:self.image_url] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    [self requestDatsource];
}

-(void)requestDatsource{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"indiana_id"] = self.indiana_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_detail paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model = [LBDolphincalculateDetailmodel mj_objectWithKeyValues:responseObject[@"data"]];
            if ([self.model.status integerValue] == 3) {
                self.luckNumbers.attributedText = [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"幸运号码: %@",self.model.number] specilstr:@[[NSString stringWithFormat:@"%@",self.model.number]] strFont:[UIFont systemFontOfSize:16] strColor:MAIN_COLOR];
            }else{
     self.luckNumbers.attributedText = [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"幸运号码: 等待揭晓"] specilstr:@[@"等待揭晓"] strFont:[UIFont systemFontOfSize:16] strColor:MAIN_COLOR];
            }
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        
    }];
    
}


#pragma mark - UITabelViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.model) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.model.page_data.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 30;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0) {
        LBDolphincalculateDetailTitileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphincalculateDetailTitileCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LBDolphincalculateDetailvalueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphincalculateDetailvalueCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timelb.text = [NSString stringWithFormat:@"%@",[formattime formateTime:self.model.page_data[indexPath.row - 1].times]];
        cell.numbers.text = self.model.page_data[indexPath.row - 1].lucky_number;
        cell.namelb.text = self.model.page_data[indexPath.row - 1].nickname;
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 120;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBDolphincalculateDetailSectionView *headerview = [[NSBundle mainBundle]loadNibNamed:@"LBDolphincalculateDetailSectionView" owner:nil options:nil].firstObject;
    if (section == 0) {
        headerview.imagev.hidden = NO;
        UITapGestureRecognizer *tapgestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureshow)];
        [headerview addGestureRecognizer:tapgestrue];
        if (self.ishow) {
            headerview.imagev.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            headerview.imagev.transform = CGAffineTransformIdentity;
        }
        headerview.valuelb.text = @"A";
        headerview.numbers.text = [NSString stringWithFormat:@"=%@",self.model.stamp];
        headerview.describelb.text = @"=截止该商品开奖时间点前最后50条全站参与记录";
    }else{
        headerview.imagev.hidden = YES;
        headerview.valuelb.text = @"B";
        headerview.describelb.text = @"=最近一期重庆时时彩票的开奖结果";
        if ([self.model.status integerValue] == 3) {
             headerview.numbers.attributedText =  [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"= %@ (第%@期)",self.model.code,self.model.except] specilstr:@[[NSString stringWithFormat:@"(第%@期)",self.model.except]] strFont:[UIFont systemFontOfSize:14] strColor:LBHexadecimalColor(0x808080)];
        }else{
             headerview.numbers.attributedText =  [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"= 正在等待开奖... (第%@期)",self.model.except] specilstr:@[[NSString stringWithFormat:@"(第%@期)",self.model.except]] strFont:[UIFont systemFontOfSize:14] strColor:LBHexadecimalColor(0x808080)];
        }
    }
    
    return headerview;

}

-(void)tapgestureshow{
    self.ishow = !self.ishow;
    [self.tableview reloadData];
}

@end
