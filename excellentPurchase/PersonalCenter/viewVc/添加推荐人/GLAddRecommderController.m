//
//  GLAddRecommderController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddRecommderController.h"
#import "GLIdentifySelectModel.h"
#import "ValuePickerView.h"

@interface GLAddRecommderController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;
@property (weak, nonatomic) IBOutlet UITextField *recommendTF;
@property (weak, nonatomic) IBOutlet UITextField *receiveManGroupTypeTF;//接收人身份
@property (nonatomic, assign)BOOL isverification;//是否验证
@property (nonatomic, copy)NSString *group_id;//被转赠人group_id
@property (nonatomic, strong)NSMutableArray *groupArr;//身份类型
@property (nonatomic, strong)ValuePickerView *pickerView;
@end

@implementation GLAddRecommderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加推荐人";
    
    self.topConstrait.constant = SafeAreaTopHeight;
    
    [self setNav];
}

/**导航栏设置*/
- (void)setNav{

    self.navigationItem.title = @"添加推荐人";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 保存
 */
- (void)save{
    [self.view endEditing:YES];
    
    if(self.recommendTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入你要添加的推荐人ID"];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"user_name"] = self.group_id;
    
    [EasyShowLodingView showLoding];
    
    [NetworkManager requestPOSTWithURLStr:kupdate_tjr paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (self.block) {
                
                self.block(self.recommendTF.text);
            }
            
            [EasyShowTextView showSuccessText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

//验证
- (IBAction)verificationEvent:(UIButton *)sender {
    
    if ([NSString StringIsNullOrEmpty:self.recommendTF.text]) {
        [EasyShowTextView showInfoText:@"请填写接收人"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"info"] = self.recommendTF.text;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    self.isverification = NO;
    [self.groupArr removeAllObjects];
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kUserquery_info paramDic:dic finish:^(id responseObject) {
        self.isverification = YES;
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"验证成功"];
            for (NSDictionary *dict in responseObject[@"data"]) {
                GLIdentifySelectModel *model = [GLIdentifySelectModel mj_objectWithKeyValues:dict];
                [self.groupArr addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
#pragma mark - 身份类型选择
- (IBAction)group_TypeChoose:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.isverification == NO) {
        [EasyShowTextView showInfoText:@"请验证你的身份"];
        return;
    }else{
        if(self.groupArr.count != 0){
            [self popIdentifyChoose];
        }else{
            [EasyShowTextView showInfoText:@"暂无身份信息"];
        }
    }
    
}

- (void)popIdentifyChoose{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLIdentifySelectModel *model in self.groupArr) {
        [arrM addObject:[NSString stringWithFormat:@"%@(%@)",model.truename,model.group_name]];
    }
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"身份类型";
    
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"-"];
        NSInteger index = [stateArr[1] integerValue];
        
        if (index >= 1) {
            
            GLIdentifySelectModel *model = weakSelf.groupArr[index - 1];
            weakSelf.group_id = model.user_name;
        }else{
            weakSelf.group_id = @"";
        }
        
        weakSelf.receiveManGroupTypeTF.text = stateArr[0];
        
    };
    
    [self.pickerView show];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }

    return YES;
}

-(NSMutableArray *)groupArr{
    
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    
    return _groupArr;
}
- (ValuePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[ValuePickerView alloc] init];
    }
    return _pickerView;
}


@end
