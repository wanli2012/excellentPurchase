//
//  LBEat_StoreCommentsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentsTableViewCell.h"


@interface LBEat_StoreCommentsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end

@implementation LBEat_StoreCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setContentReply:(NSString *)contentReply{
    _contentReply = contentReply;
    
    NSString  *str  = [NSString stringWithFormat:@"商家回复：%@",_contentReply];
    
    self.contentLb.attributedText = [self addoriginstr:str specilstr:@[@"商家"]];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:LBHexadecimalColor(0x4f7daf)} range:rang];
    }

    
    return noteStr;
    
}

@end
