//
//  LBEat_StoreCommentsViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentsViewController.h"
#import "LBEat_StoreCommentHeaderView.h"
#import "GLNearby_classifyCell.h"
#import "LBEat_StoreCommentsTableViewCell.h"
#import "LBEat_StoreCommentFooterView.h"
#import "LBEat_StoreMoreCommentsTableViewCell.h"
#import "LB_Eat'commentDataModel.h"
#import "LB_EatCommentFrameModel.h"
#import "LB_Eat_commentOneDataModel.h"
#import "XHInputView.h"
#import "IQKeyboardManager.h"
#import "LBEat_StoreCommentsdetailViewController.h"

static NSString *eat_StoreCommentsTableViewCell = @"LBEat_StoreCommentsTableViewCell";
static NSString *eat_StoreMoreCommentsTableViewCell = @"LBEat_StoreMoreCommentsTableViewCell";

@interface LBEat_StoreCommentsViewController ()<UITableViewDataSource,UITableViewDelegate,XHInputViewDelagete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic)NSArray *dataArr;

@property (strong , nonatomic)NSMutableArray *commentdataArr;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, assign) NSInteger  allCount;

@end

@implementation LBEat_StoreCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.navigationItem.title = @"评价列表";
    [self.tableview registerNib:[UINib nibWithNibName:eat_StoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:eat_StoreCommentsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_StoreMoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:eat_StoreMoreCommentsTableViewCell];
    
    [self setupNpdata];//设置无数据的时候展示
    
    WeakSelf;
    [self loadData:self.page refreshDirect:YES];
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:self.tableview];
        }else{
            weakSelf.page = weakSelf.page + 1;
            [weakSelf loadData:weakSelf.page refreshDirect:NO];
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

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"store_id"] = self.store_id;
    dic[@"page"] = @(page);
    
    [EasyShowLodingView showLodingText:@"正在加载"];
    [NetworkManager requestPOSTWithURLStr:HappyStore_comment_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            
            if (isDirect) {
                [self.commentdataArr removeAllObjects];
            }
            
            NSArray *arr = [LB_Eat_commentDataModel getIndustryModels:responseObject[@"data"][@"page_data"]];
            NSArray *arr1 = [LB_EatCommentFrameModel getIndustryModels:arr];
            
            [self.commentdataArr addObjectsFromArray:arr1];
            
            
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

    
-(void)showXHInputViewWithStyle:(InputViewStyle)style plaecholderStr:(NSString*)plaecholderStr{
    
    [XHInputView showWithStyle:style configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = plaecholderStr;
        /** 设置最大输入字数 */
        inputView.maxCount = 100;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            

            return YES;//return YES,收起键盘
        }else{
            
            return NO;//return NO,不收键盘
        }
    }];
    
}

#pragma mark - 弹出评论输入框
-(void)showCommentInput:(NSInteger)section{
    
    [self showXHInputViewWithStyle:InputViewStyleLarge plaecholderStr:@"评论"];
   
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.commentdataArr.count; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LB_EatCommentFrameModel *modelF = self.commentdataArr[indexPath.section];
    if ([NSString StringIsNullOrEmpty:modelF.HomeInvestModel.reply] == NO) {
        tableView.estimatedRowHeight = 10;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    LBEat_StoreCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_StoreCommentsTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LB_EatCommentFrameModel *modelF = self.commentdataArr[indexPath.section];
    cell.contentReply = modelF.HomeInvestModel.reply;
    
    if ([NSString StringIsNullOrEmpty:modelF.HomeInvestModel.reply] == NO) {
        cell.hidden =  NO;
    }else{
        cell.hidden =  YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   //LB_Eat_commentOneDataModel *model =   self.commentdataArr[indexPath.row];
    //[self showXHInputViewWithStyle:InputViewStyleLarge plaecholderStr:[NSString stringWithFormat:@"回复%@",model.name]];
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"eat_StoreCommentHeaderView";
    LBEat_StoreCommentHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerview) {
        headerview = [[LBEat_StoreCommentHeaderView alloc]initWithReuseIdentifier:ID];

    }
//    __weak typeof(self) wself = self;
    headerview.HomeInvestModel = self.commentdataArr[section];
    headerview.section = section;
//    headerview.showComments = ^(NSInteger section) {
//        [wself showCommentInput:section];
//    };
//    跳转评论详情
//    headerview.pushCommentsListVc = ^{
//        wself.hidesBottomBarWhenPushed = YES;
//        LBEat_StoreCommentsdetailViewController *vc = [[LBEat_StoreCommentsdetailViewController alloc]init];
//        [wself.navigationController pushViewController:vc animated:YES];
//    };
    
    return headerview;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString *ID = @"eat_StoreCommentFooterView";
    LBEat_StoreCommentFooterView *footerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!footerview) {
        footerview = [[LBEat_StoreCommentFooterView alloc]initWithReuseIdentifier:ID];
    }
    
    return footerview;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    LB_EatCommentFrameModel *frmeModel =self.commentdataArr[section];
    return frmeModel.contentlH;

}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}
-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr  = [[NSArray alloc]init];
    }
    return _dataArr;
}

-(NSMutableArray*)commentdataArr{
    if (!_commentdataArr) {
        _commentdataArr  = [[NSMutableArray alloc]init];
    }
    return _commentdataArr;
}


@end
