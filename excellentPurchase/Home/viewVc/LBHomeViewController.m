//
//  LBHomeViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewController.h"
#import "GLNearby_ClassifyHeaderView.h"
#import "LBHorseGroupTableViewCell.h"
#import "LBImmediateRushBuyCell.h"
#import "UIImage+GIF.h"

#import "LBSetUpViewController.h"

@interface LBHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;//导航栏高度
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *navigationView;//自定义导航栏
@property (weak, nonatomic) IBOutlet UIView *searchView;//自定义搜索view
@property (strong, nonatomic)GLNearby_ClassifyHeaderView *classfyHeaderV;//自定义头部视图
@property (strong, nonatomic)NSArray *tradeArr;//分类数据数组
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;//底部活动图片

@end

static NSString *horseGroupTableViewCell = @"LBHorseGroupTableViewCell";
static NSString *immediateRushBuyCell = @"LBImmediateRushBuyCell";

@implementation LBHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
    self.searchView.layer.cornerRadius = 15;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.tableview registerNib:[UINib nibWithNibName:immediateRushBuyCell bundle:nil] forCellReuseIdentifier:immediateRushBuyCell];
    
    adjustsScrollViewInsets_NO(self.tableview, self);
    self.tableview.tableHeaderView = self.classfyHeaderV;
    
    self.tradeArr = @[@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"}];
    [self.classfyHeaderV initdatasorece:self.tradeArr];
    //   底部视图高度
    self.tableview.tableFooterView.height = UIScreenWidth * bottomScale + 20 ;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *path = [[NSBundle mainBundle] pathForResource:@"activity" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            self.activityImage.image = image;
        });
        
    });
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return bannerHeiget;
    }else if (indexPath.section == 1){
        return 130 * 2 + 1;
    }
    return 0;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        LBHorseGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:horseGroupTableViewCell];
        // 判断cell是否存在
        if (!cell) {
            cell = [[LBHorseGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:horseGroupTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        LBImmediateRushBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:immediateRushBuyCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    LBSetUpViewController *vc =[[LBSetUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat   offset = scrollView.contentOffset.y;
    if (offset < 0) {
        self.navigationView.hidden = YES;
    }else{
        self.navigationView.hidden = NO;
    }
    
}

-(GLNearby_ClassifyHeaderView*)classfyHeaderV{
    
    if (!_classfyHeaderV) {
        _classfyHeaderV = [[GLNearby_ClassifyHeaderView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 155 + UIScreenWidth * bannerScale) withDataArr:self.tradeArr];
        _classfyHeaderV.autoresizingMask = UIViewAutoresizingNone;
      //  _classfyHeaderV.delegete = self;
    }
    return _classfyHeaderV;
}
-(NSArray*)tradeArr{
    
    if (!_tradeArr) {
        _tradeArr = [NSArray array];
    }
    return _tradeArr;
}

@end
