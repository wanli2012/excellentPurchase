//
//  LBMineSureOrdermessageTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineSureOrdermessageTableViewCell.h"

@interface LBMineSureOrdermessageTableViewCell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation LBMineSureOrdermessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)textViewDidBeginEditing:(UITextView *)textView{
        self.placeholderLb.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    textView.text = [textView.text stringByReplacingOccurrencesOfString: @" " withString: @""];
    textView.text = [textView.text stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLb.hidden = YES;
    }
    
    if (self.returntextview) {
        self.returntextview(textView.text, self.indexpath);
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
    }
    
    return YES;
}

@end
