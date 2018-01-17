//
//  LBCommentHeaderTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCommentHeaderTableViewCell.h"

@interface LBCommentHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SCR_content;

@end

@implementation LBCommentHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.SCR_content.constant = UIScreenWidth;
    
}



@end
