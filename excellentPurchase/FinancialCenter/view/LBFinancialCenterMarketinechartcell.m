//
//  LBFinancialCenterMarketinechartcell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterMarketinechartcell.h"
#import "ZFLineChart.h"

@interface LBFinancialCenterMarketinechartcell()<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic, strong) ZFLineChart * lineChart;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong)NSMutableArray *valueArr;
@property (nonatomic, strong)NSMutableArray *timeArr;

@end

@implementation LBFinancialCenterMarketinechartcell

- (void)awakeFromNib {
    [super awakeFromNib];

    _height = UIScreenHeight - (196 + SafeAreaTopHeight + 60 + 50);
    
    [self requstDatasource];
}

-(void)requstDatasource{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(1);
    
    [NetworkManager requestPOSTWithURLStr:kget_money_list paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if ([responseObject[@"data"][@"count"] integerValue] == 0) {
                
            }else if ([responseObject[@"data"][@"count"] integerValue] < 7){
                for (int i = 0; i < [responseObject[@"data"][@"count"] integerValue]; i++) {
                    
                    [self.valueArr addObject:responseObject[@"data"][@"page_data"][i][@"ratio"]];
                    NSString *timestr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"page_data"][i][@"addtime"]];
                    timestr = [timestr substringFromIndex:5];
                    [self.timeArr addObject:timestr];
                }
                
                [self loadviews];
            }else{
                
                for (int i = 0; i < 7; i++) {
                    
                    [self.valueArr addObject:responseObject[@"data"][@"page_data"][i][@"ratio"]];
                    NSString *timestr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"page_data"][i][@"addtime"]];
                    timestr = [timestr substringFromIndex:5];
                    [self.timeArr addObject:timestr];
                }
                
                [self loadviews];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
       
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

-(void)loadviews{
    
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.text = @"";
    self.lineChart.unit = @"";
    self.lineChart.topicLabel.textColor = ZFPurple;
    self.lineChart.isResetAxisLineMinValue = YES;
    self.lineChart.isResetAxisLineMaxValue = YES;
    //    self.lineChart.isAnimated = NO;
    //    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    self.lineChart.isShowSeparate = YES;
    //    lineChart.valueCenterToCircleCenterPadding = 0;
    [self addSubview:self.lineChart];
    [self.lineChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return self.valueArr;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return self.timeArr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[LBHexadecimalColor(0x2057B9)];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    NSNumber* max1=[self.valueArr valueForKeyPath:@"@max.floatValue"];

    return [max1 floatValue] + 1;
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    
    return 0;
}

- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 6;
}

#pragma mark - ZFLineChartDelegate

//- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
//    return 25.f;
//}

//- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
//    return 20.f;
//}

//- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
//    return 5.f;
//}

//- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
//    return 2.f;
//}

//- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart{
//    return @[@(kChartValuePositionOnTop)];
//}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"第%ld个", (long)circleIndex);
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"第%ld个" ,(long)circleIndex);
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0){
    
    self.lineChart.frame = CGRectMake(0, 0, SCREEN_WIDTH, _height);
    
    [self.lineChart strokePath];
}

-(NSMutableArray*)valueArr{
    if (!_valueArr) {
        _valueArr = [NSMutableArray array];
    }
    return _valueArr;
}
-(NSMutableArray*)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}
@end
