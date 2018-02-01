//
//  LBProductPhotosBrowserVc.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductPhotosBrowserVc.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"

@interface LBProductPhotosBrowserVc () <ZLPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (nonatomic , strong) NSMutableArray *photos;

@end

@implementation LBProductPhotosBrowserVc

- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray arrayWithCapacity:self.urls.count];
        for (NSString *url in _urls) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:url];
            [_photos addObject:photo];
        }
        
        _assets = _photos.mutableCopy;
    }
    return _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"商品图片";
    // 这个属性不能少
    adjustsScrollViewInsets_NO(self.scrollView, self);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, self.view.frame.size.height - SafeAreaTopHeight);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    
    NSLog(@"%@",self.urls);
//    // 初始化数据
    [self photos];
//    // 属性scrollView
    [self reloadScrollView];
}

- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 3;
  
    NSUInteger assetCount = self.assets.count;
    
    CGFloat width = (UIScreenWidth - 40.0) / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(10 + (width + 10) * col, 10 + row * (width + 10), width, width);
        
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            ZLPhotoPickerBrowserPhoto *photo = [self.assets objectAtIndex:i];
            
            if (photo != nil && [photo.asset isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[photo.asset thumbImage] forState:UIControlStateNormal];
            }else{
                ZLPhotoPickerBrowserPhoto *photo = self.assets[i];
                [btn sd_setImageWithURL:photo.photoURL forState:UIControlStateNormal];
            }
            photo.toView = btn.imageView;
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(UIScreenWidth, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}

#pragma mark - 选择图片
- (void)photoSelecte{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 9-self.photos.count;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Recoder Select Assets
    pickerVc.selectPickers = self.assets;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    // CallBack
    __weak typeof(self)weakSelf = self;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:status.count];
        for (ZLPhotoAssets *assets in status) {
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:assets];
            photo.asset = assets;
            [photos addObject:photo];
        }
        
        weakSelf.assets = [NSMutableArray arrayWithArray:weakSelf.photos];
        [weakSelf.assets addObjectsFromArray:photos];
        [weakSelf reloadScrollView];
    };
    [pickerVc showPickerVc:self];
}

- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = NO;
    pickerBrowser.photos = self.assets;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        [self.assets removeObjectAtIndex:index];
        [self reloadScrollView];
    }
}


@end
