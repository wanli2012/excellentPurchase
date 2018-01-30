//
//  LBEat_StoreClassifyViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreClassifyViewController.h"
#import "GLNearby_classifyCell.h"
#import "LBEat_ActivityFooterView.h"
#import "LBSaveLocationInfoModel.h"
#import "LBEat_StoreDetailViewController.h"
#import "ReactiveCocoa.h"

@interface LBEat_StoreClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (nonatomic, strong) NSMutableArray *dataArr;//数据源
@property (nonatomic, assign) NSInteger  allCount;//总数
@property (nonatomic, assign) NSInteger  page;//页数
@property (nonatomic, assign) NSInteger  hot;//1热门升序 2热门倒叙
@property (nonatomic, assign) NSInteger  nice;//1好评升序 2好评倒叙
@property (nonatomic, strong) NSString *keyWord;//关键字

@property (weak, nonatomic) IBOutlet UIButton *intelligentBt;
@property (weak, nonatomic) IBOutlet UIButton *hotBt;
@property (weak, nonatomic) IBOutlet UIButton *replayBt;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (strong, nonatomic) UIButton *currentbt;

@end

static NSString *nearby_classifyCell = @"GLNearby_classifyCell";

@implementation LBEat_StoreClassifyViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerNib:[UINib nibWithNibName:nearby_classifyCell bundle:nil] forCellReuseIdentifier:nearby_classifyCell];
    self.page = 1;
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
    
    self.currentbt = self.intelligentBt;
    self.currentbt.selected = YES;
    
    self.searchTf.placeholder = self.cate_name;
    
    [[self.searchTf rac_textSignal]subscribeNext:^(NSString *x) {
        
        if (x.length <= 0) {
            self.keyWord = x;
            self.page = 1;
            [self loadData:1 refreshDirect:YES];
        }
        
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
        weakSelf.page = 1;
        [self loadData:weakSelf.page refreshDirect:YES];
    }];
}

-(void)setuprefrsh{
    [self loadData:1 refreshDirect:YES];
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:self.tableview];
        }else{
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
        }
    }];
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"lng"] = [LBSaveLocationInfoModel defaultUser].strLongitude;
    dic[@"lat"] = [LBSaveLocationInfoModel defaultUser].strLatitude;
    dic[@"page"] = @(page);
    
    if (self.hot == 2) {
        dic[@"hot"] = @(self.hot);
    }
    
    if (self.nice==2) {
        dic[@"nice"] = @(self.nice);
    }
    
    if ([NSString StringIsNullOrEmpty:self.keyWord] == NO) {
        dic[@"name"] = self.keyWord;
    }else{
        dic[@"cate_id"] = self.cate_id;
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:HappySearchPlay paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            
            if (isDirect) {
                if (self.allCount == 0) {
                    [EasyShowTextView showText:@"未找到相关信息"];
                }
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBEat_cateDataModel *model = [LBEat_cateDataModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}
//智能排序
- (IBAction)intelligentSortingEvent:(UIButton *)sender {
    self.hot = 0;
    self.nice = 0;
    sender.selected = YES;
    self.currentbt.selected = NO;
    self.currentbt = sender;
      [self loadData:1 refreshDirect:YES];
}
//热门
- (IBAction)hotSortingEvent:(UIButton *)sender {
    self.hot = 2;
    sender.selected = YES;
    self.currentbt.selected = NO;
    self.currentbt = sender;
      [self loadData:1 refreshDirect:YES];
}
//好评
- (IBAction)replaySortingEvent:(UIButton *)sender {
    self.nice = 2;
    sender.selected = YES;
    self.currentbt.selected = NO;
    self.currentbt = sender;
      [self loadData:1 refreshDirect:YES];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.dataArr.count; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    
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
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:true];
    self.hidesBottomBarWhenPushed = YES;
    LBEat_StoreDetailViewController *vc = [[LBEat_StoreDetailViewController alloc]init];
    vc.store_id = ((LBEat_cateDataModel*)self.dataArr[indexPath.section]).store_id;
    vc.title = ((LBEat_cateDataModel*)self.dataArr[indexPath.section]).store_name;
    [self.navigationController pushViewController:vc animated:YES];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength == 0) {
        [textField endEditing:YES];
        self.keyWord = @"";
        [EasyShowTextView showText:@"请输入关键字查询"];
    }
    
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        self.keyWord = textField.text;
        self.page = 1;
        [self loadData:1 refreshDirect:YES];
        
        return NO;
    }
    
    return YES;
    
}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
}

-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
    
}

@end
