//
//  LBShopProductClassifyReusableView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShopProductClassifyReusableView.h"

@interface LBShopProductClassifyReusableView()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerView;
/**
 头部轮播
 */
@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *collectionBt;
@property (weak, nonatomic) IBOutlet UILabel *haoping;



@end

@implementation LBShopProductClassifyReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bannerView addSubview:self.cycleScrollView];
    
}

- (IBAction)collectionEvent:(UIButton *)sender {
    
    if (sender.selected == YES) {
        [self userCancelCollection];
    }else{
        [self userCollection];
    }
    
}


-(void)setModel:(LBStoreInfoModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.store_thumb] placeholderImage:nil];
    
    //开始轮播
    self.cycleScrollView.imageURLStringsGroup =[_model.store_homepage mutableCopy];
    self.title.text = [NSString stringWithFormat:@"%@",_model.store_name];
    
    if ([_model.fans_count floatValue] >= 10000) {
        self.haoping.text = [NSString stringWithFormat:@"%1.f@万粉丝",[_model.fans_count floatValue]/10000.0];
    }else{
        self.haoping.text = [NSString stringWithFormat:@"%@人粉丝",_model.fans_count];
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
    dic[@"type"] = @"2"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingNot_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect=0;
            self.collectionBt.selected = NO;
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
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
    dic[@"link_id"] = self.model.store_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @"2"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingUser_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            self.collectionBt.selected = YES;
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
#pragma mark - 点击轮播图 回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth / 2.0) delegate:self placeholderImage:[UIImage imageNamed:@"banner(吃喝玩乐）"]];//当一张都没有的时候的 占位图
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = @[@" "];
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}

@end
