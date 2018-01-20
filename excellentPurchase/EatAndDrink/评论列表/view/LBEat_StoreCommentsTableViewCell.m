//
//  LBEat_StoreCommentsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentsTableViewCell.h"
#import "FMLinkLabel.h"

@interface LBEat_StoreCommentsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end

@implementation LBEat_StoreCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LB_Eat_commentOneDataModel *)model{
    _model = model;
    NSString  *str  = [NSString stringWithFormat:@"%@回复%@：%@",_model.name,_model.replyname,_model.content];

    self.contentLb.attributedText = [self addoriginstr:str specilstr:@[_model.name,_model.replyname]];
   
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
