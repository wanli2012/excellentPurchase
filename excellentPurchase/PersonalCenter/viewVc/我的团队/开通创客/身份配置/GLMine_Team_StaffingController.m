//
//  GLMine_Team_StaffingController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_StaffingController.h"

@interface GLMine_Team_StaffingController ()<UITextFieldDelegate>

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

@end

@implementation GLMine_Team_StaffingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"人员配置";
    self.group_id = @"1";
    
    switch ([self.group_id integerValue]) {
        case 1://副总
        {
            
        }
            break;
        case 2://省级代理
        {
            self.cityViewHeight.constant = 0;
        }
            break;
        case 3://市级代理
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
        }
            break;
        case 4://区级代理
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            self.cityMakerViewHeight.constant = 0;
        }
            break;
        case 5://城市创客
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            self.cityMakerViewHeight.constant = 0;
            self.daquMakerViewHeight.constant = 0;
        }
            break;
        case 6://大区创客
        {
            self.cityViewHeight.constant = 0;
            self.areaViewHeight.constant = 0;
            self.cityMakerViewHeight.constant = 0;
            self.daquMakerViewHeight.constant = 0;
            self.makerViewHeight.constant = 0;
        }
            break;
        case 7://创客
        {
            
        }
            break;
            
        default:
            break;
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}


@end
