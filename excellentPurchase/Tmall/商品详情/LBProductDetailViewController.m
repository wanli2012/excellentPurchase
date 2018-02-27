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
#import "LBMineSureOrdersViewController.h"//确认订单
#import "LBTmallProductDetailModel.h"
#import "LBEatShopProdcutClassifyViewController.h"

#import <UShareUI/UShareUI.h>
#import "GLMine_MessageController.h"//消息
#import "GLMine_ShoppingCartController.h"//购物车

@interface LBProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,LBTaoTaoProductInofoDelegate,StandardsViewDelegate,LBCheckMoreCommentsDelegate,GLIntegralGoodsTwodelegete,SDCycleScrollViewDelegate>
@property(nonatomic,strong)NSArray *subViewControllers;
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@property (weak, nonatomic) IBOutlet UIButton *merchetBt;//商家
@property (weak, nonatomic) IBOutlet UIButton *collectBt;//收藏
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *muneViewY;

@property (nonatomic ,assign) CGFloat webHeight;//商品详情网页加载高度
@property (nonatomic ,assign) CGFloat shiftGoodsH;//推荐商品cell的高度

@property (nonatomic ,assign) BOOL isTapMenu;//判断是否点击标签
@property (nonatomic ,assign) BOOL isShowComment;//是否展示的评论界面

/**
 评论view
 */
@property (strong , nonatomic)LBCommentListsView *commentView;

@property (nonatomic, strong) LBTmallProductDetailModel *model;

@property (nonatomic ,assign) NSInteger ptype;//商品类型 1厂家直销 2产地直供 3品牌加盟 4渠道授权/微商特供 5商场自营

@property (nonatomic, strong) StandardsView *mystandardsView;//加载商品详情

@property (nonatomic ,assign) NSInteger specid;//规格名ID
@property (nonatomic ,assign) NSInteger itemid;//规格项ID
@property (nonatomic ,assign) NSInteger goods_option_id;//规格参数id
@property (nonatomic ,assign) NSInteger buy_num;//商品数量

@property (nonatomic ,assign) BOOL isShowSpec;//是否展示规格

@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navagationH;

@end

static NSString *taoTaoProductInofoTableViewCell = @"LBTaoTaoProductInofoTableViewCell";
static NSString *commentHeaderTableViewCell = @"LBCommentHeaderTableViewCell";
static NSString *checkMoreCommentsTableViewCell = @"LBCheckMoreCommentsTableViewCell";
static NSString *commentListsTableViewCell = @"LBCommentListsTableViewCell";
static NSString *riceshopwebviewTableViewCell = @"LBriceshopwebviewTableViewCell";
static NSString *productDetailWebTitleTableViewCell = @"LBProductDetailWebTitleTableViewCell";
static NSString *goodsDetailRecommendListCell = @"GLIntegralGoodsTwoCell";

@implementation LBProductDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [EasyShowLodingView hidenLoding];
}
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTableViewCellHight:)  name:@"getCellHightNotification" object:nil];//更新webview cell的高度
    
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
                self.merchetBt.hidden = YES;
            }else{
                 self.merchetBt.hidden = NO;
            }
            self.muneViewY.constant = 0;
            [UIView animateWithDuration:0.5 animations:^{
                // 对布局进行渲染
                [self.view layoutIfNeeded]; //layoutIfNeeded方法只会刷新子控件,因此要使用必须通过它的父类
            }];
            self.tableview.tableHeaderView = self.cycleScrollView;
            self.cycleScrollView.imageURLStringsGroup = self.model.thumb_url;
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
-(void)setTableViewCellHight:(NSNotification *)info
{
    NSDictionary * dic=info.userInfo;
    //判断通知中的参数是否与原来的值一致,防止死循环
    if (self.webHeight != [[dic objectForKey:@"height"]floatValue])
    {
        self.webHeight=[[dic objectForKey:@"height"]floatValue];
        [self.tableview beginUpdates];
        [self.tableview endUpdates];
//        [self.tableview reloadData];
    }
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

         [self chooseSpecification];
    
}
#pragma mark - 加入购物车
- (IBAction)addShopCar:(UIButton *)sender {
    

        [self chooseSpecification];
    
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
    self.hidesBottomBarWhenPushed = YES;
    LBEatShopProdcutClassifyViewController *vc = [[LBEatShopProdcutClassifyViewController alloc]init];
    vc.store_id = self.model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//跳转商品详情
-(void)clickCheckGoodsinfo:(NSString *)goodid{
    self.hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
    vc.goods_id = goodid;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:platformType];
        
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    
    NSString *goodsName = [NSString stringWithFormat:@"嘚瑟狗商品分享:%@",self.model.goods_name];
    NSString *goodsInfo = self.model.goods_info;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:goodsName descr:goodsInfo thumImage:self.model.thumb];
    
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@%@",share_URL_Base,shareMalldetail,self.goods_id];

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


#pragma mark - 选择规格
-(void)chooseSpecification{
        _mystandardsView = [self buildStandardView:self.model.thumb andIndex:-1];
//        _mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
        _mystandardsView.showAnimationType = StandsViewShowAnimationShowFromLeft;
        _mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisToRight;
        [_mystandardsView show];
        self.goods_option_id = 0;
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
    
        if (self.model.goods_spec.count != 0) {
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.model.goods_spec.count; i++) {
                LBTmallProductDetailgoodsSpecModel *model = self.model.goods_spec[i];
                standardClassInfo *tempClassInfo = [standardClassInfo StandardClassInfoWith:model.optionid andStandClassName:model.title];
                [arr addObject:tempClassInfo];
            }
            StandardModel *tempModel = [StandardModel StandardModelWith:arr andStandName:@"规格"];
            standview.standardArr = @[tempModel];
        }
    
    return standview;
}
#pragma mark - standardView  delegate
//点击自定义按键
-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender
{
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    
    if (self.goods_option_id == 0) {
        [EasyShowTextView showInfoText:@"请选择规格"];
        return;
    }
    
    if (sender.tag == 0) {
        //将商品图片抛到指定点
        [self addShopCar];
    }
    else
    {
        [self rightNoewbuy];//立即购买
    }
}

//点击规格代理
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index
{

        if (self.model.goods_spec.count != 0) {
            LBTmallProductDetailgoodsSpecModel *model1 = self.model.goods_spec[index];
            if ([NSString StringIsNullOrEmpty:model1.marketprice] == NO) {
                _mystandardsView.priceLab.text = [NSString stringWithFormat:@"¥%@",model1.marketprice];
            }
            if ([NSString StringIsNullOrEmpty:model1.title] == NO) {
                _mystandardsView.tipLab.text = [NSString stringWithFormat:@"%@",model1.title];
            }
            if ([NSString StringIsNullOrEmpty:model1.stock] == NO) {
                _mystandardsView.goodNum.text =  [NSString stringWithFormat:@"库存 %@",model1.stock];
            }
            
            self.specid = 0;
            self.itemid = 0;
            self.goods_option_id = [model1.optionid integerValue];
        }
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
            cell.replayBt.hidden = YES;
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
            cell.selectionStyle = 0;
            cell.urlstr = [NSString stringWithFormat:@"%@%@%@",URL_Base,TmallPdetail,self.goods_id];
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
            cell.delegate = self;

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

#pragma mark - 展示更多选项
-(void)showMoreInfo{
    WeakSelf;
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-xiaoxi"] title:@"消息" handler:^(PopoverAction *action) {
        if ([UserModel defaultUser].loginstatus == NO) {
            [EasyShowTextView showInfoText:@"请先登录"];
            return;
        }
        self.hidesBottomBarWhenPushed = YES;
        GLMine_MessageController *vc = [[GLMine_MessageController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];

    }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-shouye"] title:@"首页" handler:^(PopoverAction *action) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"rippleEffect";
        [self.view.window.layer addAnimation:animation forKey:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    PopoverAction *action4 = [PopoverAction actionWithImage:[UIImage imageNamed:@"taotao-more-gouwuche"] title:@"购物车  " handler:^(PopoverAction *action) {
        if ([UserModel defaultUser].loginstatus == NO) {
            [EasyShowTextView showInfoText:@"请先登录"];
            return;
        }
        self.hidesBottomBarWhenPushed = YES;
        GLMine_ShoppingCartController *vc = [[GLMine_ShoppingCartController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
    [popoverView showToPoint:CGPointMake(UIScreenWidth - 20, SafeAreaTopHeight) withActions:@[action1, action2, action4]];
}
#pragma mark ------- 立即购买
-(void)rightNoewbuy{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"goods_str"] = self.model.goods_id;
    dic[@"spec_str"] = @(self.goods_option_id);
    dic[@"count_str"] = @(_mystandardsView.buyNum);

    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:OrderConfirm_product_order paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.hidesBottomBarWhenPushed = YES;
            LBMineSureOrdersViewController *sureOrderVC = [[LBMineSureOrdersViewController alloc] init];
            sureOrderVC.DataArr = responseObject[@"data"];
            [self.navigationController pushViewController:sureOrderVC animated:YES];
            [_mystandardsView dismiss];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
#pragma mark ------- 加入购物车
-(void)addShopCar{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"store_id"] = self.model.store_id;
    dic[@"goods_id"] = self.model.goods_id;
    dic[@"buy_num"] = @(_mystandardsView.buyNum);
    dic[@"specid"] = @(self.specid);
    dic[@"itemid"] = @(self.itemid);
    dic[@"goods_option_id"] = @(self.goods_option_id);
    
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:UserCartAdd_cart paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [_mystandardsView ThrowGoodTo:CGPointMake(200, 100) andDuration:1.6 andHeight:150 andScale:20];
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
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
            
            self.model.is_collect = 0;
            self.collectBt.selected = NO;
            if (self.block) {
                self.block(self.index,NO);
            }
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
            
            if (self.block) {
                self.block(self.index,YES);
            }
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
#pragma mark - 点击轮播图 回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navagationH.constant = SafeAreaTopHeight;
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
        _cycleScrollView.showPageControl = YES;
    }
    
    return _cycleScrollView;
    
}
@end
