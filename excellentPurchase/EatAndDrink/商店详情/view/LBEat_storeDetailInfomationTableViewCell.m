//
//  LBEat_storeDetailInfomationTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_storeDetailInfomationTableViewCell.h"
#import "XHStarRateView.h"

@interface LBEat_storeDetailInfomationTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论view
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UILabel *repalyNum;

@end

@implementation LBEat_storeDetailInfomationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 13)];
    _starRateView.isAnimation = YES;
    _starRateView.rateStyle = IncompleteStar;
    _starRateView.backgroundColor = [UIColor whiteColor];
    _starRateView.currentScore = 3.0;
    [self.starView addSubview:_starRateView];

    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturecomments)];
    [self.commentView addGestureRecognizer:tapgesture];
}

-(void)tapgesturecomments{
    [self.delegate tapgesturecomments];
}
- (IBAction)ComeStorePay:(UIButton *)sender {
    
    [self.delegate ComeStorePay];
}

- (IBAction)takeTelephone:(UIButton *)sender {
    if ([NSString StringIsNullOrEmpty:_model.store_phone] == NO) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.store_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{
        [EasyShowTextView showText:@"没有该商家电话"];
    }
}

-(void)setModel:(LBEat_StoreDetailDataModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.store_thumb] placeholderImage:nil];
    self.storeName.text = [NSString stringWithFormat:@"%@",_model.store_name];
    _starRateView.currentScore = [_model.store_score floatValue];
    self.scoreLb.text = [NSString stringWithFormat:@"%@分",_model.store_score];
    self.adressLb.text = [NSString stringWithFormat:@"%@",_model.store_address];
    self.repalyNum.text = [NSString stringWithFormat:@"(%@)",_model.store_comment_count];
}

@end
