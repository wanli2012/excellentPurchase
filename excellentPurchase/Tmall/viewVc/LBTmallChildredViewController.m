//
//  LBTmallChildredViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallChildredViewController.h"
#import "GLIntegralGoodsTwoCell.h"
#import "GLIntegralHeaderTableViewCell.h"
#import "LBintegralGoodsAciticityTableViewCell.h"
#import "GLIntegralGoodsOneCell.h"
#import "LBRiceShopTagTableViewCell.h"
#import "LBTmallFirstCalssifymodel.h"
#import "LBTmallhomepageDataModel.h"
#import "LBTmallProductListViewController.h"
#import "LBTmallViewController.h"
#import "LBProductDetailViewController.h"
#import "LBTmallSeconedClassifyModel.h"

static NSString *integralGoodsOneCell = @"GLIntegralGoodsOneCell";
static NSString *integralGoodsTwoCell = @"GLIntegralGoodsTwoCell";
static NSString *integralHeaderTableViewCell = @"GLIntegralHeaderTableViewCell";
static NSString *integralGoodsAciticityTableViewCell = @"LBintegralGoodsAciticityTableViewCell";
static NSString *riceShopTagTableViewCell = @"LBRiceShopTagTableViewCell";

@interface LBTmallChildredViewController ()<UITableViewDelegate,UITableViewDataSource,GLIntegralGoodsTwodelegete,GLIntegralGoodsOnedelegete,LBRiceShopTagTableViewCelldelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign , nonatomic)CGFloat productListH;//缓存商品cell高度
@property (assign , nonatomic)CGFloat tagViewHeight;//标签的高度
@property (nonatomic, strong) NSMutableArray *classifydataArr;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, strong) LBTmallhomepageDataModel *dataModel;//数据模型

@end

@implementation LBTmallChildredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
     [self.tableview registerNib:[UINib nibWithNibName:integralGoodsTwoCell bundle:nil] forCellReuseIdentifier:integralGoodsTwoCell];
     [self.tableview registerNib:[UINib nibWithNibName:integralHeaderTableViewCell bundle:nil] forCellReuseIdentifier:integralHeaderTableViewCell];
     [self.tableview registerNib:[UINib nibWithNibName:integralGoodsAciticityTableViewCell bundle:nil] forCellReuseIdentifier:integralGoodsAciticityTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:integralGoodsOneCell bundle:nil] forCellReuseIdentifier:integralGoodsOneCell];
    [self.tableview registerNib:[UINib nibWithNibName:riceShopTagTableViewCell bundle:nil] forCellReuseIdentifier:riceShopTagTableViewCell];
    
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
    [self craetDispathGroup];//创建网络队列
}

-(void)craetDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLoding];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //任务一
    dispatch_group_async(group, queue, ^{
        [weakSelf addTwoClassify:^{ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
            //一个任务结束时标记一个信号量
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    //任务二
    dispatch_group_async(group, queue, ^{
        [weakSelf loadData:^{ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
            //一个任务结束时标记一个信号量
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        //2个任务,2个信号等待.
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{//返回主线程
             [EasyShowLodingView hidenLoding];
            [LBDefineRefrsh dismissRefresh:self.tableview];
            //这里就是所有异步任务请求结束后执行的代码
             [_tableview reloadData];
            
        });
    });
    
}

-(void)addTwoClassify:(void(^)(void))finish{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"s_type"] = [LBTmallFirstCalssifymodel defaultUser].type_id;
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingCate_list paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.classifydataArr removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"]) {
                LBTmallSeconedClassifyModel *model = [LBTmallSeconedClassifyModel mj_objectWithKeyValues:dic];
                [self.classifydataArr addObject:model];
            }
        }else{
            
        }

        finish();
    } enError:^(NSError *error) {
         finish();
    }];
    
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
        [weakSelf craetDispathGroup];
    }];
}

-(void)setuprefrsh{
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf craetDispathGroup];
    }];
    
}

-(void)loadData:(void(^)(void))finish {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"s_type"] = self.s_type;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }else{
        dic[@"uid"] = @"";
        dic[@"token"] = @"";
    }
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingSea_index paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataModel = [LBTmallhomepageDataModel mj_objectWithKeyValues:responseObject[@"data"]];

        }else{

            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        finish();
    } enError:^(NSError *error) {
        finish();
        
    }];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.dataModel) {
        return 4;
    }
    return 0; //返回值是多少既有几个分区
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (self.dataModel.groom_goods_list.count <= 0) {
            return 0;
        }
        return 2;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        if (self.dataModel.choice_goods_list.count <= 0) {
            return 0;
        }
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80;
    }else  if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
            return 150 * 2/3.0 + 110;
        }
    }else if (indexPath.section == 2){
        return EatActBannerScle * UIScreenWidth;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
           return self.productListH;
        }
    }
    return 0;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        LBRiceShopTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:riceShopTagTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArr = self.classifydataArr;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GLIntegralHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralHeaderTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imagev.image = [UIImage imageNamed:@"taotao-meirituijian"];
            WeakSelf;
            cell.checkMoreProducts = ^(NSInteger section) {
                [weakSelf viewController].hidesBottomBarWhenPushed = YES;
                LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
                vc.refreshBlock = ^(BOOL isCollected) {
                    [weakSelf craetDispathGroup];
                };
                vc.catename = @"搜索";
                vc.goods_type = 1;
                vc.s_type = self.s_type;
                [[weakSelf viewController].navigationController pushViewController:vc animated:YES];
                [weakSelf viewController].hidesBottomBarWhenPushed = NO;
            };
            return cell;
        }else if (indexPath.row == 1){
            GLIntegralGoodsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsOneCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataArr = self.dataModel.groom_goods_list;
            cell.delegete = self;
            return cell;
        }
    }else if (indexPath.section == 2){
        LBintegralGoodsAciticityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsAciticityTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            GLIntegralHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralHeaderTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imagev.image = [UIImage imageNamed:@"taotao-jingpinyouxuan"];
            WeakSelf;
            cell.checkMoreProducts = ^(NSInteger section) {
                [weakSelf viewController].hidesBottomBarWhenPushed = YES;
                LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
                vc.catename = @"搜索";
                vc.goods_type = 2;
                vc.refreshBlock = ^(BOOL isCollected) {
                    [weakSelf craetDispathGroup];
                };
                vc.s_type = [LBTmallFirstCalssifymodel defaultUser].type_id;
                [[weakSelf viewController].navigationController pushViewController:vc animated:YES];
                [weakSelf viewController].hidesBottomBarWhenPushed = NO;
            };
            
            return cell;
        }else if (indexPath.row == 1){
            GLIntegralGoodsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsTwoCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshdataSource:self.dataModel.choice_goods_list];
            self.productListH = cell.beautfHeight;
            cell.delegate = self;
            return cell;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

#pragma mark - GLIntegralGoodsTwodelegete,GLIntegralGoodsOnedelegete
-(void)clickGoodsdetail:(NSString *)goodsid{
    [self jumpProductDetail:goodsid];
}
-(void)clickCheckGoodsinfo:(NSString *)goodid{
    [self jumpProductDetail:goodid];
}
-(void)jumpProductDetail:(NSString*)productid{//商品详情
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
    vc.goods_id = productid;
    WeakSelf;
    vc.block = ^(NSInteger index, BOOL isCollected) {
        [weakSelf craetDispathGroup];
    };
    
    [[self viewController].navigationController pushViewController:vc animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1.0f;
    }else if (section == 1){
        if (self.dataModel.groom_goods_list.count <= 0) {
            return 0.001f;
        }
    }
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark ------LBRiceShopTagTableViewCelldelegete
-(void)jumpGoodsClassify:(NSString *)cate_id cataname:(NSString *)catename{
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
    vc.cate_id = cate_id;
    vc.catename = catename;
    vc.s_type = self.s_type;
    WeakSelf;
    vc.refreshBlock = ^(BOOL isCollected) {
         [weakSelf setuprefrsh];//刷新
    };
    
    [[self viewController].navigationController pushViewController:vc animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
}

/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (LBTmallViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[LBTmallViewController class]]) {
            return (LBTmallViewController *)nextResponder;
        }
    }
    return nil;
}
-(NSMutableArray*)classifydataArr{
    if (!_classifydataArr) {
        _classifydataArr = [NSMutableArray array];
    }
    return _classifydataArr;
}

@end
