//
//  LBHomeOneDolphinDetailController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeOneDolphinDetailController.h"
#import "LBHomeOneDolphinDetailHeaderView.h"
#import "LBHomeDolphinDetailSectionHeader.h"
#import "LBDolphinDetailJoinTableViewCell.h"
#import "LBDolphinDetailbeforeTableViewCell.h"
#import "LBDolphinDetailShowPicTableViewCell.h"
#import "LBDolphincalculateDetailViewController.h"
#import "LBHomeOneDolphinDetailmodel.h"
#import "LBDolphinDetailRankcell.h"
#import "LBDolphinDetailRulecell.h"
#import "LBHomeOneDolphinPictureDetailController.h"
#import <UShareUI/UShareUI.h>
#import "LBDolphinDetailJoinheaderTableViewCell.h"
#import "LBindianaParticipationView.h"
#import "LBindiana_PayController.h"
#import "LBHomeViewActivityViewController.h"

#define kHeaderViewH (155 + UIScreenWidth)

@interface LBHomeOneDolphinDetailController ()<UITableViewDelegate,UITableViewDataSource,LBHomeOneDolphinDetailHeaderdelegete>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) NSInteger buttonindex;
@property (strong, nonatomic) LBHomeOneDolphinDetailHeaderView *headview;
@property (strong, nonatomic) LBHomeOneDolphinDetailmodel *model;
@property (nonatomic, assign) BOOL sectionrefresh;
@property (strong, nonatomic) LBHomeDolphinDetailSectionHeader *sectionheaderview;
@property (nonatomic, strong) NSMutableArray *Arrone;
@property (nonatomic, strong) NSMutableArray *Arrtwo;
@property (nonatomic, strong) NSMutableArray *Arrthree;

@property (nonatomic, assign) NSInteger pageone;
@property (nonatomic, assign) NSInteger pagetwo;
@property (nonatomic, assign) NSInteger pagethree;

@property (nonatomic, strong) NSString *start_time;

@property (nonatomic, strong) UIButton *joinBt;
@property (nonatomic, strong) UIView *bottomview;
@property (strong , nonatomic)LBindianaParticipationView *Participationview;

@end

static NSString *ID = @"LBHomeDolphinDetailSectionHeader";

@implementation LBHomeOneDolphinDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"夺宝详情";
    adjustsScrollViewInsets_NO(self.tableview, self);
    [self.view addSubview:self.tableview];
    self.view.backgroundColor = [UIColor whiteColor];
    self.start_time = [[NSString alloc]init];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinDetailJoinTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBDolphinDetailJoinTableViewCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinDetailbeforeTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBDolphinDetailbeforeTableViewCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinDetailShowPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBDolphinDetailShowPicTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinDetailRankcell" bundle:nil] forCellReuseIdentifier:@"LBDolphinDetailRankcell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinDetailRulecell" bundle:nil] forCellReuseIdentifier:@"LBDolphinDetailRulecell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinDetailJoinheaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBDolphinDetailJoinheaderTableViewCell"];
    
    [self requestDatsource];
    [self setuprefrsh];
    
}
-(void)setuprefrsh{
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview footerRefresh:^{
        if (weakSelf.buttonindex == 11) {
            [weakSelf requestDatsourcetwo:NO];//往期记录
        }else if (weakSelf.buttonindex == 12){
            [weakSelf requestDatsourcethree:NO];//商品详情晒图记录
        }else{
           [weakSelf requestDatsourceone:NO];//本期记录
        }
    }];
    
}

-(void)rightNowJionview{
    _Participationview = [[NSBundle mainBundle]loadNibNamed:@"LBindianaParticipationView" owner:nil options:nil].firstObject;
    _Participationview.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
    _Participationview.frame = self.view.frame;
    [self.view addSubview:_Participationview];
    _Participationview.hidden = YES;
    _Participationview.indiana_remainder_count =  [NSString stringWithFormat:@"%zd",[self.model.indiana_everyone_max_count integerValue] - [self.model.start.buy_count integerValue]];
    WeakSelf;
    _Participationview.cancelEvent = ^{
        weakSelf.Participationview.hidden = YES;
    };
    
    _Participationview.sureEvent = ^(NSString *num) {
        [weakSelf sureAdd:num];
    };
}
-(void)requestDatsource{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"indiana_id"] = self.indiana_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_goods_detail paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.model = [LBHomeOneDolphinDetailmodel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.tableview.tableHeaderView = self.headview;
            _headview.model = _model;
            [self requestDatsourcethree:YES];//商品详情晒图记录
            [self requestDatsourceone:YES];//本期记录
            [self requestDatsourcetwo:YES];//往期记录
            
            if ([self.model.indiana_status integerValue] == 1) {
                [self.view addSubview:self.joinBt];
            }else{
                [self.view addSubview:self.bottomview];
            }
            
            [self rightNowJionview];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        
    }];
    
}

-(void)requestDatsourceone:(BOOL)refresh{
    
    if (refresh == YES) {
        self.pageone = 1;
    }else{
        self.pageone = 1 + self.pageone;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(self.pageone);
    dic[@"indiana_id"] = self.indiana_id;
    
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_goods_record paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (refresh == YES) {
                [self.Arrone removeAllObjects];
            }
            self.start_time = responseObject[@"data"][@"start_time"];
            [self.Arrone addObjectsFromArray: responseObject[@"data"][@"page_data"] ];
    
            if ((self.Arrone.count == [responseObject[@"data"][@"count"] integerValue] ) && refresh == NO) {
                [EasyShowTextView showErrorText:@"没有更多数据了"];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

-(void)requestDatsourcetwo:(BOOL)refresh{
    
    if (refresh == YES) {
        self.pagetwo = 1;
    }else{
        self.pagetwo = 1 + self.pagetwo;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(self.pagetwo);
    dic[@"indiana_id"] = self.model.indiana_id;
    
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_reward_history paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (refresh == YES) {
                [self.Arrtwo removeAllObjects];
            }

           [self.Arrtwo addObjectsFromArray: responseObject[@"data"][@"page_data"] ];
            
            if ((self.Arrtwo.count == [responseObject[@"data"][@"count"] integerValue] ) && refresh == NO) {
                [EasyShowTextView showErrorText:@"没有更多数据了"];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

-(void)requestDatsourcethree:(BOOL)refresh{
    
    if (refresh == YES) {
        self.pagethree = 1;
    }else{
        self.pagethree = 1 + self.pagethree;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(self.pagethree);
    dic[@"indiana_goods_key"] = self.model.indiana_goods_key;
    
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_slide_history paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (refresh == YES) {
                [self.Arrthree removeAllObjects];
            }
            
            [self.Arrthree addObjectsFromArray: responseObject[@"data"][@"page_data"] ];
            
            if ((self.Arrthree.count == [responseObject[@"data"][@"count"] integerValue] ) && refresh == NO) {
                [EasyShowTextView showErrorText:@"没有更多数据了"];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        [LBDefineRefrsh dismissRefresh:self.tableview];
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//立即参与
-(void)sureAdd:(NSString*)num{
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showErrorText:@"请先登录"];
        return;
    }
    if ([num integerValue] > [self.model.indiana_remainder_count integerValue]) {
        [EasyShowTextView showInfoText:@"已超人数"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"indiana_id"] = self.indiana_id;
    dic[@"count"] = num;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kIndianacreate_indiana_order paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.hidesBottomBarWhenPushed = YES;
            LBindiana_PayController *vc = [[LBindiana_PayController alloc]init];
            vc.datadic = responseObject[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
#pragma make ----- LBHomeOneDolphinDetailHeaderdelegete
-(void)checkPictureWord{//图文详情
    self.hidesBottomBarWhenPushed = YES;
    LBHomeOneDolphinPictureDetailController *vc = [[LBHomeOneDolphinPictureDetailController alloc]init];
    vc.good_id = self.model.indiana_goods_id;
    vc.indiana_id = self.model.indiana_id;
    vc.indiana_remainder_count = [NSString stringWithFormat:@"%zd",[self.model.indiana_everyone_max_count integerValue] - [self.model.start.buy_count integerValue]];
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"OrderDeail"];//1 表示从订单过去 2 表示从详情过去 之后会在支付成功退回到相应的界面
    [self.navigationController pushViewController:vc animated:YES];
}
//立即参与
-(void)immeditlyJion{
    _Participationview.hidden = NO;
}

-(void)sharegoodsinfo{//分享
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:platformType];
        
    }];
}

-(void)calculateEvent{//计算详情
    self.hidesBottomBarWhenPushed = YES;
    LBDolphincalculateDetailViewController *vc = [[LBDolphincalculateDetailViewController alloc]init];
    vc.indiana_id = self.model.indiana_id;
    vc.image_url = self.model .finished.reward_rule_thumb;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    NSString *goodsName = [NSString stringWithFormat:@"嘚瑟狗商品分享:%@",self.model.indiana_goods_name];
    NSString *goodsInfo = @"";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:goodsName descr:goodsInfo thumImage:self.model.indiana_goods_thumb.firstObject];
    
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@",self.model.indiana_share_url];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
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
    if (section == 1) {
        if (self.buttonindex == 11) {
            return self.Arrtwo.count;
        }else if (self.buttonindex == 12){
            return self.Arrthree.count;
        }else{
            if (self.Arrone.count > 0) {
                return self.Arrone.count + 1;
            }
            return 0;
        }
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            tableView.estimatedRowHeight = 20;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            return 185;
        }
    }else if (indexPath.section == 1){
        if (self.buttonindex == 11) {
            return 87;
        }else if (self.buttonindex == 12){
            tableView.estimatedRowHeight = 50;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            if (self.Arrone.count > 0) {
                if (indexPath.row == 0) {
                    return 40;
                }else{
                    return 50;
                }
            }
        }
    }
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LBDolphinDetailRulecell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinDetailRulecell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _model;
            return cell;
        }else{
            LBDolphinDetailRankcell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinDetailRankcell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _model;
            return cell;
        }
    }else{
        if (self.buttonindex == 11) {
            LBDolphinDetailbeforeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinDetailbeforeTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.datadic = self.Arrtwo[indexPath.row];
            return cell;
        }else if (self.buttonindex == 12){
            LBDolphinDetailShowPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinDetailShowPicTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.datadic = self.Arrthree[indexPath.row];
            return cell;
        }else{
            if (indexPath.row == 0) {
                LBDolphinDetailJoinheaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinDetailJoinheaderTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.timelb.text = [NSString stringWithFormat:@"(%@)",[formattime formateTimeYM:self.start_time]];
                return cell;
            }else{
                LBDolphinDetailJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinDetailJoinTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.dic = self.Arrone[indexPath.row - 1];
                return cell;
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 0.000001f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        if (!_sectionheaderview) {
            _sectionheaderview = [[LBHomeDolphinDetailSectionHeader alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
        }
        WeakSelf;
        _sectionheaderview.refreshDataosurce = ^(NSInteger index) {
            weakSelf.buttonindex = index;
            weakSelf.sectionrefresh = YES;
            [UIView performWithoutAnimation:^{
                [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        
        return _sectionheaderview;
    }
    
    return nil;
}

-(void)immeditlyjumpEvent{
    
    BOOL b = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LBHomeViewActivityViewController class]]) {//表示从活动页挑到详情
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectDoingActivity" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            b = YES;
        }
    }
    //表示从其他页挑到详情
    if (b == YES) {
        self.hidesBottomBarWhenPushed = YES;
        LBHomeViewActivityViewController *vc = [[LBHomeViewActivityViewController alloc]init];
        vc.titileStr = @"今日好运来";
        vc.selectindex = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
}

-(UITableView*)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 50) style:UITableViewStylePlain];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableFooterView = [UIView new];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
    }
    return _tableview;
}

-(LBHomeOneDolphinDetailHeaderView*)headview{
    if (!_headview) {
        _headview = [[NSBundle mainBundle]loadNibNamed:@"LBHomeOneDolphinDetailHeaderView" owner:self options:nil].firstObject;
        _headview.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, kHeaderViewH);
        _headview.autoresizingMask = 0;
        _headview.delegete = self;

    }
    return _headview;
}

-(NSMutableArray*)Arrone{
    if (!_Arrone) {
        _Arrone = [NSMutableArray array];
    }
    return _Arrone;
}

-(NSMutableArray*)Arrtwo{
    if (!_Arrtwo) {
        _Arrtwo = [NSMutableArray array];
    }
    return _Arrtwo;
}

-(NSMutableArray*)Arrthree{
    if (!_Arrthree) {
        _Arrthree = [NSMutableArray array];
    }
    return _Arrthree;
}

-(UIButton*)joinBt{
    if (!_joinBt) {
        _joinBt = [[UIButton alloc]initWithFrame:CGRectMake(0, UIScreenHeight - 50, UIScreenWidth, 50)];
        _joinBt.backgroundColor = MAIN_COLOR;
        [_joinBt setTitle:@"立即参与" forState:UIControlStateNormal];
        [_joinBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinBt addTarget:self action:@selector(immeditlyJion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBt;
}

-(UIView*)bottomview{
    if (!_bottomview) {
        _bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight - 50, UIScreenWidth, 50)];
        _bottomview.backgroundColor = LBHexadecimalColor(0xffcc03);
        UIButton *jumpbt = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenWidth - 100, 0, 100, 50)];
        jumpbt.backgroundColor = MAIN_COLOR;
        [jumpbt setTitle:@"立即参与" forState:UIControlStateNormal];
        [jumpbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        jumpbt.titleLabel.font = [UIFont systemFontOfSize:15];
        [jumpbt addTarget:self action:@selector(immeditlyjumpEvent) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:jumpbt];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, UIScreenWidth - 120, 50)];
        label.text = @"新的一期正在火热进行中...";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = LBHexadecimalColor(0x5c03ff);
        label.textAlignment = NSTextAlignmentCenter;
        [_bottomview addSubview:label];
    }
    
    return _bottomview;
}

@end
