
//
//  LBStoreCounterMainViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreCounterMainViewController.h"
#import "LBStoreCounterMaincell.h"
#import "LBStoreCounterViewController.h"
#import "LBAddCounterView.h"
#import "LBAddOrEditProductChooseView.h"

#import "LBEatClassifyModel.h"
#import "GLStoreCounterListModel.h"

@interface LBStoreCounterMainViewController ()<UITableViewDataSource,UITableViewDelegate,LBAddCounterViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong)NSMutableArray *classifyModels;//分类模型
@property (nonatomic, copy)NSString *storeName;//货柜名称
@property (nonatomic, copy)NSString *categoryid;//货柜一级商品分类
@property (nonatomic, copy)NSString *categorypid;//货柜二级商品分类

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@end

static NSString *ID = @"LBStoreCounterMaincell";

@implementation LBStoreCounterMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNav];
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self setupNpdata];//设置无数据的时候展示
  
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];

    
}

//刷新
-(void)refresh{
    [self postRequest:YES];
}

/**
 设置无数据图
 */
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
        [weakSelf postRequest:YES];
    }];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"store_id"] = self.store_id;
    
    [NetworkManager requestPOSTWithURLStr:kcontainer_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLStoreCounterListModel *model = [GLStoreCounterListModel mj_objectWithKeyValues:dict];
                [self.models addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableview reloadData];
        
    }];
}


#pragma mark - 设置导航栏

- (void)setNav{
    self.navigationItem.title = @"货柜管理";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [button setTitle:@"添加货柜" forState:UIControlStateNormal];
    [button setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(addCounter) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = ba;
}

/**
 添加货柜
 */
-(void)addCounter{
    
    WeakSelf;
    [LBAddCounterView addCounterFrame:self.view.frame delegate:self textfBloack:^(NSString *textfiled) {
        weakSelf.storeName = textfiled;
        
        [weakSelf addCounterRequest];
    }];
}
// 添加货柜 请求
- (void)addCounterRequest{
    
    [self.view endEditing:YES];
    if (self.store_id.length == 0) {
        [EasyShowTextView showInfoText:@"商铺id获取失败,请返回上一页重新获取"];
        return;
    }
    
    if (self.storeName.length == 0) {
        [EasyShowTextView showInfoText:@"请填写货柜名字"];
        return;
    }
    
    if (self.categoryid.length == 0 || self.categorypid.length == 0) {
        [EasyShowTextView showInfoText:@"请选择货柜类型"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"store_id"] = self.store_id;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"name"] = self.storeName;
    dic[@"categoryid"] = self.categoryid;
    dic[@"categorypid"] = self.categorypid;

    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kappend_container paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"货柜添加成功"];
            [self postRequest:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
/**
 弹出分类
 */
- (void)popClassifyView:(void (^)(NSString *))filedBlock{

    [self.view endEditing:YES];
    
    if(self.classifyModels.count != 0){
        [self popClassifyV:filedBlock];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:HappyCateData paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                LBEatClassifyModel *model = [LBEatClassifyModel mj_objectWithKeyValues:dict];
                [self.classifyModels addObject:model];
            }
            [self popClassifyV:filedBlock];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];

}

- (void)popClassifyV:(void (^)(NSString *))filedBlock{
    
    WeakSelf;
    [LBAddOrEditProductChooseView showWholeClassifyViewWith:weakSelf.classifyModels Block:^(NSInteger section,NSInteger row) {
        
        LBEatClassifyModel *model = weakSelf.classifyModels[section];
        LBEatTwoClassifyModel *two_model = model.two_cate[row];

        weakSelf.categoryid = model.cate_id;
        weakSelf.categorypid = two_model.cate_id;
        
        NSString *str = [NSString stringWithFormat:@"%@%@",model.catename,two_model.catename];
        
        if (filedBlock) {
            filedBlock(str);
        }
        
    } cancelBlock:^{
        
    }];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.models.count; //返回值是多少既有几个分区
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 55;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LBStoreCounterMaincell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLStoreCounterListModel *model = self.models[indexPath.section];
    self.hidesBottomBarWhenPushed = YES;
    LBStoreCounterViewController *vc = [[LBStoreCounterViewController alloc]init];
    vc.store_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerLabel;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - 懒加载
- (NSMutableArray *)classifyModels{
    if (!_classifyModels) {
        _classifyModels = [NSMutableArray array];
    }
    return _classifyModels;
}

-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
}


@end
