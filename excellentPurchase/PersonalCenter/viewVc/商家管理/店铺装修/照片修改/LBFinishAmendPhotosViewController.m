//
//  LBFinishAmendPhotosViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinishAmendPhotosViewController.h"
#import "LBStoreAmendPhotosCell.h"

#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"

#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIImage+ZLPhotoLib.h"

@interface LBFinishAmendPhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HCBasePopupViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHH1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH2;
@property (nonatomic , strong) NSMutableArray *assets1;
@property (nonatomic , strong) NSMutableArray *photos1;

@property (nonatomic , strong) NSMutableArray *assets2;
@property (nonatomic , strong) NSMutableArray *photos2;

@end

static NSString *ID = @"LBStoreAmendPhotosCell";

@implementation LBFinishAmendPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"照片修改";
    [self.collectionview1 registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.collectionview2 registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionview1) {
        return self.assets1.count + 1;
    }else{
        return self.assets2.count + 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBStoreAmendPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (collectionView == self.collectionview1) {
        //删除
        if (indexPath.item == self.assets1.count) {
            cell.deleteBt.hidden = YES;
            cell.imagev.image = [UIImage imageNamed:@"addphotograph"];
        }else{
            cell.deleteBt.hidden = NO;
            cell.imagev.image = [UIImage imageNamed:self.assets1[indexPath.item]];
        }
        cell.deleteBlock = ^(NSInteger index) {
            [self.assets1 removeObjectAtIndex:index];
            [self.collectionview1 reloadData];
        };
    }else{
        //删除
        if (indexPath.item == self.assets2.count) {
            cell.deleteBt.hidden = YES;
            cell.imagev.image = [UIImage imageNamed:@"addphotograph"];
        }else{
            cell.deleteBt.hidden = NO;
            cell.imagev.image = [UIImage imageNamed:self.assets2[indexPath.item]];
        }
        cell.deleteBlock = ^(NSInteger index) {
            [self.assets2 removeObjectAtIndex:index];
            [self.collectionview2 reloadData];
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionview1) {
        if (indexPath.row == self.assets1.count) {//选择照片
            
            HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
            __weak typeof(self) wself = self;
            HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"拍照" withSelectedBlock:^{
                [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                [wself getcamera];
            } withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"从手机相册选择" withSelectedBlock:^{
                [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                [wself photoSelectet:self.assets1 collectionview:self.collectionview1];
            } withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
            
            [pc addAction:action1];
            [pc addAction:action2];
            [pc addAction:action3];
            [pc addAction:action4];
            
            [self presentViewController:pc animated:YES completion:nil];
        }else{//放大
            [self tapBrowser:indexPath.row];
            
        }
    }else{
        if (indexPath.row == self.assets2.count) {//选择照片
            HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
            __weak typeof(self) wself = self;
            HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"拍照" withSelectedBlock:^{
                [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                [wself getcamera];
            } withType:HCBottomPopupActionSelectItemTypeDefault];
            HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"从手机相册选择" withSelectedBlock:^{
                [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                [wself photoSelectet:self.assets2 collectionview:self.collectionview2];
            } withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
            
            [pc addAction:action1];
            [pc addAction:action2];
            [pc addAction:action3];
            [pc addAction:action4];
            
            [self presentViewController:pc animated:YES completion:nil];
        }else{//放大
            [self tapBrowser:indexPath.row];
            
        }
    }
    
}

#pragma mark - HCBasePopupViewControllerDelegate 个协议方法来自定义你的弹出框内容
- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller{
    
}

- (void)didTapMaskViewWithMaskView:(UIView *)maskView withController:(UIViewController *)controller{
    
}
#pragma mark -拍照
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - 选择图片
- (void)photoSelectet:(NSMutableArray*)assets collectionview:(UICollectionView*)collectionview{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 9
    pickerVc.maxCount = 1;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Recoder Select Assets
    pickerVc.selectPickers = assets;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        [assets addObject: status.mutableCopy];
        [collectionview reloadData];
    };
    [pickerVc showPickerVc:self];
}

- (void)tapBrowser:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos1;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets1.count > index) {
        
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionview1) {
       return CGSizeMake((UIScreenWidth - 20)/3.0, (UIScreenWidth - 20)/3.0);
    }else{
        return CGSizeMake((UIScreenWidth - 20)/2.0, (UIScreenWidth - 20)/2.0);
    }
    
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSMutableArray *)assets1{
    if (!_assets1) {
        _assets1 = [NSMutableArray arrayWithObject:@"1"];
    }
    return _assets1;
}
- (NSMutableArray *)photos1{
    if (!_photos1) {
        NSArray *urls = @[
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=515dae6de7dde711e7d243fe97eecef4/6c236b600c3387446fc73114530fd9f9d72aa05b.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=1875d6474334970a47731027a5cbd1c0/51e876094b36acaf9e7b88947ed98d1000e99cc2.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=67ef9ea341166d223877159c76230945/e2f7f736afc3793138419f41e9c4b74543a911b7.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=a18485594e086e066aa83f4332087b5a/4a110924ab18972bcd1a19a2e4cd7b899e510ab8.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=42d17a169058d109c4e3a9bae159ccd0/61f5b2119313b07e550549600ed7912397dd8c21.jpg",
                          ];
        
        _photos1 = [NSMutableArray arrayWithCapacity:urls.count];
        for (NSString *url in urls) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:url];
            [_photos1 addObject:photo];
        }
        
    }
    return _photos1;
}

- (NSMutableArray *)assets2{
    if (!_assets2) {
        _assets2 = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",nil];
    }
    return _assets2;
}
- (NSMutableArray *)photos2{
    if (!_photos2) {
        NSArray *urls = @[
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=515dae6de7dde711e7d243fe97eecef4/6c236b600c3387446fc73114530fd9f9d72aa05b.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=1875d6474334970a47731027a5cbd1c0/51e876094b36acaf9e7b88947ed98d1000e99cc2.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=67ef9ea341166d223877159c76230945/e2f7f736afc3793138419f41e9c4b74543a911b7.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=a18485594e086e066aa83f4332087b5a/4a110924ab18972bcd1a19a2e4cd7b899e510ab8.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=42d17a169058d109c4e3a9bae159ccd0/61f5b2119313b07e550549600ed7912397dd8c21.jpg",
                          ];
        
        _photos2 = [NSMutableArray arrayWithCapacity:urls.count];
        for (NSString *url in urls) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:url];
            [_photos2 addObject:photo];
        }
        
    }
    return _photos2;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.collectionHH1.constant = (UIScreenWidth - 20)/3.0;
    self.collectionH2.constant = (UIScreenWidth - 20)/2.0 * (self.assets2.count/2 + 1);
}

@end
