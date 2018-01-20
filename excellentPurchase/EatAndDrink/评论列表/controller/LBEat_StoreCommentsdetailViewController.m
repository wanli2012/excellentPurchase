//
//  LBEat_StoreCommentsdetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentsdetailViewController.h"
#import "LBEat_StoredetailCommentsTableViewCell.h"
#import "LBEat_StoreCommentHeaderView.h"
#import "XHInputView.h"
#import "IQKeyboardManager.h"

@interface LBEat_StoreCommentsdetailViewController ()<UITableViewDataSource,UITableViewDelegate,XHInputViewDelagete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *eat_StoredetailCommentsTableViewCell = @"LBEat_StoredetailCommentsTableViewCell";

@implementation LBEat_StoreCommentsdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价列表";
    [self.tableview registerNib:[UINib nibWithNibName:eat_StoredetailCommentsTableViewCell bundle:nil] forCellReuseIdentifier:eat_StoredetailCommentsTableViewCell];
    
    
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
    return 1; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.estimatedRowHeight = 10;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LBEat_StoredetailCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_StoredetailCommentsTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    LB_Eat_commentOneDataModel *model =   self.commentdataArr[indexPath.row];
//    [self showXHInputViewWithStyle:InputViewStyleLarge plaecholderStr:[NSString stringWithFormat:@"回复%@",model.name]];
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"eat_StoreCommentHeaderView";
    LBEat_StoreCommentHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerview) {
        headerview = [[LBEat_StoreCommentHeaderView alloc]initWithReuseIdentifier:ID];
        
    }
    __weak typeof(self) wself = self;
    headerview.section = section;
    headerview.showComments = ^(NSInteger section) {
        [wself showCommentInput:section];
    };
    headerview.pushCommentsListVc = ^{
        
    };
    
    return headerview;
    
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

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
//    LB_EatCommentFrameModel *frmeModel =self.dataArr[section];
//    return frmeModel.contentlH;
    return 120;
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}
@end
