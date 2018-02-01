//
//  LBIntegralGoodsOneCollectionViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralGoodsOneCollectionViewCell.h"

@interface LBIntegralGoodsOneCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlte;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (weak, nonatomic) IBOutlet UILabel *scanNum;
@property (weak, nonatomic) IBOutlet UIButton *collectionBt;

@end

@implementation LBIntegralGoodsOneCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    _imagev.layer.borderWidth = 1;
    _imagev.layer.borderColor = YYSRGBColor(225, 225, 225, 1).CGColor;
    
}

- (IBAction)collectionEvent:(UIButton *)sender {
    
    if (sender.selected == YES) {//收藏过 ，该取消收藏
        [self userCancelCollection];
    }else{//取消该藏过
        [self userCollection];
    }
    
}

-(void)setModel:(LBTmallhomepageDataStructureModel *)model{
    _model = model;
    [_imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:nil];
    self.titlte.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.jifen.attributedText = [self addoriginstr:[NSString stringWithFormat:@"%@积分",_model.bonuspoints] specilstr:@[@"积分"]];
    self.priceLb.text = [NSString stringWithFormat:@"¥%@",_model.discount];
    if ([_model.browse floatValue] >= 10000) {
        self.scanNum.text = [NSString stringWithFormat:@"%1.f@万人浏览",[_model.browse floatValue]/10000.0];
    }else{
        self.scanNum.text = [NSString stringWithFormat:@"%@人浏览",_model.browse];
    }
    
    if ([_model.is_collect integerValue]==0) {
        self.collectionBt.selected = NO;
    }else{
        self.collectionBt.selected = YES;
    }
    
}

//取消收藏
-(void)userCancelCollection{
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"DELETE";
    dic[@"collect_id"] = self.model.is_collect;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @"1"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingNot_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect=0;
            if (self.refrshDatasorece) {
                self.refrshDatasorece();
            }
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//收藏
-(void)userCollection{
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"link_id"] = self.model.goods_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @"1"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingUser_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            if (self.refrshDatasorece) {
                self.refrshDatasorece();
            }
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:LBHexadecimalColor(0x333333)} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} range:rang];
    }
    
    return noteStr;
    
}
@end
