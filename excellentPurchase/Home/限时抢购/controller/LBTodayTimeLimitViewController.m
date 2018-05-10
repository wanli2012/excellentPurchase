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
#import "LBSnapUpDetailViewController.h"
#import "LBTimeLimitBuyingViewController.h"

@interface LBTodayTimeLimitViewController ()<UITableViewDelegate,UITableViewDataSource,TXScrollLabelViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NSMutableArray *raceArr;//预告数组
@property (strong, nonatomic)NSMutableArray *raceIDArr;//预告数组ID
@property (strong, nonatomic)LBTodayTimeLimitModel *model;


@end

static NSString *timeLimitHorseTableViewCell = @"LBTimeLimitHorseTableViewCell";
static NSString *timeLimitQinggouTableViewCell = @"LBTimeLimitQinggouTableViewCell";
static NSString *timeLimitCrazingTableViewCell = @"LBTimeLimitCrazingTableViewCell";

@implementation LBTodayTimeLimitViewController

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)DestryTimer{
   

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
     [self.tableview registerNib:[UINib nibWithNibName:timeLimitHorseTableViewCell bundle:nil] forCellReuseIdentifier:timeLimitHorseTableViewCell];
      [self.tableview registerNib:[UINib nibWithNibName:timeLimitQinggouTableViewCell bundle:nil] forCellReuseIdentifier:timeLimitQinggouTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:timeLimitCrazingTableViewCell bundle:nil] forCellReuseIdentifier:timeLimitCrazingTableViewCell];
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf postRequest:YES];
        [weakSelf SnappingUpForecast];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    [self SnappingUpForecast];
    [self setupNpdata];//设置无数据的时候展示
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countDown) name:@"countDown" object:nil];
}

-(void)countDown{
    if (self.model.wait.count <= 0 && self.model.buying.data.count<=0) {
        return ;
    }
    for (int i=0; i<self.model.wait.count; i++) {
        NSInteger second = [self.model.wait[i].start_time integerValue];
        second = second - 1;
        self.model.wait[i].start_time = [NSString stringWithFormat:@"%ld",second];
    }
    
    self.model.buying.now_time = [NSString stringWithFormat:@"%d",[self.model.buying.now_time intValue] + 1];
    self.model.buying.end_time = [NSString stringWithFormat:@"%d",[self.model.buying.end_time intValue] - 1];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:TimeCellNotification object:nil userInfo:@{@"index":@"1"}];
}
//请求数据
-(void)postRequest:(BOOL)isRefresh{
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @(1);
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:ChallengeChallenge_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        self.model = nil;
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.model = [LBTodayTimeLimitModel mj_objectWithKeyValues:responseObject[@"data"]];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableview reloadData];
        
    }];
}
//抢购预告
-(void)SnappingUpForecast{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"status"] = @(1);

    [NetworkManager requestPOSTWithURLStr:kChallenge_trailer_info paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (int i = 0 ; i < [responseObject[@"data"]count]; i++) {
                [self.raceArr addObject:responseObject[@"data"][i][@"challenge_trailer_info"]];
                [self.raceIDArr addObject:responseObject[@"data"][i][@"challenge_goods_id"]];
            }
        }else{

        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        
    }];
}

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
    self.tableview.tableFooterView = [UIView new];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableview.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableview.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableview.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableview.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    self.tableview.ly_emptyView.contentViewY = 100;
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.raceArr.count <= 0) {
        if (self.model) {
            if (self.model.buying.data.count > 0) {
                return self.model.wait.count + 1;
            }else{
                return self.model.wait.count;
            }
        }
    }else{
        if (self.model) {
            if (self.model.buying.data.count > 0) {
                return self.model.wait.count + 2;
            }else{
                return self.model.wait.count + 1;
            }
        }
    }
    
    return 0;
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数

    if (self.raceArr.count <= 0) {
        if (self.model.buying.data.count > 0) {
            if (section == 0) {
              return  self.model.buying.data.count;
            }else{
                 return self.model.wait[section-1].active.count;
            }
        }else{
            return self.model.wait[section].active.count;
        }
        
    }else{
        if (self.model.buying.data.count > 0) {
            if (section == 0) {
                return 1;
            }else if (section == 1){
                return  self.model.buying.data.count;
            }else{
                return self.model.wait[section-2].active.count;
            }
        }else{
            if (section == 0) {
                return 1;
            }else{
                return self.model.wait[section-1].active.count;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.raceArr.count > 0) {
        if (indexPath.section == 0) {
            return 50;
        }else{
            return 114;
        }
    }else{
        return 114;
    }
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger indexSection = indexPath.section;
    if (self.raceArr.count <= 0) {
        if (self.model.buying.data.count > 0) {
            if (indexPath.section == 0) {
                LBTimeLimitCrazingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitCrazingTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = self.model.buying.data[indexPath.row];
                return cell;
            }else{
                indexSection = indexPath.section-1;
            }
        }
    }else{
        if (self.model.buying.data.count > 0) {
            if (indexPath.section == 0) {
                LBTimeLimitHorseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitHorseTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.dataArr = self.raceArr;
                cell.scrollLabelView.scrollLabelViewDelegate = self;
                cell.titilelb.text = @"今日预告";
                
                return cell;
            }else if (indexPath.section == 1){
                LBTimeLimitCrazingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitCrazingTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = self.model.buying.data[indexPath.row];
                return cell;
            }else{
                indexSection = indexPath.section - 2;
            }
        }else{
            if (indexPath.section == 0) {
                LBTimeLimitHorseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitHorseTableViewCell forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.dataArr = self.raceArr;
                cell.scrollLabelView.scrollLabelViewDelegate = self;
                cell.titilelb.text = @"今日预告";
                
                return cell;
            }else{
                indexSection = indexPath.section - 1;
            }
        }
    }
    
    LBTimeLimitQinggouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeLimitQinggouTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WeakSelf;
    cell.refreshdata = ^{
        [weakSelf.tableview reloadData];
    };
    cell.model = self.model.wait[indexSection].active[indexPath.row];
    return cell;

}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger indexSection = section;
    if (self.raceArr.count <= 0) {
        if (self.model.buying.data.count > 0) {
            if (section == 0) {
                LBTimeLimitHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBTimeLimitHeaderView"];
                if (!headerview) {
                    headerview = [[LBTimeLimitHeaderView alloc] initWithReuseIdentifier:@"LBTimeLimitHeaderView"];
                }
                headerview.buymodel = self.model.buying;
                headerview.status = 1;
                WeakSelf;
                headerview.refreshdata = ^{
                    weakSelf.page = 1;
                    [weakSelf postRequest:YES];
                };
                [headerview setSecond:self.model.buying.end_time row:section buyingsecond:self.model.buying.now_time];
                return headerview;
            }else{
                indexSection = section - 1;
            }
        }
        
    }else{
        if (self.model.buying.data.count > 0) {
            if (section == 0) {
                UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
                return headerLabel;
            }else if (section == 1){
                LBTimeLimitHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBTimeLimitHeaderView"];
                if (!headerview) {
                    headerview = [[LBTimeLimitHeaderView alloc] initWithReuseIdentifier:@"LBTimeLimitHeaderView"];
                }
                 headerview.buymodel = self.model.buying;
                headerview.status = 1;
                WeakSelf;
                headerview.refreshdata = ^{
                    weakSelf.page = 1;
                    [weakSelf postRequest:YES];
                };
                [headerview setSecond:self.model.buying.end_time row:section-1 buyingsecond:self.model.buying.now_time];
                return headerview;
            }else{
                indexSection = section - 2;
            }
        }else{
            if (section == 0) {
                UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
                return headerLabel;
            }else{
                indexSection = section - 1;
            }
        }
    }
    
    LBTimeLimitHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBTimeLimitHeaderView"];
    if (!headerview) {
        headerview = [[LBTimeLimitHeaderView alloc] initWithReuseIdentifier:@"LBTimeLimitHeaderView"];
    }
 
    LBTodayWatTimeLimitActiveModel *model = self.model.wait[indexSection];
    headerview.waitmodel = model;
    headerview.status = 2;
    WeakSelf;
    headerview.refreshdata = ^{
        weakSelf.page = 1;
        [weakSelf postRequest:YES];
    };
    [headerview setSecond:self.model.wait[indexSection].start_time row:indexSection buyingsecond:nil];
    return headerview;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.raceArr.count >0) {
        if (section == 0) {
            return 10;
        }
    }
    return 108.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger indexsection = indexPath.section;
    NSString *goods_id = @"";
    
    if (self.raceArr.count <= 0) {
        if (self.model.buying.data.count > 0) {
            if (indexPath.section == 0) {
                goods_id = self.model.buying.data[indexPath.row].goods_id;
            }else{
                indexsection = indexPath.section - 1;
            }
        }else{
          
        }
        
    }else{
        if (self.model.buying.data.count > 0) {
            if (indexPath.section == 0) {
                return;
            }else if (indexPath.section == 1){
                indexsection = indexPath.section - 1;
                goods_id = self.model.buying.data[indexPath.row].goods_id;
            }else{
                indexsection = indexPath.section - 2;
            }
        }else{
            if (indexPath.section == 0) {
                return;
            }else{
                 indexsection = indexPath.section - 1;
            }
        }
    }
    
    if ([NSString StringIsNullOrEmpty:goods_id]) {
        goods_id = self.model.wait[indexsection].active[indexPath.row].goods_id;
    }
    
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBSnapUpDetailViewController *vc = [[LBSnapUpDetailViewController alloc]init];
    vc.goods_id = goods_id;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (self.raceArr.count <= 0) {
        if (self.model.buying.data.count > 0) {
            if (section == 0) {
                LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
                headerview.isDisplay = YES;
                 headerview.status = 1;
               [headerview setSecond:self.model.buying.end_time row:section buyingsecond:self.model.buying.now_time];
            }else{
                LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
                headerview.isDisplay = YES;
                 headerview.status = 2;
                [headerview setSecond:self.model.wait[section-1].start_time row:section-1 buyingsecond:nil];
            }
        }else{
            LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
            headerview.isDisplay = YES;
             headerview.status = 2;
           [headerview setSecond:self.model.wait[section].start_time row:section buyingsecond:nil];
        }
        
    }else{
        if (self.model.buying.data.count > 0) {
            if (section == 0) {
 
            }else if (section == 1){
                LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
                headerview.isDisplay = YES;
                 headerview.status = 1;
                [headerview setSecond:self.model.buying.end_time row:section-1 buyingsecond:self.model.buying.now_time];
            }else{
                LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
                headerview.isDisplay = YES;
                 headerview.status = 2;
                [headerview setSecond:self.model.wait[section-2].start_time row:section-2 buyingsecond:nil];
            }
        }else{
            if (section == 0) {
               
            }else{
                LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
                headerview.isDisplay = YES;
                 headerview.status = 2;
                 [headerview setSecond:self.model.wait[section-1].start_time row:section-1 buyingsecond:nil];
            }
        }
    }
    
    

}

-(void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    if (self.raceArr.count > 0) {
        if (section == 0) {
            
        }else{
            LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
            headerview.isDisplay = NO;
        }
    }else{
        LBTimeLimitHeaderView  *headerview =  (LBTimeLimitHeaderView*)view;
        headerview.isDisplay = NO;
    }
}
/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (LBTimeLimitBuyingViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[LBTimeLimitBuyingViewController class]]) {
            return (LBTimeLimitBuyingViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark - TXScrollLabelViewDelegate
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBSnapUpDetailViewController *vc = [[LBSnapUpDetailViewController alloc]init];
    vc.goods_id = self.raceIDArr[index];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载

-(NSMutableArray *)raceArr{
    
    if (!_raceArr) {
        _raceArr = [NSMutableArray array];
    }
    
    return _raceArr;
    
}
-(NSMutableArray *)raceIDArr{
    
    if (!_raceIDArr) {
        _raceIDArr = [NSMutableArray array];
    }
    
    return _raceIDArr;
    
}

@end
