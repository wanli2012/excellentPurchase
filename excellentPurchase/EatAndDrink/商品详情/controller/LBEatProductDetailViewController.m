//
//  LBEatProductDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEatProductDetailViewController.h"
#import "LBEatProductDetailTableViewCell.h"
#import "LBEatProductDetailTitleTableViewCell.h"
#import "LBEat_storeDetailInfoOtherTableViewCell.h"
#import "LBEatProductDetailModel.h"
#import "LBProductPhotosBrowserVc.h"

@interface LBEatProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) LBEatProductDetailModel *model;
/**
 头部轮播
 */
@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner

@end

static NSString *eatProductDetailTableViewCell = @"LBEatProductDetailTableViewCell";
static NSString *eatProductDetailTitleTableViewCell = @"LBEatProductDetailTitleTableViewCell";
static NSString *eat_storeDetailInfoOtherTableViewCell = @"LBEat_storeDetailInfoOtherTableViewCell";

@implementation LBEatProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableview registerNib:[UINib nibWithNibName:eatProductDetailTableViewCell bundle:nil] forCellReuseIdentifier:eatProductDetailTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eatProductDetailTitleTableViewCell bundle:nil] forCellReuseIdentifier:eatProductDetailTitleTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfoOtherTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfoOtherTableViewCell];
    
     [self loadData];//加载数据
    [self setupNpdata];//设置无数据的时候展示
    
    self.navigationItem.title = self.goods_name;
    
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
        [weakSelf loadData];
    }];
}

-(void)loadData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"goods_id"] = self.goods_id;
    dic[@"uid"] = [UserModel defaultUser].uid;
    [EasyShowLodingView showLodingText:@"正在加载"];
    [NetworkManager requestPOSTWithURLStr:HappyGoodsData paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {

            _model =  [LBEatProductDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.tableview.tableHeaderView = self.cycleScrollView;
            self.cycleScrollView.imageURLStringsGroup = @[_model.thumb];
            [self.tableview reloadData];
        }else{

            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }

        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
    }];
    
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.model) {
        if (self.model.other.count>0) {
             return 2;
        }
        return 1;
    }
    return 0; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 2;
    }else if (section == 1){
        if (self.model.other.count>0) {
            return 1 + self.model.other.count;
        }
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            tableView.estimatedRowHeight = 100;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            return 50;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 50;
        }else{
            tableView.estimatedRowHeight = 60;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }

    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LBEatProductDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eatProductDetailTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.model;
            return cell;
        }else{
            LBEatProductDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eatProductDetailTitleTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titileLb.text = @"商品图";
            cell.imagev.hidden = NO;
            return cell;
        }
    }else{
        
        if (indexPath.row == 0) {
            LBEatProductDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eatProductDetailTitleTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titileLb.text = @"其他";
            cell.imagev.hidden = YES;
            return cell;
        }else{
            LBEat_storeDetailInfoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_storeDetailInfoOtherTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.pmodel = self.model.other[indexPath.row - 1];
            return cell;
        }
        
    }
    
    return [[UITableViewCell alloc]init];
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.0001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row != 0) {
        self.hidesBottomBarWhenPushed = YES;
        LBProductPhotosBrowserVc *vc = [[LBProductPhotosBrowserVc alloc]init];
        vc.urls = self.model.more_pic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row > 0) {
        self.hidesBottomBarWhenPushed = YES;
        LBEatProductDetailViewController *vc = [[LBEatProductDetailViewController alloc]init];
        vc.goods_id = ((LBEatProductDetailOtherModel*)self.model.other[indexPath.row - 1]).goods_id;
        vc.goods_name = ((LBEatProductDetailOtherModel*)self.model.other[indexPath.row - 1]).goods_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 点击轮播图 回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"shangpinxiangqing"]];//当一张都没有的时候的 占位图
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 翻页 右下角
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlDotSize = CGSizeMake(7, 7);
        _cycleScrollView.localizationImageNamesGroup = @[@" "];
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}

@end
