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

@property (strong , nonatomic)NSArray *commentdataArr;


@end

@implementation LBEat_StoreCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价列表";
    [self.tableview registerNib:[UINib nibWithNibName:eat_StoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:eat_StoreCommentsTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_StoreMoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:eat_StoreMoreCommentsTableViewCell];
    
    NSArray  *arr = [LB_Eat_commentDataModel getIndustryModels:@[@{@"content":@"我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓"},@{@"content":@"我觉得从前我非常浓无法 i 超浓"},@{@"content":@"我觉得从前我非常浓无法 i "},@{@"content":@"我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓我觉得从前我非常浓无法 i 超浓"}]];
    
    self.dataArr = [LB_EatCommentFrameModel getIndustryModels:arr];
    
    NSArray *arr1 = @[@{@"content":@"sddssssevfewvg为哦供暖费更年期鞥为苹果 v 年轻阿房宫你",@"name":@"hhh",@"replyname":@"wdwd"},
                                   @{@"content":@"sddssss",@"name":@"hhh",@"replyname":@"wdwd"},
                                   @{@"content":@"sddssss",@"name":@"hhh",@"replyname":@"wdwd"},
                                   @{@"content":@"sddssss",@"name":@"hhh",@"replyname":@"wdwd"}];
    self.commentdataArr = [LB_Eat_commentOneDataModel getIndustryModels:arr1];
    
     [self.tableview reloadData];
    

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
    return 4; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        return 30;
    }
    tableView.estimatedRowHeight = 10;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        LBEat_StoreMoreCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_StoreMoreCommentsTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    LBEat_StoreCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_StoreCommentsTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.commentdataArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   LB_Eat_commentOneDataModel *model =   self.commentdataArr[indexPath.row];
    [self showXHInputViewWithStyle:InputViewStyleLarge plaecholderStr:[NSString stringWithFormat:@"回复%@",model.name]];
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"eat_StoreCommentHeaderView";
    LBEat_StoreCommentHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerview) {
        headerview = [[LBEat_StoreCommentHeaderView alloc]initWithReuseIdentifier:ID];

    }
    __weak typeof(self) wself = self;
    headerview.HomeInvestModel = self.dataArr[section];
    headerview.section = section;
    headerview.showComments = ^(NSInteger section) {
        [wself showCommentInput:section];
    };
//    跳转评论详情
    headerview.pushCommentsListVc = ^{
        wself.hidesBottomBarWhenPushed = YES;
        LBEat_StoreCommentsdetailViewController *vc = [[LBEat_StoreCommentsdetailViewController alloc]init];
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
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
    LB_EatCommentFrameModel *frmeModel =self.dataArr[section];
    return frmeModel.contentlH;

}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 25;
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

-(NSArray*)commentdataArr{
    if (!_commentdataArr) {
        _commentdataArr  = [[NSArray alloc]init];
    }
    return _commentdataArr;
}


@end
