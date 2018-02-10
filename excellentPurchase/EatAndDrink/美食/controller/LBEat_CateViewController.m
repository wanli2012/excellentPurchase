//
//  LBEat_CateViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/16.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_CateViewController.h"
#import "GLIntegralHeaderView.h"
#import "LBBurstingWithPopularityTableViewCell.h"
#import "GLNearby_classifyCell.h"
#import "LBFinishMainViewController.h"
#import "LBEatAndDrinkViewController.h"
#import "LBEat_StoreDetailViewController.h"
#import "LBEat_cateModel.h"
#import "LBSaveLocationInfoModel.h"

static NSString *burstingWithPopularityTableViewCell = @"LBBurstingWithPopularityTableViewCell";
static NSString *nearby_classifyCell = @"GLNearby_classifyCell";

@interface LBEat_CateViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 头部轮播
 */
@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;

@end

/**
 头部视图的图片比例

 */
#define carouselViewHScle 242.0/750

@implementation LBEat_CateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self.tableView registerNib:[UINib nibWithNibName:burstingWithPopularityTableViewCell bundle:nil] forCellReuseIdentifier:burstingWithPopularityTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:nearby_classifyCell bundle:nil] forCellReuseIdentifier:nearby_classifyCell];
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
  
    
}

-(void)setupNpdata{
    WeakSelf;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    
    //emptyView内容上的点击事件监听
    [self.tableView.ly_emptyView setTapContentViewBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    }];
}

-(void)setuprefrsh{
    
    [self loadData:1 refreshDirect:YES];
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:self.tableView];
        }else{
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
        }
    }];
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"cate_id"] = [LBEat_cateModel defaultUser].cate_id;
     dic[@"lng"] = [LBSaveLocationInfoModel defaultUser].strLongitude;
     dic[@"lat"] = [LBSaveLocationInfoModel defaultUser].strLatitude;
    dic[@"page"] = @(page);
    
    [NetworkManager requestPOSTWithURLStr:HappyHappy paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            
            if (isDirect) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBEat_cateDataModel *model = [LBEat_cateDataModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            self.tableView.tableHeaderView = self.cycleScrollView;
            if ([LBEat_cateModel defaultUser].cate_banners.count <= 0) {
                self.cycleScrollView.localizationImageNamesGroup = [[NSMutableArray alloc] initWithArray: @[@"eat-banner"]];
            }else{
                self.cycleScrollView.imageURLStringsGroup = [[NSMutableArray alloc] initWithArray: [LBEat_cateModel defaultUser].cate_banners];
            }
            [self.tableView reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }

    } enError:^(NSError *error) {

         [LBDefineRefrsh dismissRefresh:self.tableView];
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

        return EatCellH;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:nearby_classifyCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArr[indexPath.section];
        return cell;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBEat_StoreDetailViewController *vc = [[LBEat_StoreDetailViewController alloc]init];
    vc.store_id = ((LBEat_cateDataModel*)self.dataArr[indexPath.section]).store_id;
    vc.titilestr = ((LBEat_cateDataModel*)self.dataArr[indexPath.section]).store_name;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
  
}
#pragma mark - 点击轮播图 回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (LBEatAndDrinkViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[LBEatAndDrinkViewController class]]) {
            return (LBEatAndDrinkViewController *)nextResponder;
        }
    }
    return nil;
}

-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
    
}
-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * carouselViewHScle) delegate:self placeholderImage:[UIImage imageNamed:@"banner(吃喝玩乐）"]];//当一张都没有的时候的 占位图
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = @[@" "];
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}
@end
