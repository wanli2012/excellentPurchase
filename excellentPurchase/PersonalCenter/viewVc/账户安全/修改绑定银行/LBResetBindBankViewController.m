//
//  LBResetBindBankViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBResetBindBankViewController.h"
#import "LBResetBindBankTableViewCell.h"
#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"

@interface LBResetBindBankViewController ()<UITableViewDelegate,UITableViewDataSource,LBResetBindBankDelegate,HCBasePopupViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
/**
 数据
 */
@property (strong, nonatomic) NSArray *dataArr;
@end

static NSString *resetBindBankTableViewCell = @"LBResetBindBankTableViewCell";

@implementation LBResetBindBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡管理";
    self.navigationController.navigationBar.hidden = NO;
    [self.tableview setTableFooterView:[UIView new]];
    
//注册cell
[self.tableview registerNib:[UINib nibWithNibName:resetBindBankTableViewCell bundle:nil] forCellReuseIdentifier:resetBindBankTableViewCell];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBResetBindBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resetBindBankTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexpath = indexPath;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ---- LBResetBindBankDelegate   解除绑定
-(void)relieveBindBankCard:(NSIndexPath *)indexpath{
    
    HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];

    HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"解除绑定后银行服务器将不可用" withSelectedBlock:^{

    } withType:HCBottomPopupActionSelectItemTypeDefault];
    HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"确定解除绑定" withSelectedBlock:^{
        NSLog(@"点击选项2");
    } withType:HCBottomPopupActionSelectItemTypeDefault];
    
    HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
    
    [pc addAction:action1];
    [pc addAction:action2];
     [pc addAction:action4];
    
     [self presentViewController:pc animated:YES completion:nil];
    
}

#pragma mark - HCBasePopupViewControllerDelegate 个协议方法来自定义你的弹出框内容
- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller{
  
}

- (void)didTapMaskViewWithMaskView:(UIView *)maskView withController:(UIViewController *)controller{

}

@end
