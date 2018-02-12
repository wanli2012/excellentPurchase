//
//  LBShowProductListCollectionViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowProductListCollectionViewCell.h"

@interface LBShowProductListCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *scanlb;
@property (weak, nonatomic) IBOutlet UILabel *payNumlb;
@property (weak, nonatomic) IBOutlet UIButton *collectionBt;

@end

@implementation LBShowProductListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

-(void)setModel:(LBTmallhomepageDataStructureModel *)model{
    _model = model;
    
    NSMutableAttributedString *attri =    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.goods_name]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"海淘-返券"];
    attch.bounds = CGRectMake(0, -3, 38, 17);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    self.titileLb.attributedText = attri;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:nil];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",_model.discount];
    self.jifen.text = [NSString stringWithFormat:@"%@积分",_model.bonuspoints];
    if ([_model.salenum floatValue] >= 10000) {
        self.payNumlb.text = [NSString stringWithFormat:@"%1.f@万人付款",[_model.salenum floatValue]/10000.0];
    }else{
        self.payNumlb.text = [NSString stringWithFormat:@"%@人付款",_model.salenum];
    }
    
    if ([_model.browse floatValue] >= 10000) {
        self.scanlb.text = [NSString stringWithFormat:@"%1.f@万人浏览",[_model.browse floatValue]/10000.0];
    }else{
        self.scanlb.text = [NSString stringWithFormat:@"%@人浏览",_model.browse];
    }

    if ([_model.is_collect integerValue]==0) {
        self.collectionBt.selected = NO;
    }else{
        self.collectionBt.selected = YES;
    }
    
    switch ([_model.channel integerValue]) {
        case 1:
            self.typeImage.image = [UIImage imageNamed:@"厂家直供"];
            break;
        case 2:
            self.typeImage.image = [UIImage imageNamed:@"产地直供"];
            break;
        case 3:
            self.typeImage.image = [UIImage imageNamed:@"品牌加盟"];
            break;
        case 4:
            self.typeImage.image = [UIImage imageNamed:@"微商清仓"];
            break;
        case 5:
            self.typeImage.image = [UIImage imageNamed:@"自营商城"];
            break;
        default:
            break;
    }
}

- (IBAction)collectionEvent:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showText:@"请先登录"];
        return;
    }
    if (sender.selected == YES) {//收藏过 ，该取消收藏
        [self userCancelCollection];
    }else{//取消该藏过
        [self userCollection];
    }
}
//取消收藏
-(void)userCancelCollection{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"DELETE";
    dic[@"collect_id"] = self.model.is_collect;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"link_id"] = self.model.goods_id;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
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

@end
