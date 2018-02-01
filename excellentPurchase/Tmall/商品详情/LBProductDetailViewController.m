//
//  LBProductDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductDetailViewController.h"
#import "DLNavigationTabBar.h"
#import "PopoverView.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBTaoTaoProductInofoTableViewCell.h"
#import "LBCommentHeaderTableViewCell.h"
#import "LBCheckMoreCommentsTableViewCell.h"
#import "LBCommentListsTableViewCell.h"
#import "LBriceshopwebviewTableViewCell.h"
#import "LBProductDetailWebTitleTableViewCell.h"
#import "GLIntegralGoodsTwoCell.h"
#import "StandardsView.h"
#import "LBCommentListsView.h"
#import "JYCarousel.h"
#import "JYImageCache.h"
#import "LBMineSureOrdersViewController.h"//确认订单
#import "LBTmallProductDetailModel.h"

@interface LBProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate,LBTaoTaoProductInofoDelegate,StandardsViewDelegate,LBCheckMoreCommentsDelegate>
@property(nonatomic,strong)NSArray *subViewControllers;
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@property (weak, nonatomic) IBOutlet UIButton *merchetBt;//商家
@property (weak, nonatomic) IBOutlet UIButton *collectBt;//收藏
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,assign) CGFloat webHeight;//商品详情网页加载高度
@property (nonatomic ,assign) CGFloat shiftGoodsH;//推荐商品cell的高度

@property (nonatomic ,assign) BOOL isTapMenu;//判断是否点击标签
@property (nonatomic ,assign) BOOL isShowComment;//是否展示的评论界面

/**
 评论view
 */
@property (strong , nonatomic)LBCommentListsView *commentView;
/**
 头部轮播
 */
@property (nonatomic, strong) JYCarousel *carouselView;

@property (nonatomic, strong) LBTmallProductDetailModel *model;

@property (nonatomic, strong) UIWebView *webView;//加载商品详情

@property (nonatomic ,assign) NSInteger ptype;//商品类型 1厂家直销 2产地直供 3品牌加盟 4渠道授权/微商特供 5商场自营

@property (nonatomic, strong) StandardsView *mystandardsView;//加载商品详情

@end

static NSString *taoTaoProductInofoTableViewCell = @"LBTaoTaoProductInofoTableViewCell";
static NSString *commentHeaderTableViewCell = @"LBCommentHeaderTableViewCell";
static NSString *checkMoreCommentsTableViewCell = @"LBCheckMoreCommentsTableViewCell";
static NSString *commentListsTableViewCell = @"LBCommentListsTableViewCell";
static NSString *riceshopwebviewTableViewCell = @"LBriceshopwebviewTableViewCell";
static NSString *productDetailWebTitleTableViewCell = @"LBProductDetailWebTitleTableViewCell";
static NSString *goodsDetailRecommendListCell = @"GLIntegralGoodsTwoCell";

@implementation LBProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.navigationTabBar;
    [self registerTablecell];
  
    [self addBavigationItem];//添加item
    [self.merchetBt verticalCenterImageAndTitle:5];
    [self.collectBt verticalCenterImageAndTitle:5];
   
    [self loadData];//加载数据
    [self setupNpdata];//设置无数据的时候展示
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",TmallPdetail,self.goods_id]]]];

    
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
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [EasyShowLodingView showLodingText:@"正在加载"];
    [NetworkManager requestPOSTWithURLStr:SeaShoppingGoods_data paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.ptype = [responseObject[@"data"][@"channel"] integerValue];
             self.model = [LBTmallProductDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.collectBt.selected = [self.model.is_collect integerValue]==0?NO:YES;//收藏状态
            
            if (self.ptype == 5) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"][@"goods_spec"]) {
                    LBTmallProductDetailgoodsSpecModel * model = [LBTmallProductDetailgoodsSpecModel mj_objectWithKeyValues:dic];
                    [arr addObject:model];
                }
                
                self.model.goods_speca = arr;
            }else{
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"][@"goods_spec"]) {
                    LBTmallProductDetailgoodsSpecOtherModel * model = [LBTmallProductDetailgoodsSpecOtherModel mj_objectWithKeyValues:dic];
                    [arr addObject:model];
                }
                
                self.model.autotrophygoods_spec = arr;
            }
            [self addCarouselView1];
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
    }];
    
}


-(void)registerTablecell{
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:taoTaoProductInofoTableViewCell bundle:nil] forCellReuseIdentifier:taoTaoProductInofoTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:commentHeaderTableViewCell bundle:nil] forCellReuseIdentifier:commentHeaderTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:checkMoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:checkMoreCommentsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:commentListsTableViewCell bundle:nil] forCellReuseIdentifier:commentListsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:riceshopwebviewTableViewCell bundle:nil] forCellReuseIdentifier:riceshopwebviewTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:productDetailWebTitleTableViewCell bundle:nil] forCellReuseIdentifier:productDetailWebTitleTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:goodsDetailRecommendListCell bundle:nil] forCellReuseIdentifier:goodsDetailRecommendListCell];
}

-(void)addBavigationItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"taotao-detail-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMoreInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //    返回按钮
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = ba;
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    
    self.isTapMenu = YES;
    
    if (index == 0) {
        [self.tableview setContentOffset:CGPointMake(0,0) animated:YES];
    }else{
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
   
}

#pragma mark - 立即购买
- (IBAction)buyNow:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineSureOrdersViewController *sureOrderVC = [[LBMineSureOrdersViewController alloc] init];
    [self.navigationController pushViewController:sureOrderVC animated:YES];
    
}
#pragma mark - 加入购物车
- (IBAction)addShopCar:(UIButton *)sender {
    
}
#pragma mark - 收藏
- (IBAction)colllectProduct:(UIButton *)sender {
    if (sender.selected == YES) {//收藏过 ，该取消收藏
        [self userCancelCollection];
    }else{//取消该藏过
        [self userCollection];
    }
}
#pragma mark - 跳转商家主页
- (IBAction)jumpMerchat:(UIButton *)sender {
}


#pragma mark - tableview滚动联动导航栏标签
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.isTapMenu == NO) {
        NSIndexPath *topHeaderViewIndexpath = [[self.tableview indexPathsForVisibleRows] firstObject];
        if (topHeaderViewIndexpath.section == 0) {
            [self.navigationTabBar scrollToIndex:0];
        }else if (topHeaderViewIndexpath.section == 1){
            [self.navigationTabBar scrollToIndex:1];
        }else if (topHeaderViewIndexpath.section == 2){
            [self.navigationTabBar scrollToIndex:2];
        }
    }
    
}
#pragma mark - 滚动完成置为NO
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.isTapMenu == YES) {
        self.isTapMenu = NO;
    }
}
#pragma mark - 分享
-(void)shareInfo{
    
}
#pragma mark - 选择规格
-(void)chooseSpecification{
    _mystandardsView = [self buildStandardView:self.model.thumb andIndex:-1];
    _mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
    _mystandardsView.showAnimationType = StandsViewShowAnimationShowFromLeft;
    _mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisToRight;
    [_mystandardsView show];
}
-(StandardsView *)buildStandardView:(NSString *)img andIndex:(NSInteger)index
{
    StandardsView *standview = [[StandardsView alloc] init];
    standview.tag = index;
    standview.delegate = self;

    [standview.mainImgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:nil];
    standview.mainImgView.backgroundColor = [UIColor whiteColor];
    standview.priceLab.text = [NSString stringWithFormat:@"¥%@",self.model.discount];
    standview.tipLab.text = [NSString stringWithFormat:@"%@",self.model.goods_name];
    standview.goodNum.text =  [NSString stringWithFormat:@"库存 %@",self.model.goods_num];
    
    standview.customBtns = @[@"加入购物车",@"立即购买"];
    
    if (self.ptype == 5) {
        if (self.model.goods_speca.count != 0) {
            NSMutableArray *arr1 = [NSMutableArray array];
            for (int i = 0; i < self.model.goods_speca.count; i++) {
                LBTmallProductDetailgoodsSpecModel *model = self.model.goods_speca[i];
                NSMutableArray *arr = [NSMutableArray array];
                for (int j = 0; j < model.items.count ; j++ ) {
                    LBTmallProductDetailgoodsSpecItemModel *model1 = model.items[j];
                    standardClassInfo *tempClassInfo = [standardClassInfo StandardClassInfoWith:model1.itemid andStandClassName:model1.title];
                    [arr addObject:tempClassInfo];
                }
                StandardModel *tempModel = [StandardModel StandardModelWith:arr andStandName:model.title];
                [arr1 addObject:tempModel];
            }
            standview.standardArr = [arr1 copy];
        }
    }else{
        if (self.model.autotrophygoods_spec.count != 0) {
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.model.autotrophygoods_spec.count ; i++) {
                LBTmallProductDetailgoodsSpecOtherModel *model = self.model.autotrophygoods_spec[i];
                standardClassInfo *tempClassInfo;
                if (model.title.length <= 0) {
                    tempClassInfo = [standardClassInfo StandardClassInfoWith:@"1" andStandClassName:@"默认"];
                }else{
                    tempClassInfo = [standardClassInfo StandardClassInfoWith:model.idspec andStandClassName:model.title];
                }
                [arr addObject:tempClassInfo];
            }
            
            StandardModel *tempModel = [StandardModel StandardModelWith:arr andStandName:@"规格"];
            standview.standardArr = @[tempModel];
        }
    }

    return standview;
}
#pragma mark - standardView  delegate
//点击自定义按键
-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        //将商品图片抛到指定点
        [standardView ThrowGoodTo:CGPointMake(200, 100) andDuration:1.6 andHeight:150 andScale:20];
    }
    else
    {
        [standardView dismiss];
    }
}

//点击规格代理
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index
{
    if (self.ptype == 5) {
        if (self.model.goods_speca.count != 0) {
            LBTmallProductDetailgoodsSpecModel *model = self.model.goods_speca[index];
            for (int i = 0; i < model.items.count ; i++ ) {
                LBTmallProductDetailgoodsSpecItemModel *model1 = model.items[i];
                if ([model1.itemid isEqualToString:selectID]) {
                    [_mystandardsView.mainImgView sd_setImageWithURL:[NSURL URLWithString:model1.spec_thumb] placeholderImage:nil];
                    _mystandardsView.priceLab.text = [NSString stringWithFormat:@"¥%@",model1.marketprice];
                    _mystandardsView.tipLab.text = [NSString stringWithFormat:@"%@",model1.title];
                    _mystandardsView.goodNum.text =  [NSString stringWithFormat:@"库存 %@",model1.stock];
                    break;
                }
            }
        }
    }else{
        if (self.model.autotrophygoods_spec.count != 0) {
            LBTmallProductDetailgoodsSpecOtherModel *model1 = self.model.autotrophygoods_spec[index];
            //[_mystandardsView.mainImgView sd_setImageWithURL:[NSURL URLWithString:model1.spec_thumb] placeholderImage:nil];
            _mystandardsView.priceLab.text = [NSString stringWithFormat:@"¥%@",model1.marketprice];
            _mystandardsView.tipLab.text = [NSString stringWithFormat:@"%@",model1.title];
            _mystandardsView.goodNum.text =  [NSString stringWithFormat:@"库存 %@",model1.stock];
        }
    }
    
    NSLog(@"selectID = %@ standName = %@ index = %ld",selectID,standName,(long)index);
    
}
//设置自定义btn的属性
-(void)StandardsView:(StandardsView *)standardView SetBtn:(UIButton *)btn
{
    if (btn.tag == 0) {//加入购物车
         btn.backgroundColor = YYSRGBColor(251, 160, 163, 1);
    }
    else if (btn.tag == 1)//立即购买
    {
        btn.backgroundColor = YYSRGBColor(250, 78, 83, 1);
    }
}
#pragma mark - 查看更多评论
-(void)checkMoreComments{
    [self.view addSubview:self.commentView];
    [self.commentView showView];
    self.isShowComment = YES;
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"评论列表";
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return  self.model?4:0;
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (self.model.comment_list.count > 0) {
            return self.model.comment_list.count + 2;
        }else{
            return 1;
        }
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        if (self.model.love.count <= 0) {
            return 0;
        }
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 200;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40;
        }else if (indexPath.row == self.model.comment_list.count + 1){
            return 60;
        }else{
            return ((LBTmallProductDetailgoodsCommentModel*)self.model.comment_list[indexPath.row - 1]).cellH;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 40;
        }else if (indexPath.row == 1){
            return self.webHeight;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 40;
        }else if (indexPath.row == 1){
          return self.shiftGoodsH;
        }
    }
    return 0;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBTaoTaoProductInofoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taoTaoProductInofoTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.delegate = self;
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            LBCommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentHeaderTableViewCell forIndexPath:indexPath];
             cell.selectionStyle = 0;
            cell.repalyNum.text = [NSString stringWithFormat:@"(共%@条)",self.model.comment_count];
            return cell;
        }else if (indexPath.row == self.model.comment_list.count + 1){
            LBCheckMoreCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:checkMoreCommentsTableViewCell forIndexPath:indexPath];
             cell.selectionStyle = 0;
            cell.delegate = self;
            return cell;
        }else{
            LBCommentListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentListsTableViewCell forIndexPath:indexPath];
             cell.selectionStyle = 0;
            cell.model = self.model.comment_list[indexPath.row-1];
            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            LBProductDetailWebTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailWebTitleTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.titlelb.text = @"商品详情";
            return cell;
        }else if (indexPath.row == 1){
            LBriceshopwebviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:riceshopwebviewTableViewCell forIndexPath:indexPath];
           
            if (self.webHeight != 0) {
                [cell addSubview:_webView];
            }
            return cell;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            LBProductDetailWebTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailWebTitleTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.titlelb.text = @"猜你喜欢";
            return cell;
        }else if (indexPath.row == 1){
            GLIntegralGoodsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsDetailRecommendListCell forIndexPath:indexPath];
            [cell refreshdataSource:self.model.love];
            self.shiftGoodsH = cell.beautfHeight;

            return cell;
        }
    }
    
    return [[UITableViewCell alloc]init];
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
        return 0.0001f;
    }
    return 20.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark ----- uiwebviewdelegete
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    
    self.webHeight = webViewHeight + 10;
    
        //回调或者说是通知主线程刷新，
        _webView.frame = CGRectMake(0, 0, UIScreenWidth, self.webHeight);
        [UIView performWithoutAnimation:^{
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];  //你需要更新的组数中的cell
            [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self.tableview layoutIfNeeded]; // 强制更新
   
}
#pragma mark - 展示更多选项
-(void)showMoreInfo{
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-xiaoxi"] title:@"消息" handler:^(PopoverAction *action) {
        
    }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-shouye"] title:@"首页" handler:^(PopoverAction *action) {
        
    }];
    PopoverAction *action3 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-kefu"] title:@"客服" handler:^(PopoverAction *action) {
        
    }];
    PopoverAction *action4 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-kefu"] title:@"购物车" handler:^(PopoverAction *action) {
        
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
    [popoverView showToPoint:CGPointMake(UIScreenWidth - 20, SafeAreaTopHeight) withActions:@[action1, action2, action3, action4]];
}

//取消收藏
-(void)userCancelCollection{
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"DELETE";
    dic[@"collect_id"] = self.model.is_collect;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @"1"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingNot_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect=0;
            self.collectBt.selected = NO;
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//收藏
-(void)userCollection{
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"link_id"] = self.model.goods_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @"1"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingUser_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            self.collectBt.selected = YES;
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

-(void)popself{
    if (self.isShowComment == YES) {//展示的评论界面
        self.navigationItem.titleView = self.navigationTabBar;
        self.navigationItem.title = nil;
        [self.commentView hideView];
        self.isShowComment = NO;
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)addCarouselView1{
    
    //block方式创建
    __weak typeof(self) weakSelf = self;

      NSMutableArray   *imageArray  = [[NSMutableArray alloc] initWithArray: _model.thumb_url];

    
    if (!_carouselView) {
        _carouselView= [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
            carouselConfig.pageContollType = LabelPageControl;
            carouselConfig.interValTime = 3;
            return carouselConfig;
        } clickBlock:^(NSInteger index) {
            
        }];
        self.tableview.tableHeaderView = _carouselView;
    }
    //开始轮播
    [_carouselView startCarouselWithArray:imageArray];
    
}

-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:@[@"商品",@"评价",@"详情"]];
        __weak typeof(self) weakSelf = self;
        [self.navigationTabBar setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _navigationTabBar;
}

-(LBCommentListsView*)commentView{
    if (!_commentView) {
        _commentView = [[LBCommentListsView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, self.view.height- 60)];
        _commentView.backgroundColor = [UIColor redColor];
        _commentView.goods_id = self.goods_id;
    }
    
    return _commentView;
}

@end
