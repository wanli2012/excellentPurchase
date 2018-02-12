//
//  LBSwitchAccountViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSwitchAccountViewController.h"
#import "LBSwitchAccountTableViewCell.h"

#import "GLAccountModel.h"//数据库模型

#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"

@interface LBSwitchAccountViewController ()
{
    BOOL _isCanClick;//是否可以点击cell
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) GLAccountModel *projiectmodel;//综合项目本地保存
@property (nonatomic, strong)NSMutableArray *fmdbArr;

@property (nonatomic, strong)NSMutableArray *boolArr;

@end

static NSString *switchAccountTableViewCell = @"LBSwitchAccountTableViewCell";

@implementation LBSwitchAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"帐号管理";
    self.navigationController.navigationBar.hidden = NO;
    
    [self setupNpdata];//设置无数据的时候展示

    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:switchAccountTableViewCell bundle:nil] forCellReuseIdentifier:switchAccountTableViewCell];
    
    _isCanClick = YES;//cell默认设置可以点击
    
    [self getFmdbDatasoruce];//获取数据库信息
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
        [weakSelf getFmdbDatasoruce];
    }];
}

- (void)getFmdbDatasoruce{
    //获取本地搜索记录
    _projiectmodel = [GLAccountModel greateTableOfFMWithTableName:@"GLAccountModel"];
    
    self.fmdbArr = [NSMutableArray arrayWithArray:[_projiectmodel queryAllDataOfFMDB]];

    
    [self.tableview reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fmdbArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSwitchAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchAccountTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.fmdbArr[indexPath.row];
    
    [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"headPic"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    cell.IDNumberLabel.text = dic[@"userName"];
    cell.groupNameLabel.text = dic[@"groupName"];
    
    cell.phoneLabel.text = dic[@"phone"];
    NSString *str = dic[@"nickName"];
    
    if(str.length == 0){
        
        str = [NSString stringWithFormat:@"昵称:(未设置)"];
        
    }else{
        
        str = dic[@"nickName"];
    }
    
    cell.nickNameLabel.text = str;
    
    BOOL isSelf = [self.boolArr[indexPath.row] boolValue];
    
    if([dic[@"userName"] isEqualToString:[UserModel defaultUser].user_name]){
        isSelf = YES;
        [self.boolArr replaceObjectAtIndex:indexPath.row withObject:@(isSelf)];
    }
    
    
    if([self.boolArr[indexPath.row] boolValue]){
        cell.isSelfBtn.hidden = NO;
    }else{
        cell.isSelfBtn.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.fmdbArr[indexPath.row];
    
    if (_isCanClick) {
        
        if (![dic[@"userName"] isEqualToString:[UserModel defaultUser].user_name]) {
            
            [self login:self.fmdbArr[indexPath.row]];
        }
    }
}

//指定哪些行的 cell 可以进行编辑 (UITableViewDataSource 协议方法)
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return UITableViewCellEditingStyleDelete;
  
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**   点击 删除 按钮的操作 */
    if (editingStyle == UITableViewCellEditingStyleDelete) { /**< 判断编辑状态是删除时. */
 
        HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
   
        __weak typeof(self) wself = self;
        HCBottomPopupAction * action0 = [HCBottomPopupAction actionWithTitle:@"你确定要删除吗?" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
        
        HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"确定" withSelectedBlock:^{
            
            [wself.fmdbArr removeObjectAtIndex:indexPath.row];
            
            NSSet *set = [NSSet setWithArray:self.fmdbArr];
            NSArray *arr = [set allObjects];
            
            [_projiectmodel deleteAllDataOfFMDB];
            [_projiectmodel insertOfFMWithDataArray:arr];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
 
        } withType:HCBottomPopupActionSelectItemTypeDefault];
        
        HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
        
        [pc addAction:action0];
        
        [pc addAction:action1];

        [pc addAction:action4];
        
        [self presentViewController:pc animated:YES completion:nil];

    }
    
}

- (void)login:(NSDictionary *)dataDic{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"phone"] = dataDic[@"phone"];
    dict[@"group_id"] = dataDic[@"groupID"];
    dict[@"password"] = [RSAEncryptor encryptString:dataDic[@"password"] publicKey:public_RSA];

    [EasyShowLodingView showLodingText:@"登录中..."];
    _isCanClick = NO;
    
    [NetworkManager requestPOSTWithURLStr:kLOGIN_URL paramDic:dict finish:^(id responseObject) {
        _isCanClick = YES;
        [EasyShowLodingView hidenLoding];
    
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = YES;
            
            [UserModel defaultUser].token = [self judgeStringIsNull:responseObject[@"data"][@"token"]  andDefault:NO];
            [UserModel defaultUser].uid = [self judgeStringIsNull:responseObject[@"data"][@"uid"]   andDefault:NO];
            [UserModel defaultUser].user_name = [self judgeStringIsNull:responseObject[@"data"][@"user_name"] andDefault:NO];
            [UserModel defaultUser].group_id = [self judgeStringIsNull:responseObject[@"data"][@"group_id"] andDefault:NO];
            [UserModel defaultUser].group_name = [self judgeStringIsNull:responseObject[@"data"][@"group_name"] andDefault:NO];
            
            [UserModel defaultUser].phone = [self judgeStringIsNull:responseObject[@"data"][@"phone"] andDefault:NO];
            [UserModel defaultUser].pic = [self judgeStringIsNull:responseObject[@"data"][@"pic"] andDefault:NO];
            [UserModel defaultUser].truename = [self judgeStringIsNull:responseObject[@"data"][@"truename"] andDefault:NO];
            [UserModel defaultUser].im_id = [self judgeStringIsNull:responseObject[@"data"][@"im_id"] andDefault:NO];
            [UserModel defaultUser].im_token = [self judgeStringIsNull:responseObject[@"data"][@"im_token"] andDefault:NO];
            [UserModel defaultUser].nick_name = [self judgeStringIsNull:responseObject[@"data"][@"nick_name"] andDefault:NO];
            [UserModel defaultUser].rzstatus = [self judgeStringIsNull:responseObject[@"data"][@"rzstatus"] andDefault:NO];
            [UserModel defaultUser].del = [self judgeStringIsNull:responseObject[@"data"][@"del"] andDefault:NO];
            [UserModel defaultUser].tjr_group = [self judgeStringIsNull:responseObject[@"data"][@"tjr_group"] andDefault:NO];
            [UserModel defaultUser].tjr_name = [self judgeStringIsNull:responseObject[@"data"][@"tjr_name"] andDefault:NO];
            [UserModel defaultUser].mark = [self judgeStringIsNull:responseObject[@"data"][@"mark"] andDefault:YES];
            [UserModel defaultUser].balance = [self judgeStringIsNull:responseObject[@"data"][@"balance"] andDefault:YES];
            [UserModel defaultUser].keti_bean = [self judgeStringIsNull:responseObject[@"data"][@"keti_bean"] andDefault:YES];
            [UserModel defaultUser].shopping_voucher = [self judgeStringIsNull:responseObject[@"data"][@"shopping_voucher"] andDefault:YES];
            [UserModel defaultUser].cion_price = [self judgeStringIsNull:responseObject[@"data"][@"cion_price"] andDefault:YES];
            [UserModel defaultUser].voucher_ratio = [self judgeStringIsNull:responseObject[@"data"][@"voucher_ratio"] andDefault:YES];
            
            [usermodelachivar achive];
    
            NSDictionary *newDic = @{@"headPic":[UserModel defaultUser].pic,
                                      @"userName":[UserModel defaultUser].user_name,
                                      @"phone":[UserModel defaultUser].phone,
                                      @"password":dataDic[@"password"],
                                      @"groupID":[UserModel defaultUser].group_id,
                                      @"groupName":[UserModel defaultUser].group_name,
                                      @"nickName":[UserModel defaultUser].nick_name,
                                      };
            
            for (int i = 0; i < self.fmdbArr.count; i++) {
                NSDictionary *tempDic = self.fmdbArr[i];
                if ([tempDic[@"userName"] isEqualToString:newDic[@"userName"]]) {
                    [self.fmdbArr removeObject:tempDic];
                }
            }
            
            [self.fmdbArr insertObject:newDic atIndex:0];
            NSSet *set = [NSSet setWithArray:self.fmdbArr];
            NSArray *arr = [set allObjects];
            
            [_projiectmodel deleteAllDataOfFMDB];
            [_projiectmodel insertOfFMWithDataArray:arr];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        _isCanClick = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

//判空 给数字设置默认值
- (NSString *)judgeStringIsNull:(id )sender andDefault:(BOOL)isNeedDefault{
    
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    
    if ([NSString StringIsNullOrEmpty:str]) {
        
        if (isNeedDefault) {
            return @"0.00";
        }else{
            return @"";
            
        }
    }else{
        return str;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)fmdbArr{
    if (!_fmdbArr) {
        _fmdbArr = [NSMutableArray array];
    }
    return _fmdbArr;
}

- (NSMutableArray *)boolArr{
    if (!_boolArr) {
        _boolArr = [NSMutableArray array];
        for (int i = 0; i < self.fmdbArr.count; i ++) {
            BOOL isSelf = NO;
            [_boolArr addObject:@(isSelf)];
        }
    }
    
    return _boolArr;
}

@end
