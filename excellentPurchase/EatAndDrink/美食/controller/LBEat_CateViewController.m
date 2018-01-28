//
//  LBEat_CateViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/16.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_CateViewController.h"
#import "JYCarousel.h"
#import "JYImageCache.h"
#import "GLIntegralHeaderView.h"
#import "LBBurstingWithPopularityTableViewCell.h"
#import "GLNearby_classifyCell.h"
#import "LBFinishMainViewController.h"
#import "LBEatAndDrinkViewController.h"
#import "LBEatShopProdcutClassifyViewController.h"//商店详情
#import "LBFinishMainViewController.h"


static NSString *burstingWithPopularityTableViewCell = @"LBBurstingWithPopularityTableViewCell";
static NSString *nearby_classifyCell = @"GLNearby_classifyCell";

@interface LBEat_CateViewController ()<JYCarouselDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 头部轮播
 */
@property (nonatomic, strong) JYCarousel *carouselView;

@end

/**
 头部视图的图片比例

 */
#define carouselViewHScle 242.0/750

@implementation LBEat_CateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addCarouselView1];
    [self.tableView registerNib:[UINib nibWithNibName:burstingWithPopularityTableViewCell bundle:nil] forCellReuseIdentifier:burstingWithPopularityTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:nearby_classifyCell bundle:nil] forCellReuseIdentifier:nearby_classifyCell];
    
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        NSLog(@"1111");
    } footerRefresh:^{
        NSLog(@"2222");
    }];
    
    [LBDefineRefrsh dismissRefresh:self.tableView];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  (UIScreenWidth - 36)/3.0 * EatrecommendScle + 25;
    }else if (indexPath.section == 1){
        return EatCellH;
    }
    return 0;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBBurstingWithPopularityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:burstingWithPopularityTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:nearby_classifyCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    GLIntegralHeaderView *headerLabel = [[NSBundle mainBundle]loadNibNamed:@"GLIntegralHeaderView" owner:self options:nil].firstObject;
    
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBFinishMainViewController *vc = [[LBFinishMainViewController alloc]init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
    [self viewController].hidesBottomBarWhenPushed = NO;
  
}

- (void)addCarouselView1{
    
    //block方式创建
    __weak typeof(self) weakSelf = self;
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray: @[@"eat-banner",@"eat-banner"]];
    if (!_carouselView) {
        _carouselView= [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth * carouselViewHScle) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
            carouselConfig.pageContollType = RightPageControl;
            carouselConfig.interValTime = 3;
            return carouselConfig;
        } clickBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
        }];
        self.tableView.tableHeaderView = _carouselView;
    }
    //开始轮播
    [_carouselView startCarouselWithArray:imageArray];
    
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
@end
