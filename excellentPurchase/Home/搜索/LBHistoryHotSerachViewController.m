//
//  LBHistoryHotSerachViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHistoryHotSerachViewController.h"
#import "XC_label.h"
#import "GLNearby_classifyCell.h"
#import "LBSaveLocationInfoModel.h"
#import "LBHistoryHotSerachDataBase.h"
#import "LBEat_StoreDetailViewController.h"

@interface LBHistoryHotSerachViewController ()<selectHotOrHistoryDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) XC_label  *xcLabel ;

@property (nonatomic,strong)NSMutableArray *reCommendSource ;//推荐搜索

@property (nonatomic,strong)NSMutableArray *historySource ;//历史搜索

@property (nonatomic,strong)NSMutableArray *dataSource ;//数据源
@property (nonatomic,strong)LBHistoryHotSerachDataBase *DataBase ;//历史数据源

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *keyTextfiled;

@property (nonatomic,strong)NSString *key ;//关键字
@property (nonatomic,assign)NSInteger page ;//页数

@end

static NSString *nearby_classifyCell = @"GLNearby_classifyCell";

@implementation LBHistoryHotSerachViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.navigationController.navigationBar.hidden = YES ;
    [self.tableview registerNib:[UINib nibWithNibName:nearby_classifyCell bundle:nil] forCellReuseIdentifier:nearby_classifyCell];
    self.tableview.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf searchKeySource:YES];
    } footerRefresh:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf searchKeySource:NO];
    }];
    
    if (self.type == 1) {
        
    }else if (self.type == 2){
        [self loadData];//加载数据
    }else if (self.type == 3){
        
    }
}
//获取数据
-(void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    WeakSelf;
    [NetworkManager requestPOSTWithURLStr:HappyHotSearch paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                [weakSelf.reCommendSource addObject:dic[@"content"]];
            }
            [weakSelf hotOptions ];

        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

//搜索
-(void)searchKeySource:(BOOL)isrefresh{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"name"] = self.key;
    dic[@"lng"] = [LBSaveLocationInfoModel defaultUser].strLongitude;
    dic[@"lat"] = [LBSaveLocationInfoModel defaultUser].strLatitude;
    dic[@"page"] = @(self.page);
    WeakSelf;
    [NetworkManager requestPOSTWithURLStr:HappySearchPlay paramDic:dic finish:^(id responseObject) {
  
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
    
            //搜索了关键字 ，就需要历史记录添加进去
            [_xcLabel insertHistorOptions:self.key];
            
            if (isrefresh) {
                [self.dataSource removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBEat_cateDataModel *model = [LBEat_cateDataModel mj_objectWithKeyValues:dic];
                [self.dataSource addObject:model];
            }
            
            if (self.dataSource.count  <= 0) {
                 [EasyShowTextView showErrorText:@"未找到相关信息"];
            }else{
                self.tableview.hidden = NO;
                self.xcLabel.hidden = YES;
            }
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [LBDefineRefrsh dismissRefresh:weakSelf.tableview];
    } enError:^(NSError *error) {
         [LBDefineRefrsh dismissRefresh:weakSelf.tableview];
    }];
    
}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength == 0) {
        _xcLabel.hidden = NO;
        _tableview.hidden = YES;

    }
    
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        self.key = textField.text;
        self.page = 1;
        [self searchKeySource:YES];
        
        return NO;
    }
    
    return YES;
}

-(void)hotOptions
{
   
    //获取本地搜索记录
    self.DataBase = [LBHistoryHotSerachDataBase greateTableOfFMWithTableName:@"LBHistoryHotSerachViewController"];
    if ([self.DataBase isDataInTheTable]) {
        [self.historySource removeAllObjects];
        for (int i = 0; i < [[self.DataBase queryAllDataOfFMDB]count]; i++) {
            [self.historySource addObject:[_DataBase queryAllDataOfFMDB][i]];
        }
    }
    
    _xcLabel = [[XC_label alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight-SafeAreaTopHeight) AndTitleArr:self.reCommendSource AndhistoryArr:self.historySource AndTitleFont:14 AndScrollDirection:UICollectionViewScrollDirectionVertical];
    _xcLabel.delegate = self ;
    _xcLabel.opetionsHeight = 30;
    _xcLabel.isShow_One = YES ;  //默认NO 显示
    _xcLabel.isShow_Two = NO ; //默认NO 显示
    _xcLabel.headTitle_one = @"热门搜索";
    _xcLabel.headTitle_two = @"历史搜索";
    
    [self.view addSubview:_xcLabel];
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return EatCellH;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:nearby_classifyCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    LBEat_StoreDetailViewController *vc = [[LBEat_StoreDetailViewController alloc]init];
    vc.store_id = ((LBEat_cateDataModel*)self.dataSource[indexPath.section]).store_id;
    vc.titilestr = ((LBEat_cateDataModel*)self.dataSource[indexPath.section]).store_name;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark selectHotOrHistoryDelegate
//选中某个选项
-(void)selectHotOrHistory:(NSString *)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString *)selectTitle{
    [self.view endEditing:YES];
    self.key = selectTitle;
    [self searchKeySource:YES];
    //这里是选中某个选项， 主要处理跳转逻辑
}

//删除历史选项
-(void)deleteHistoryOptions:(NSString *)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString * _Nullable)selectTitle AndNSdataSource:(NSMutableArray * _Nullable)dataSource{
    [self.view endEditing:YES];
    
    [_DataBase deleteAllDataOfFMDB];
    [_DataBase insertOfFMWithDataArray:dataSource];

    //这里可以删除本地数据 逻辑 UI 已经处理好了。只需要删除暴露在外面对应的数据源就可以了
    
}

-(void)returnHistoryDataArr:(NSArray *)historyArr{
    
    NSSet *set = [NSSet setWithArray:historyArr];
    // 3.2集合转换为数组
    NSArray * changeArray2 = [set allObjects];
    
    [_DataBase deleteAllDataOfFMDB];
    [_DataBase insertOfFMWithDataArray:changeArray2];
    
}

//删除热搜选项
-(void)deleteHotOptions:(NSString * _Nullable)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString * _Nullable)selectTitle AndNSdataSource:(NSMutableArray *_Nullable)dataSource
{
    
    //这里可以删除热搜数据 逻辑 UI 已经处理好了。只需要删除暴露在外面对应的数据源就可以了
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark Xc_serchViewCilckBtn
-(void)cilckCancle{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchresult:(NSString *)resultString{
    
    [self.view endEditing:YES];
    

    //1 ,这里做去重复逻辑
    
    //2 ,去重复逻辑之后直接丢字符串进去，已经处理好了
    
    //搜索了关键字 ，就需要历史记录添加进去
    [_xcLabel insertHistorOptions:resultString];
}

-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

-(NSMutableArray*)reCommendSource{
    if (!_reCommendSource) {
        _reCommendSource = [NSMutableArray array];
        
    }
    return _reCommendSource;
}

-(NSMutableArray*)historySource{
    if (!_historySource) {
        _historySource = [NSMutableArray array];
        
    }
    return _historySource;
}

@end
