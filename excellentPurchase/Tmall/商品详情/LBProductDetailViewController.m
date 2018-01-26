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
#import "LBTaoTaoProductDeailHeaderView.h"
#import "LBTaoTaoProductInofoTableViewCell.h"
#import "LBCommentHeaderTableViewCell.h"
#import "LBCheckMoreCommentsTableViewCell.h"
#import "LBCommentListsTableViewCell.h"
#import "LBriceshopwebviewTableViewCell.h"
#import "LBProductDetailWebTitleTableViewCell.h"
#import "LBGoodsDetailRecommendListCell.h"
#import "StandardsView.h"
#import "LBCommentListsView.h"

#import "LBMineSureOrdersViewController.h"//确认订单

@interface LBProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate,LBTaoTaoProductInofoDelegate,StandardsViewDelegate,LBCheckMoreCommentsDelegate>
@property(nonatomic,strong)NSArray *subViewControllers;
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@property (weak, nonatomic) IBOutlet UIButton *merchetBt;//商家
@property (weak, nonatomic) IBOutlet UIButton *collectBt;//收藏
@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**
 头部视图
 */
@property (strong , nonatomic)LBTaoTaoProductDeailHeaderView *headerView;

@property (nonatomic ,assign) CGFloat webHeight;//商品详情网页加载高度
@property (nonatomic ,assign) CGFloat shiftGoodsH;//推荐商品cell的高度
@property (nonatomic ,assign) BOOL isTapMenu;//判断是否点击标签
@property (nonatomic ,assign) BOOL isShowComment;//是否展示的评论界面

/**
 评论view
 */
@property (strong , nonatomic)LBCommentListsView *commentView;

@end

static NSString *taoTaoProductInofoTableViewCell = @"LBTaoTaoProductInofoTableViewCell";
static NSString *commentHeaderTableViewCell = @"LBCommentHeaderTableViewCell";
static NSString *checkMoreCommentsTableViewCell = @"LBCheckMoreCommentsTableViewCell";
static NSString *commentListsTableViewCell = @"LBCommentListsTableViewCell";
static NSString *riceshopwebviewTableViewCell = @"LBriceshopwebviewTableViewCell";
static NSString *productDetailWebTitleTableViewCell = @"LBProductDetailWebTitleTableViewCell";
static NSString *goodsDetailRecommendListCell = @"LBGoodsDetailRecommendListCell";

@implementation LBProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.navigationTabBar;
    self.tableview.tableHeaderView = self.headerView;
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:taoTaoProductInofoTableViewCell bundle:nil] forCellReuseIdentifier:taoTaoProductInofoTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:commentHeaderTableViewCell bundle:nil] forCellReuseIdentifier:commentHeaderTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:checkMoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:checkMoreCommentsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:commentListsTableViewCell bundle:nil] forCellReuseIdentifier:commentListsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:riceshopwebviewTableViewCell bundle:nil] forCellReuseIdentifier:riceshopwebviewTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:productDetailWebTitleTableViewCell bundle:nil] forCellReuseIdentifier:productDetailWebTitleTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:goodsDetailRecommendListCell bundle:nil] forCellReuseIdentifier:goodsDetailRecommendListCell];
  
    [self addBavigationItem];//添加item
    
    [self.merchetBt verticalCenterImageAndTitle:5];
    [self.collectBt verticalCenterImageAndTitle:5];
   
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
#pragma mark - 选择规格
-(void)chooseSpecification{
    StandardsView *mystandardsView = [self buildStandardView:[UIImage imageNamed:@"banner"] andIndex:1];
    mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
    mystandardsView.showAnimationType = StandsViewShowAnimationShowFromLeft;
    mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisToRight;
    [mystandardsView show];
}
-(StandardsView *)buildStandardView:(UIImage *)img andIndex:(NSInteger)index
{
    StandardsView *standview = [[StandardsView alloc] init];
    standview.tag = index;
    standview.delegate = self;

    standview.mainImgView.image = img;
    standview.mainImgView.backgroundColor = [UIColor whiteColor];
    standview.priceLab.text = @"¥100.0";
    standview.tipLab.text = @"请选择规格请选择规格请选择规格请选择规格请选择规格请选择规格请选择规格请选择规格请选择规格请选择规格";
    standview.goodNum.text = @"库存 10件";
    
    standview.customBtns = @[@"加入购物车",@"立即购买"];
    
    standardClassInfo *tempClassInfo1 = [standardClassInfo StandardClassInfoWith:@"100" andStandClassName:@"红色"];
    standardClassInfo *tempClassInfo2 = [standardClassInfo StandardClassInfoWith:@"101" andStandClassName:@"蓝色"];
    NSArray *tempClassInfoArr = @[tempClassInfo1,tempClassInfo2];
    StandardModel *tempModel = [StandardModel StandardModelWith:tempClassInfoArr andStandName:@"颜色"];
    
    standardClassInfo *tempClassInfo3 = [standardClassInfo StandardClassInfoWith:@"102" andStandClassName:@"XL"];
    standardClassInfo *tempClassInfo4 = [standardClassInfo StandardClassInfoWith:@"103" andStandClassName:@"XXL"];
    standardClassInfo *tempClassInfo5 = [standardClassInfo StandardClassInfoWith:@"104" andStandClassName:@"XXXXXXXXXXXXXL"];
    NSArray *tempClassInfoArr2 = @[tempClassInfo3,tempClassInfo4,tempClassInfo5];
    StandardModel *tempModel2 = [StandardModel StandardModelWith:tempClassInfoArr2 andStandName:@"尺寸"];
    standview.standardArr = @[tempModel,tempModel2,tempModel,tempModel2];
    
    
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
    return 4; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
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
            return 90;
        }else if (indexPath.row == 3){
            return 60;
        }else{
            tableView.estimatedRowHeight = 110;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
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
//            return self.shiftGoodsH;
            return ((UIScreenWidth-1)/2.0 + 100)*2;
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
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            LBCommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentHeaderTableViewCell forIndexPath:indexPath];
             cell.selectionStyle = 0;
            return cell;
        }else if (indexPath.row == 3){
            LBCheckMoreCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:checkMoreCommentsTableViewCell forIndexPath:indexPath];
             cell.selectionStyle = 0;
            cell.delegate = self;
            return cell;
        }else{
            LBCommentListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentListsTableViewCell forIndexPath:indexPath];
             cell.selectionStyle = 0;
            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            LBProductDetailWebTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailWebTitleTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = 0;
            return cell;
        }else if (indexPath.row == 1){
            LBriceshopwebviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:riceshopwebviewTableViewCell forIndexPath:indexPath];
            if (cell.isload == NO) {
               
            }
            //cell.webview.delegate = self;
            return cell;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            LBProductDetailWebTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productDetailWebTitleTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = 0;
            return cell;
        }else if (indexPath.row == 1){
            LBGoodsDetailRecommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsDetailRecommendListCell forIndexPath:indexPath];
            self.shiftGoodsH = cell.shiftGoodsH;

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
    
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];  //你需要更新的组数中的cell
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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

-(LBTaoTaoProductDeailHeaderView *)headerView{
    if (!_headerView) {
       
        _headerView = [[LBTaoTaoProductDeailHeaderView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth)];
    }
    return _headerView;
}
-(LBCommentListsView*)commentView{
    if (!_commentView) {
        _commentView = [[LBCommentListsView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, self.view.height- 60)];
        _commentView.backgroundColor = [UIColor redColor];
    }
    
    return _commentView;
}

@end
