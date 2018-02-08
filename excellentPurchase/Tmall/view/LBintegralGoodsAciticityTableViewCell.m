//
//  LBintegralGoodsAciticityTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBintegralGoodsAciticityTableViewCell.h"
//#import "FLAnimatedImage.h"


@interface LBintegralGoodsAciticityTableViewCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (strong, nonatomic)NSMutableArray *imagearr;

//@property (nonatomic, strong) FLAnimatedImageView *imageView1;

@end


@implementation LBintegralGoodsAciticityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.baseview addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
  
}

-(void)loadimage:(NSString *)imageurl isGif:(NSString *)gifstr{

    [self.imageone sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    
}

-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, 80)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"haitaoshouye_guanggao"]];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.localizationImageNamesGroup = self.imagearr;
        _cycleScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _cycleScrollView;
    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  
    
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    
}

-(NSMutableArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = [NSMutableArray arrayWithObjects:@"haitao_banner", nil];
    }
    
    return _imagearr;
    
}


@end
