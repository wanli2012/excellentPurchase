//
//  LBEat_StoreDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreDetailViewController.h"
#import "JYCarousel.h"
#import "JYImageCache.h"
#import "LBEat_storeDetailInfoOtherTableViewCell.h"
#import "LBEat_storeDetailInfodiscountTableViewCell.h"
#import "LBEat_storeDetailInfomationHeaderView.h"
#import "LBEat_storeDetailInfomationTableViewCell.h"
#import "LBEat_StoreCommentsViewController.h"

static NSString *eat_storeDetailInfodiscountTableViewCell = @"LBEat_storeDetailInfodiscountTableViewCell";
static NSString *eat_storeDetailInfoOtherTableViewCell = @"LBEat_storeDetailInfoOtherTableViewCell";
static NSString *eat_storeDetailInfomationTableViewCell = @"LBEat_storeDetailInfomationTableViewCell";

@interface LBEat_StoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LBEat_storeDetailInfomationdelegete>

@property (strong , nonatomic)UIButton *collectionButton;
@property (strong , nonatomic)UIButton *messageButton;

/**
 头部轮播
 */
@property (nonatomic, strong) JYCarousel *carouselView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation LBEat_StoreDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"养生汤锅";
    
    [self addRightItems];
    [self addCarouselView1];//加载头部视图
    
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfodiscountTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfodiscountTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfoOtherTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfoOtherTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfomationTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfomationTableViewCell];

}

/**
 点击评论
 */
-(void)tapgesturecomments{
    self.hidesBottomBarWhenPushed = YES;
    LBEat_StoreCommentsViewController *vc = [[LBEat_StoreCommentsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 3; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
         return 3;
    }else if (section == 2){
         return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 1){
        return 111;
    }else if (indexPath.section == 2){
        return 114;
    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBEat_storeDetailInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_storeDetailInfomationTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        LBEat_storeDetailInfodiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_storeDetailInfodiscountTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        LBEat_storeDetailInfoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_storeDetailInfoOtherTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc]init];
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section != 0) {
        LBEat_storeDetailInfomationHeaderView *headerLabel = [[NSBundle mainBundle]loadNibNamed:@"LBEat_storeDetailInfomationHeaderView" owner:self options:nil].firstObject;
        
        return headerLabel;
    }
    
    return nil;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }
    return 50.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}


-(void)addRightItems{
    
    _collectionButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _collectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [_collectionButton setImage:[UIImage imageNamed:@"taotao-collect-n"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"taotao-collect-y"] forState:UIControlStateSelected];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    _collectionButton.backgroundColor=[UIColor clearColor];
    [_collectionButton addTarget:self action:@selector(collectionButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _messageButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [_messageButton setImage:[UIImage imageNamed:@"eat-chat"] forState:UIControlStateNormal];
    //    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    _messageButton.backgroundColor=[UIColor clearColor];
    [_messageButton addTarget:self action:@selector(messageButtonEvent) forControlEvents:UIControlEventTouchUpInside];
   
     UIBarButtonItem *ba1=[[UIBarButtonItem alloc]initWithCustomView:_collectionButton];
     UIBarButtonItem *ba2=[[UIBarButtonItem alloc]initWithCustomView:_messageButton];
    
    self.navigationItem.rightBarButtonItems = @[ba2,ba1];
    
}

/**
 收藏
 */
-(void)collectionButtonEvent:(UIButton*)sender{
    sender.selected = !sender.selected;
    
}

/**
 消息
 */
-(void)messageButtonEvent{
    
    
}

- (void)addCarouselView1{
    
    //block方式创建
    __weak typeof(self) weakSelf = self;
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray: @[@"eat-picture1",@"eat-picture1"]];
    if (!_carouselView) {
        _carouselView= [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
            carouselConfig.pageContollType = LabelPageControl;
            carouselConfig.interValTime = 3;
            return carouselConfig;
        } clickBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
        }];
        self.tableview.tableHeaderView = _carouselView;
    }
    //开始轮播
    [_carouselView startCarouselWithArray:imageArray];
    
}

@end
