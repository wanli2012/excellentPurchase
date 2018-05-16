//
//  LBDolphinRecoderDoingViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinRecoderDoingViewController.h"
#import "LBDolphinRecodermodel.h"
#import "LBDolphinRecoderDoingCell.h"
#import "LBHomeOneDolphinPictureDetailController.h"
#import "LBDolphinRecoderViewController.h"
#import "LBHomeOneDolphinDetailController.h"

@interface LBDolphinRecoderDoingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray    *dataArr;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, assign) NSInteger  allCount;

@end

@implementation LBDolphinRecoderDoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBDolphinRecoderDoingCell" bundle:nil] forCellReuseIdentifier:@"LBDolphinRecoderDoingCell"];
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
    
}

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
    
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    }];
}

-(void)setuprefrsh{
    WeakSelf;
    [self loadData:self.page refreshDirect:YES];
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:weakSelf.tableview];
        }else{
            weakSelf.page = weakSelf.page + 1;
            [weakSelf loadData:weakSelf.page refreshDirect:NO];
        }
    }];
    
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(page);
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"status"] = @"1";//1活动中 3已开奖 0全部
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            if (isDirect) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBDolphinRecodermodel *model = [LBDolphinRecodermodel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count <= 0) {
                [EasyShowTextView showInfoText:@"没有数据啦!!!"];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        
    }];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.dataArr.count; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 160;
}
#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     LBDolphinRecodermodel *model = self.dataArr[indexPath.section];
        LBDolphinRecoderDoingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDolphinRecoderDoingCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
    WeakSelf;
    cell.superaddition = ^(LBDolphinRecodermodel *model) {
        weakSelf.hidesBottomBarWhenPushed = YES;
        LBHomeOneDolphinPictureDetailController *vc = [[LBHomeOneDolphinPictureDetailController alloc]init];
        vc.good_id = model.indiana_goods_id;
        vc.indiana_id = model.indiana_id;
        vc.indiana_remainder_count = [NSString stringWithFormat:@"%zd",[model.indiana_everyone_max_count integerValue] - [model.sy_count integerValue]];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"OrderDeail"];//1 表示从订单过去 2 表示从详情过去 之后会在支付成功退回到相应的界面
        [[self viewController].navigationController pushViewController:vc animated:YES];
    };
        return cell;
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return label;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LBDolphinRecodermodel *model = self.dataArr[indexPath.section];
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBHomeOneDolphinDetailController *vc = [[LBHomeOneDolphinDetailController alloc]init];
    vc.indiana_id = model.indiana_id;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - 懒加载
/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (LBDolphinRecoderViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[LBDolphinRecoderViewController class]]) {
            return (LBDolphinRecoderViewController *)nextResponder;
        }
    }
    return nil;
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
