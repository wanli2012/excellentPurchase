//
//  GLMine_Team_StaffingController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_StaffingController.h"
#import "GLMine_Team_OpenSetModel.h"

@interface GLMine_Team_StaffingController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

//市级代理
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *citySignLabel;
@property (weak, nonatomic) IBOutlet UITextField *cityNumTF;
//区级代理
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *areaSignLabel;
@property (weak, nonatomic) IBOutlet UITextField *areaNumTF;
//城市创客
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityMakerViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *cityMakerNumTF;
@property (weak, nonatomic) IBOutlet UILabel *cityMakerSignLabel;
//大区创客
@property (weak, nonatomic) IBOutlet UITextField *daquMakerNumTF;
@property (weak, nonatomic) IBOutlet UILabel *daquMakerSignLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *daquMakerViewHeight;
//创客
@property (weak, nonatomic) IBOutlet UITextField *makerNumTF;
@property (weak, nonatomic) IBOutlet UILabel *makerSignLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makerViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong)GLMine_Team_OpenSet_subModel *model;
@property (nonatomic, strong)NSMutableArray <GLMine_Team_OpenSet_subModel *>*models;

@end

@implementation GLMine_Team_StaffingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"人员配置";
    self.contentViewHeight.constant = UIScreenHeight - SafeAreaTopHeight;
    
    [self requestPost];
}

#pragma mark - 请求下级可设置数据
- (void)requestPost{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kappend_subordinate paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.models removeAllObjects];
            self.model = nil;
            
            if ([responseObject[@"data"][@"setup"] count] != 0) {
                
                for (NSDictionary *dict in responseObject[@"data"][@"setup"]) {
                    GLMine_Team_OpenSet_subModel *model = [GLMine_Team_OpenSet_subModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
                
                GLMine_Team_OpenSet_subModel *model = [GLMine_Team_OpenSet_subModel mj_objectWithKeyValues:responseObject[@"data"][@"sub"][0]];
                
                self.model = model;
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }

        [self assignment];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 赋值
- (void)assignment{
    
    if([self.model.group_id integerValue] == 6){//大区创客
        return;
    }
    
    switch ([self.model.group_id integerValue]) {
 
        case 2://省级代理
        {
            self.cityViewHeight.constant = 0;
            
            self.areaSignLabel.text = self.models[0].msg;
            self.daquMakerSignLabel.text = self.models[1].msg;
            self.cityMakerSignLabel.text = self.models[2].msg;
            self.makerSignLabel.text = self.models[3].msg;

        }
            break;
        case 3://市级代理
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            
            self.daquMakerSignLabel.text = self.models[0].msg;
            self.cityMakerSignLabel.text = self.models[1].msg;
            self.makerSignLabel.text = self.models[2].msg;
        }
            break;
        case 4://区级代理
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            self.daquMakerViewHeight.constant = 0;
            
            self.daquMakerSignLabel.text = self.models[0].msg;
            self.makerSignLabel.text = self.models[1].msg;
        }
            break;
        case 5://大区创客
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            self.daquMakerViewHeight.constant = 0;
            self.cityMakerViewHeight.constant = 0;
            
            self.makerSignLabel.text = self.models[0].msg;
        }
            break;
        case 6://城市创客
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            self.daquMakerViewHeight.constant = 0;
            self.cityMakerViewHeight.constant = 0;
            self.makerViewHeight.constant = 0;
            
        }
            break;

        default:
            break;
    }
}

#pragma mark - 提交分配
- (IBAction)submitSet:(id)sender {
    
    switch ([self.model.group_id integerValue]) {
            
        case 2://省级代理
        {
            if (self.cityNumTF.text.length == 0) {
                [EasyShowTextView showInfoText:@"请输入区级服务中心人数"];
                return;
            }
            if (self.daquMakerNumTF.text.length == 0) {
                [EasyShowTextView showInfoText:@"请输入大区创客人数"];
                return;
            }
            if (self.cityMakerNumTF.text.length == 0) {
                [EasyShowTextView showInfoText:@"请输入区级服务中心人数"];
                return;
            }
            if (self.makerNumTF.text.length == 0) {
                [EasyShowTextView showInfoText:@"请输入区级服务中心人数"];
                return;
            }
            
        }
            break;
        case 3://市级代理
        {
        
        }
            break;
        case 4://区级代理
        {
         
        }
            break;
        case 5://大区创客
        {
            
        }
            break;
        case 6://城市创客
        {
            
            
        }
            break;
            
        default:
            break;
    }
    
    if (self.block) {
        self.block(self.cityNumTF.text, self.areaNumTF.text, self.daquMakerNumTF.text, self.cityMakerNumTF.text, self.makerNumTF.text);
    }
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"app_handler"] = @"SEARCH";
//    dic[@"uid"] = [UserModel defaultUser].uid;
//    dic[@"token"] = [UserModel defaultUser].token;
//
//    [EasyShowLodingView showLodingText:@"数据请求中"];
//    [NetworkManager requestPOSTWithURLStr:kappend_subordinate paramDic:dic finish:^(id responseObject) {
//
//        [EasyShowLodingView hidenLoding];
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
//
//            [EasyShowTextView showSuccessText:@"提交成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//
//        }else{
//            [EasyShowTextView showErrorText:responseObject[@"message"]];
//        }
//
//    } enError:^(NSError *error) {
//
//        [EasyShowLodingView hidenLoding];
//        [EasyShowTextView showErrorText:error.localizedDescription];
//    }];
    
}

#pragma mark - UITextfieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.cityNumTF) {
        
        self.cityViewHeight.constant = 70;
        self.citySignLabel.hidden = NO;
    }else if(textField == self.areaNumTF){
        
        self.areaViewHeight.constant = 70;
        self.areaSignLabel.hidden = NO;
        
    }else if(textField == self.cityMakerNumTF){
        
        self.cityMakerViewHeight.constant = 70;
        self.cityMakerSignLabel.hidden = NO;
        
    }else if(textField == self.daquMakerNumTF){
        
        self.daquMakerViewHeight.constant = 70;
        self.daquMakerSignLabel.hidden = NO;
        
    }else if(textField == self.makerNumTF){
        
        self.makerViewHeight.constant = 70;
        self.makerSignLabel.hidden = NO;
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.cityNumTF) {
        
        if (self.cityNumTF.text.length == 0) {
            self.cityViewHeight.constant = 50;
            self.citySignLabel.hidden = YES;
        }
    }else if(textField == self.areaNumTF){
        if (self.areaNumTF.text.length == 0) {
            self.areaViewHeight.constant = 50;
            self.areaSignLabel.hidden = YES;
        }
    }else if(textField == self.cityMakerNumTF){
        if (self.cityMakerNumTF.text.length == 0) {
            self.cityMakerViewHeight.constant = 50;
            self.cityMakerSignLabel.hidden = YES;
        }
    }else if(textField == self.daquMakerNumTF){
        if (self.daquMakerNumTF.text.length == 0) {
            self.daquMakerViewHeight.constant = 50;
            self.daquMakerSignLabel.hidden = YES;
        }
    }else if(textField == self.makerNumTF){
        if (self.makerNumTF.text.length == 0) {
            self.makerViewHeight.constant = 50;
            self.makerSignLabel.hidden = YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.cityNumTF) {
        [self.areaNumTF becomeFirstResponder];
    }else if(textField == self.areaNumTF){
        [self.daquMakerNumTF becomeFirstResponder];
    }else if(textField == self.daquMakerNumTF){
        [self.cityNumTF becomeFirstResponder];
    }else if(textField == self.cityNumTF){
        [self.makerNumTF becomeFirstResponder];
    }else if(textField == self.makerNumTF){
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
        
    }
 
        if (![predicateModel inputShouldNumber:string]) {
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"此处只能输入数字"];
            
            return NO;
        }

    
    return YES;
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
