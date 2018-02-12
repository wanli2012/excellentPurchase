//
//  GLAddRecommderController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddRecommderController.h"

@interface GLAddRecommderController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;
@property (weak, nonatomic) IBOutlet UITextField *recommendTF;

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
    dic[@"user_name"] = self.recommendTF.text;
    
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



@end
