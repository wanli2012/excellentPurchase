//
//  LBMineEvaluateViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineEvaluateViewController.h"
#import "LCStarRatingView.h"
#import "ReactiveCocoa.h"

@interface LBMineEvaluateViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *noticelb;
@property (weak, nonatomic) IBOutlet UILabel *placeholderlb;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (assign, nonatomic) CGFloat  mark;//分数
@end

@implementation LBMineEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.mark = 0;
    self.starView.progress = 0;
    self.navigationController.navigationBar.hidden = NO;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:self.goods_pic] placeholderImage:nil];
    self.titlelb.text = self.goods_name;
    self.starView.type = LCStarRatingViewCountingTypeHalfCutting;
    //评论
    self.starView.progressDidChangedByUser = ^(CGFloat progress) {
        _mark = progress;
    };
    
    [[self.textview rac_textSignal]subscribeNext:^(NSString *x) {
        
        if (x.length  >=8) {
            self.submit.backgroundColor = MAIN_COLOR;
            self.submit.userInteractionEnabled = YES;
        }else{
            self.submit.backgroundColor = [UIColor lightGrayColor];
            self.submit.userInteractionEnabled = NO;
        }
        
    }];
    
}

/**
 匿名评价

 @param sender <#sender description#>
 */
- (IBAction)evaluateEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

/**
 提交

 @param sender <#sender description#>
 */
- (IBAction)submitEvent:(UIButton *)sender {

    if (self.replyType == 1) {
        if (_mark == 0) {
            [EasyShowTextView showInfoText:@"请评分商品"];
            return;
        }
        [self replyProducts];
    }else if (self.replyType == 2){
        if (_mark == 0) {
            [EasyShowTextView showInfoText:@"请评分商家"];
            return;
        }
        [self replyMerchant];
    }
    
}

-(void)replyMerchant{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"comment"] = self.textview.text;
    dic[@"mark"] = @(_mark);
    dic[@"line_id"] = self.line_id;
    dic[@"line_store_uid"] = self.line_store_uid;
    if (self.face_order_code) {
        dic[@"is_face"] = self.face_order_code;
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:CommentStore_comment paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (self.replyFinish) {
                self.replyFinish();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//评论商品
-(void)replyProducts{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"comment"] = self.textview.text;
    dic[@"mark"] = @(_mark);
    dic[@"order_goods_id"] = self.order_goods_id;
    dic[@"goods_id"] = self.goods_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:CommentUser_comment paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            if (self.replyFinish) {
                self.replyFinish();
            }
            [self.navigationController popViewControllerAnimated:YES];
          [EasyShowTextView showSuccessText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderlb.hidden = YES;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        self.placeholderlb.hidden = NO;
    }else{
        self.placeholderlb.hidden = YES;
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
