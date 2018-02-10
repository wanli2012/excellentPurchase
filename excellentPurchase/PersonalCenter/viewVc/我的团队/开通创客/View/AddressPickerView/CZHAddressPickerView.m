//
//  CZHAddressPickerView.m
//  CZHAddressPickerView
//
//  Created by 程召华 on 2017/11/24.
//  Copyright © 2017年 程召华. All rights reserved.
//

#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"
#import "UIButton+CZHExtension.h"

#define TOOLBAR_BUTTON_WIDTH CZH_ScaleWidth(80)

typedef NS_ENUM(NSInteger, CZHAddressPickerViewButtonType) {
   CZHAddressPickerViewButtonTypeCancle,
   CZHAddressPickerViewButtonTypeSure
};

typedef NS_ENUM(NSInteger, CZHAddressPickerViewType) {
   //只显示省
   CZHAddressPickerViewTypeProvince = 1,
   //显示省份和城市
   CZHAddressPickerViewTypeCity,
   //显示省市区，默认
   CZHAddressPickerViewTypeArea
};

@interface CZHAddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
///注释
@property (nonatomic, assign) NSInteger columnCount;
///容器view
@property (nonatomic, weak) UIView *containView;
///
@property(nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, copy)NSArray *dataArr;//省市区数据源
///省
//@property(nonatomic, strong) NSArray * provinceArray;
///市
@property(nonatomic, strong) NSArray * cityArray;
///区
@property(nonatomic, strong) NSArray * areaArray;
///所有数据
@property(nonatomic, strong) NSArray * dataSource;
///记录省选中的位置
@property(nonatomic, assign) NSInteger selectProvinceIndex;
///记录市选中的位置
@property(nonatomic, assign) NSInteger selectCityIndex;
///记录区选中的位置
@property(nonatomic, assign) NSInteger selectAreaIndex;
//显示类型
@property (nonatomic, assign) CZHAddressPickerViewType showType;
///传进来的默认选中的省
@property(nonatomic, copy) NSString * selectProvince;
///传进来的默认选中的市
@property(nonatomic, copy) NSString * selectCity;
///传进来的默认选中的区
@property(nonatomic, copy) NSString * selectArea;

///传进来的默认选中的省 id
@property(nonatomic, copy) NSString * selectProvince_id;
///传进来的默认选中的市 id
@property(nonatomic, copy) NSString * selectCity_id;
///传进来的默认选中的区 id
@property(nonatomic, copy) NSString * selectArea_id;

///省份回调
@property (nonatomic, copy) void (^provinceBlock)(NSString *province);
///城市回调
@property (nonatomic, copy) void (^cityBlock)(NSString *province, NSString *city);
///区域回调
@property (nonatomic, copy) void (^areaBlock)(NSString *province, NSString *city, NSString *area);

///区域详细回调
@property (nonatomic, copy) void (^areaDetailBlock)(NSString *province, NSString *city, NSString *area,NSString *province_id,NSString *city_id,NSString *area_id);

@end


@implementation CZHAddressPickerView

/**
 * 只显示省份一级
 * provinceBlock : 回调省份
 */
+ (instancetype)provincePickerViewWithProvinceBlock:(void(^)(NSString *province))provinceBlock {
   return [CZHAddressPickerView addressPickerViewWithProvince:nil city:nil area:nil provinceBlock:provinceBlock cityBlock:nil areaBlock:nil showType:CZHAddressPickerViewTypeProvince];
}

/**
 * 显示省份和市级
 * cityBlock : 回调省份和城市
 */
+ (instancetype)cityPickerViewWithCityBlock:(void(^)(NSString *province, NSString *city))cityBlock {
   return [CZHAddressPickerView addressPickerViewWithProvince:nil city:nil area:nil provinceBlock:nil cityBlock:cityBlock areaBlock:nil showType:CZHAddressPickerViewTypeCity];
}

/**
 * 显示省份和市级和区域
 * areaBlock : 回调省份城市和区域
 */
+ (instancetype)areaPickerViewWithAreaBlock:(void(^)(NSString *province, NSString *city, NSString *area))areaBlock {
   return [CZHAddressPickerView addressPickerViewWithProvince:nil city:nil area:nil provinceBlock:nil cityBlock:nil areaBlock:areaBlock showType:CZHAddressPickerViewTypeArea];
}


+ (instancetype)areaPickerViewWithDataArr:(NSArray *)dataArr AreaDetailBlock:(void(^)(NSString *province, NSString *city, NSString *area,NSString *province_id,NSString *city_id,NSString *area_id))areaDetailBlock {
   
   return [CZHAddressPickerView addressPickerViewWithDataArr:dataArr Province:nil city:nil area:nil provinceBlock:nil cityBlock:nil areaBlock:nil areaDetailBlock:areaDetailBlock showType:CZHAddressPickerViewTypeArea];
   
}


/**
 * 只显示省份一级
 * province : 传入了省份自动滚动到省份，没有传或者找不到默认选中第一个
 * provinceBlock : 回调省份
 */
+ (instancetype)provincePickerViewWithProvince:(NSString *)province provinceBlock:(void(^)(NSString *province))provinceBlock {
   return [CZHAddressPickerView addressPickerViewWithProvince:province city:nil area:nil provinceBlock:provinceBlock cityBlock:nil areaBlock:nil showType:CZHAddressPickerViewTypeProvince];
}

/**
 * 显示省份和市级
 * province,city : 传入了省份和城市自动滚动到选中的，没有传或者找不到默认选中第一个
 * cityBlock : 回调省份和城市
 */
+ (instancetype)cityPickerViewWithProvince:(NSString *)province city:(NSString *)city cityBlock:(void(^)(NSString *province, NSString *city))cityBlock {
   return [CZHAddressPickerView addressPickerViewWithProvince:province city:city area:nil provinceBlock:nil cityBlock:cityBlock areaBlock:nil showType:CZHAddressPickerViewTypeCity];
}


/**
 * 显示省份和市级和区域
 * province,city : 传入了省份和城市和区域自动滚动到选中的，没有传或者找不到默认选中第一个
 * areaBlock : 回调省份城市和区域
 */
+ (instancetype)areaPickerViewWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area areaBlock:(void(^)(NSString *province, NSString *city, NSString *area))areaBlock {
   return [CZHAddressPickerView addressPickerViewWithProvince:province city:city area:area provinceBlock:nil cityBlock:nil areaBlock:areaBlock showType:CZHAddressPickerViewTypeArea];
}
+ (instancetype)areaPickerViewWithDataArr:(NSArray *)dataArr Province:(NSString *)province city:(NSString *)city area:(NSString *)area areaBlock:(void(^)(NSString *province, NSString *city, NSString *area))areaBlock areaDetailBlock:(void(^)(NSString *province, NSString *city, NSString *area,NSString *province_id,NSString *city_id,NSString *area_id))areaDetailBlock {
   return [CZHAddressPickerView addressPickerViewWithDataArr:(NSArray *)dataArr Province:province city:city area:area  provinceBlock:nil cityBlock:nil areaBlock:nil areaDetailBlock:areaDetailBlock showType:CZHAddressPickerViewTypeArea];
}


+ (instancetype)addressPickerViewWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area provinceBlock:(void(^)(NSString *province))provinceBlock cityBlock:(void(^)(NSString *province, NSString *city))cityBlock areaBlock:(void(^)(NSString *province, NSString *city, NSString *area))areaBlock  showType:(CZHAddressPickerViewType)showType{
   
   CZHAddressPickerView *_view = [[CZHAddressPickerView alloc] init];
   
   _view.showType = showType;
   
   _view.selectProvince = province;
   
   _view.selectCity = city;
   
   _view.selectArea = area;
   
   _view.provinceBlock = provinceBlock;
   
   _view.cityBlock = cityBlock;
   
   _view.areaBlock = areaBlock;
   
   [_view czh_getData];
   
   [_view showView];
   
   return _view;
   
}

+ (instancetype)addressPickerViewWithDataArr:(NSArray *)dataArr Province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceBlock:(void(^)(NSString *province))provinceBlock cityBlock:(void(^)(NSString *province, NSString *city))cityBlock areaBlock:(void(^)(NSString *province, NSString *city, NSString *area))areaBlock areaDetailBlock:(void(^)(NSString *province, NSString *city, NSString *area,NSString *province_id,NSString *city_id,NSString *area_id))areaDetailBlock showType:(CZHAddressPickerViewType)showType{
   
   CZHAddressPickerView *_view = [[CZHAddressPickerView alloc] init];
   
   _view.dataSource = dataArr;
   
   _view.showType = showType;
   
   _view.selectProvince = province;
   
   _view.selectCity = city;
   
   _view.selectArea = area;
   
   _view.provinceBlock = provinceBlock;
   
   _view.cityBlock = cityBlock;
   
   _view.areaBlock = areaBlock;
   
   _view.areaDetailBlock = areaDetailBlock;
   
   [_view czh_getData];
   
   [_view showView];
   
   return _view;
   
}



- (instancetype)init {
   if (self = [super init]) {
      
      [self czh_setView];
      
   }
   return self;
}



- (void)czh_setView {
   
   self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
   
   UIView *containView = [[UIView alloc] init];
   containView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, CZH_ScaleHeight(270));
   [self addSubview:containView];
   self.containView = containView;
   
   
   UIView *toolBar = [[UIView alloc] init];
   toolBar.frame = CGRectMake(0, 0, ScreenWidth, CZH_ScaleHeight(50));
   toolBar.backgroundColor = CZHColor(0xf6f6f6);
   [containView addSubview:toolBar];
   
   UIButton *cancleButton = [UIButton czh_buttonWithTarget:self action:@selector(buttonClick:) frame:CGRectMake(0, 0, TOOLBAR_BUTTON_WIDTH, toolBar.czh_height) titleColor:CZHColor(0x333333) titleFont:CZHGlobelNormalFont(14) title:@"取消"];
   
   cancleButton.tag = CZHAddressPickerViewButtonTypeCancle;
   [toolBar addSubview:cancleButton];
   
   UIButton *sureButton = [UIButton czh_buttonWithTarget:self action:@selector(buttonClick:) frame:CGRectMake(toolBar.czh_width - TOOLBAR_BUTTON_WIDTH, 0, TOOLBAR_BUTTON_WIDTH, toolBar.czh_height) titleColor:CZHThemeColor titleFont:CZHGlobelNormalFont(14) title:@"确定"];
   sureButton.tag = CZHAddressPickerViewButtonTypeSure;
   [toolBar addSubview:sureButton];
   
   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, 0, 100, toolBar.czh_height)];
   label.text = @"地区选择";
   label.textAlignment = NSTextAlignmentCenter;
   label.textColor = LBHexadecimalColor(0x333333);
   label.font = [UIFont systemFontOfSize:16];
   [toolBar addSubview:label];
   
   
   UIPickerView *pickerView = [[UIPickerView alloc] init];
   pickerView.backgroundColor = CZHColor(0xffffff);
   pickerView.frame = CGRectMake(0, toolBar.czh_bottom, ScreenWidth, containView.czh_height - toolBar.czh_height);
   pickerView.delegate = self;
   pickerView.dataSource = self;
   [containView addSubview:pickerView];
   self.pickerView = pickerView;
   
}

//获取数据
- (void)czh_getData {

   self.selectProvince_id = @"";
   self.selectCity_id = @"";
   self.selectArea_id = @"";
   self.selectProvince = @"";
   self.selectCity = @"";
   self.selectArea = @"";
   self.selectProvinceIndex = 0;
   self.selectCityIndex = 0;
   self.selectAreaIndex = 0;

   //市
   self.cityArray = self.dataSource[0][@"city"];
   //区
   self.areaArray = self.dataSource[0][@"city"][0][@"city"];
   
   self.selectProvince = self.dataSource[0][@"name"];
   self.selectCity = self.cityArray[0][@"name"];
   self.selectArea = self.areaArray[0][@"name"];
   
   self.selectProvince_id = self.dataSource[0][@"id"];
   self.selectCity_id = self.cityArray[0][@"id"];
   self.selectArea_id = self.areaArray[0][@"id"];
   
   [self.pickerView reloadAllComponents];
   
}

- (void)buttonClick:(UIButton *)sender {
   
   [self hideView];
   
   if (sender.tag == CZHAddressPickerViewButtonTypeSure) {
      
      if (_provinceBlock) {
         _provinceBlock(self.selectProvince);
      }
      if (_cityBlock) {
         _cityBlock(self.selectProvince, self.selectCity);
      }
      if (_areaBlock) {
         _areaBlock(self.selectProvince, self.selectCity, self.selectArea);
      }
      if(_areaDetailBlock){
         _areaDetailBlock(self.selectProvince,self.selectCity,self.selectArea, self.selectProvince_id,self.selectCity_id,self.selectArea_id);
      }
   }
}

#pragma mark -- UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return self.columnCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   if (component == 0) {
      return self.dataSource.count;
   }else if (component == 1){
      return self.cityArray.count;
   }else if (component == 2){
      return self.areaArray.count;
   }
   return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
   UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 30)];
   label.adjustsFontSizeToFitWidth = YES;
   label.textAlignment = NSTextAlignmentCenter;
   if (component == 0) {
      label.text = self.dataSource[row][@"name"];
      self.selectProvince_id = self.dataSource[row][@"id"];
   }else if (component == 1){
      label.text = self.cityArray[row][@"name"];
      self.selectCity_id = self.cityArray[row][@"id"];
   }else if (component == 2){
      label.text = self.areaArray[row][@"name"];
      self.selectArea_id = self.areaArray[row][@"id"];
   }
   
   return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   if (component == 0) {//选择省
      self.selectProvinceIndex = row;
      
      self.selectProvinceIndex = row;
      self.cityArray = self.dataSource[row][@"city"];
      self.areaArray = self.dataSource[row][@"city"][0][@"city"];
      
      self.selectProvince = self.dataSource[row][@"name"];
      self.selectCity = self.cityArray[0][@"name"];
      self.selectProvince_id = self.dataSource[row][@"id"];
      self.selectCity_id = self.cityArray[0][@"id"];
      
      if(self.areaArray.count != 0){
         
         self.selectArea = self.areaArray[0][@"name"];
         self.selectArea_id = self.areaArray[0][@"id"];
      }
      
      
      [pickerView selectRow:0 inComponent:2 animated:YES];
      
   }
   
   [pickerView selectedRowInComponent:1];
   [pickerView reloadComponent:1];
   
   if (component == 1){//选择市
      self.selectCityIndex = row;
      
      self.areaArray = self.dataSource[self.selectProvinceIndex][@"city"][row][@"city"];
      
      if(self.areaArray.count > 0){
         
         [pickerView selectRow:0 inComponent:2 animated:YES];
         
         self.selectCity = self.cityArray[row][@"name"];
         self.selectCity_id = self.cityArray[row][@"id"];
         self.selectArea = self.areaArray[0][@"name"];
         self.selectArea_id = self.areaArray[0][@"id"];
         
      }else{
         [pickerView selectRow:0 inComponent:2 animated:YES];
      }
      
   }
   
   [pickerView reloadComponent:2];
   
   if (component == 2){//选择区
      self.selectAreaIndex = row;

      if (self.areaArray.count != 0) {
         self.selectArea = self.areaArray[row][@"name"];
         self.selectArea_id = self.areaArray[row][@"id"];
      
      }

   }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
   return 40.0;
}


- (void)showView {
   [[UIApplication sharedApplication].keyWindow addSubview:self];
   
   self.backgroundColor = [UIColor clearColor];
   
   [UIView animateWithDuration:0.3 animations:^{
      self.backgroundColor = CZHRGBColor(0x000000, 0.3);
      self.containView.czh_bottom = ScreenHeight;
   }];
}

- (void)hideView {
   
   [UIView animateWithDuration:0.3 animations:^{
      self.backgroundColor = [UIColor clearColor];
      self.containView.czh_y = ScreenHeight;
   } completion:^(BOOL finished) {
      [self removeFromSuperview];
   }];
   
}

- (void)setShowType:(CZHAddressPickerViewType)showType {
   _showType = showType;
   self.columnCount = showType;
   
   [self.pickerView reloadAllComponents];
}

@end
