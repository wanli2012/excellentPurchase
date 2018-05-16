//
//  LBSendShowinfoViewcell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendShowinfoViewcell.h"

@interface LBSendShowinfoViewcell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation LBSendShowinfoViewcell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = [UserModel defaultUser].nick_name;
    
    if ([NSString StringIsNullOrEmpty:[UserModel defaultUser].nick_name]) {
        self.namelb.text = [UserModel defaultUser].user_name;
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholder.hidden = YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
    
    
    if (self.returntext) {
        self.returntext(textView.text);
    }
    
    
}


@end
