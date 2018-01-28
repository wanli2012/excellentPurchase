//
//  LBAddOrEditProductViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddOrEditProductViewController.h"
#import "LBStoreAmendPhotosCell.h"
#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIImage+ZLPhotoLib.h"
#import "ReactiveCocoa.h"
#import "LBAddOrEditProductChooseView.h"
#import "LBAddOrEditProductChooseSingalView.h"
#import "SXAlertView.h"

@interface LBAddOrEditProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HCBasePopupViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UILabel *limitLb;//现在字数
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

static NSString *ID = @"LBStoreAmendPhotosCell";

@implementation LBAddOrEditProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加商品";
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    
    __weak typeof(self) wself = self;
    [[self.textView rac_textSignal]subscribeNext:^(NSString *x) {
        NSLog(@"%@",x);
            wself.limitLb.text = [NSString stringWithFormat:@"还剩%ld字",100 - x.length];
        
    }];
    
}

/**
 分类

 @param sender <#sender description#>
 */
- (IBAction)tapgestureChoose:(UITapGestureRecognizer *)sender {
    
    [LBAddOrEditProductChooseView showWholeClassifyViewBlock:^(NSInteger section) {
        
    } cancelBlock:^{
        
    }];
}

/**
 品牌

 @param sender <#sender description#>
 */
- (IBAction)tapgesturebrand:(UITapGestureRecognizer *)sender {
    
    [LBAddOrEditProductChooseSingalView showWholeClassifyViewBlock:^(NSInteger section) {
        
    } cancelBlock:^{
        
    }];
    
}

/**
 提示消息

 @param sender <#sender description#>
 */
- (IBAction)noticeEvent:(UIButton *)sender {
    [SXAlertView showWithTitle:@"温馨提示" message:@"我的万册完成范文芳测无法测完饭" cancelButtonTitle:@"取消" otherButtonTitle:nil clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSUInteger buttonIndex) {
        
    }];
    
}

#pragma mark - HCBasePopupViewControllerDelegate 个协议方法来自定义你的弹出框内容
- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller{
    
}

- (void)didTapMaskViewWithMaskView:(UIView *)maskView withController:(UIViewController *)controller{
    
}
#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBStoreAmendPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //删除
    if (indexPath.item == self.assets.count) {
        cell.deleteBt.hidden = YES;
        cell.imagev.image = [UIImage imageNamed:@"addphotograph"];
    }else{
        cell.deleteBt.hidden = NO;
        cell.imagev.image = [UIImage imageNamed:self.assets[indexPath.item]];
    }
    cell.deleteBlock = ^(NSInteger index) {
        [self.assets removeObjectAtIndex:index];
        [self.collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.assets.count) {//选择照片
        HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
        __weak typeof(self) wself = self;
        HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"拍照" withSelectedBlock:^{
            [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            [wself getcamera];
        } withType:HCBottomPopupActionSelectItemTypeDefault];
        HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"从手机相册选择" withSelectedBlock:^{
            [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            [wself photoSelectet];
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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 20)/3.0, (UIScreenWidth - 20)/3.0);
    
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
- (void)photoSelectet{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 9
    pickerVc.maxCount = 1;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Recoder Select Assets
    pickerVc.selectPickers = self.assets;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        [self.assets addObject: status.mutableCopy];
        [self.collectionView reloadData];
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
    pickerBrowser.photos = self.photos;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength > 100) {
        return NO;
    }
    
    return YES;
    
}

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray arrayWithObject:@"1"];
    }
    return _assets;
}
- (NSMutableArray *)photos{
    if (!_photos) {
        NSArray *urls = @[
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=515dae6de7dde711e7d243fe97eecef4/6c236b600c3387446fc73114530fd9f9d72aa05b.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=1875d6474334970a47731027a5cbd1c0/51e876094b36acaf9e7b88947ed98d1000e99cc2.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=67ef9ea341166d223877159c76230945/e2f7f736afc3793138419f41e9c4b74543a911b7.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=a18485594e086e066aa83f4332087b5a/4a110924ab18972bcd1a19a2e4cd7b899e510ab8.jpg",
                          @"http://imgsrc.baidu.com/forum/w%3D580/sign=42d17a169058d109c4e3a9bae159ccd0/61f5b2119313b07e550549600ed7912397dd8c21.jpg",
                          ];
        
        _photos = [NSMutableArray arrayWithCapacity:urls.count];
        for (NSString *url in urls) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:url];
            [_photos addObject:photo];
        }
        
    }
    return _photos;
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.collectionH.constant = (UIScreenWidth - 20)/3.0;
    
}

@end
