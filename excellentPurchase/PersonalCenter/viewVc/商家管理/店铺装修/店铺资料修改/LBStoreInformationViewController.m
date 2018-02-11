//
//  LBStoreInformationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreInformationViewController.h"
#import "LBStoreAmendPhotosCell.h"
#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIImage+ZLPhotoLib.h"

#import "GLStoreInfomationModel.h"
#import "LBBaiduMapViewController.h"//地图

@interface LBStoreInformationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HCBasePopupViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;//店铺名
@property (weak, nonatomic) IBOutlet UITextField *shopAddressTF;//店铺地址
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//联系电话
@property (weak, nonatomic) IBOutlet UITextField *coordinateTF;//坐标

@property (nonatomic, strong)GLStoreInfomationModel *model;
@property (nonatomic, copy)NSString *picUrl;//招牌图片url
@property (nonatomic, copy)NSString *longitude;//经度
@property (nonatomic, copy)NSString *latitude;//纬度

@end

static NSString *ID = @"LBStoreAmendPhotosCell";

@implementation LBStoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"店铺资料修改";
    
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self postRequest];
    
}

#pragma mark - 请求数据
- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"1";//1获取店铺资料 2获取商铺牌照
    dic[@"store_id"] = self.store_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_receive paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            GLStoreInfomationModel *model = [GLStoreInfomationModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.model = model;
            
            [self assignment];//赋值
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

/**
 赋值
 */
- (void)assignment{
    
    self.shopNameTF.text = self.model.store_name;
    self.shopAddressTF.text = self.model.store_address;
    self.phoneTF.text = self.model.store_phone;
    
    self.longitude = self.model.store_longitude;
    self.latitude = self.model.store_latitude;
    
    self.coordinateTF.text = [NSString stringWithFormat:@"%@,%@",self.model.store_longitude,self.model.store_latitude];
    
    [self.assets removeAllObjects];
    [self.assets addObject:self.model.store_license_pic];
    [self.collectionView reloadData];
}

/**
 坐标选择
 */
- (IBAction)coordinateChoose:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
    WeakSelf;
    mapVC.returePositon = ^(NSString *strposition, NSString *pro, NSString *city, NSString *area, CLLocationCoordinate2D coors) {
      
        weakSelf.longitude = [NSString stringWithFormat:@"%f",coors.longitude];
        weakSelf.latitude = [NSString stringWithFormat:@"%f",coors.latitude];
        
        weakSelf.coordinateTF.text = [NSString stringWithFormat:@"%@,%@",weakSelf.longitude,weakSelf.latitude];
    };
    
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    [self creatDispathGroup];
}

#pragma mark -  上传图片 操作
-(void)creatDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLoding];
    
    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
    self.submitBtn.enabled = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建任务
    NSInteger count1 = 0;
    self.picUrl = nil;
    for (int i = 0; i < self.assets.count ; i++) {
        
        UIImage *image;
        if([[self.assets objectAtIndex:i] isKindOfClass:[NSString class]]){
            
            self.picUrl = [self.assets objectAtIndex:i];
        }else{
            count1 ++;
            if ([self.assets objectAtIndex:i] != nil && [[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                
                ZLPhotoAssets *assets = [self.assets objectAtIndex:i];
                
                image = [assets originImage];
                
            }else if([[self.assets objectAtIndex:i] isKindOfClass:[UIImage class]]){
                
                image = [self.assets objectAtIndex:i];
            }
            //            type 1:招牌照 2:内景照
            dispatch_group_async(group, queue, ^{
                [weakSelf uploadImageV:image type:1 block:^(){ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
                    
                    //一个任务结束时标记一个信号量
                    dispatch_semaphore_signal(semaphore);
                }];
            });
        }
    }
    
    dispatch_group_notify(group, queue, ^{
        //2个任务,2个信号等待.
        for (int i = 0; i < count1 ; i++) {
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{//返回主线程
            
            //这里就是所有异步任务请求结束后执行的代码
            [weakSelf submitRequest];
            
        });
    });
}

/**
 上传图片请求
 
  @param image 需要上传的图片
 @param finish 请求结束信号
 */
-(void)uploadImageV:(UIImage *)image type:(NSInteger)type block:(void(^)(void))finish
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"2";//图片保存文件区别 1goods 2store 3user
    dic[@"port"] = kPORT;//端口 1.pc 2.安卓 3.ios 4.H5手机网站
    dic[@"app_version"] = kAPP_VERSION;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kappend_upload] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        NSString *title = [NSString stringWithFormat:@"uploadfile"];
        
        NSData *data;
        
        data = UIImageJPEGRepresentation(image,1);
        
        [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.picUrl = responseObject[@"data"][@"url"];
        }
        
        finish();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finish();
    }];
}

/**
 提交
 */
- (void)submitRequest{

    if (self.shopNameTF.text.length == 0) {
        
        [EasyShowTextView showInfoText:@"请填写店铺名"];
        return;
    }
    
    if (self.shopAddressTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写店铺地址"];
        return;
    }
    
    if (self.phoneTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写联系电话"];
        
        return;
    }
    if(self.longitude.length == 0 || self.latitude.length == 0){
        [EasyShowTextView showInfoText:@"请定位经纬度"];
        
        return;
    }
    
    if (self.picUrl.length == 0) {
        [EasyShowTextView showInfoText:@"请重新上传营业执照"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"UPDATE";
    dic[@"store_id"] = self.store_id;
    dic[@"type"] = @"1";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"name"] = self.shopNameTF.text;
    dic[@"address"] = self.shopAddressTF.text;
    dic[@"store_pre"] = @"+86";
    dic[@"phone"] = self.phoneTF.text;
    dic[@"lng"] = self.longitude;
    dic[@"lat"] = self.latitude;
    dic[@"license_pic"] = self.picUrl;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_info_edit paramDic:dic finish:^(id responseObject) {
        
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"修改资料成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
        
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

#pragma mark - HCBasePopupViewControllerDelegate 个协议方法来自定义你的弹出框内容
- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller{
    
}

- (void)didTapMaskViewWithMaskView:(UIView *)maskView withController:(UIViewController *)controller{
    
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBStoreAmendPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.index = indexPath.row;
    
    //删除
    if (self.assets.count == 0) {
        cell.deleteBt.hidden = YES;
        cell.imagev.image = [UIImage imageNamed:@"addphotograph"];
        
    }else{
        
        if ([self.assets objectAtIndex:indexPath.row] != nil && [[self.assets objectAtIndex:indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
            
            ZLPhotoAssets *assets = [self.assets objectAtIndex:indexPath.row];
            cell.imagev.image = [assets thumbImage];
            
        }else if([[self.assets objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
            
            cell.imagev.image = [self.assets objectAtIndex:indexPath.row];
            
        }else{
            
            NSString *url = [self.assets objectAtIndex:indexPath.row];
            if (url.length != 0) {
                
                [cell.imagev sd_setImageWithURL:[NSURL URLWithString:url]];
            }
            
        }
        
        cell.deleteBt.hidden = NO;
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

//        HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];

        HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];

        [pc addAction:action1];
        [pc addAction:action2];
//        [pc addAction:action3];
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
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        [self.assets addObject:image];
    
        [self.collectionView reloadData];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - 选择图片
- (void)photoSelectet{
    
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    
    pickerVc.maxCount = 1;
    
    [self.assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]] || [obj isKindOfClass:[NSString class]]) {
            pickerVc.maxCount = pickerVc.maxCount - 1;
        }
    }];

    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.selectPickers = self.assets;

    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;

    WeakSelf;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        for (int i = 0; i < weakSelf.assets.count; i ++) {
            if([weakSelf.assets[i] isKindOfClass:[ZLPhotoAssets class]]){
                [weakSelf.assets removeObject:weakSelf.assets[i]];
            }
        }
        
        [weakSelf.assets addObjectsFromArray:status.mutableCopy];
        [weakSelf.collectionView reloadData];
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
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (id photo in self.assets) {
        ZLPhotoPickerBrowserPhoto *photoNew = [[ZLPhotoPickerBrowserPhoto alloc] init];
        if (photo != nil && [photo isKindOfClass:[ZLPhotoAssets class]]) {
            
            ZLPhotoAssets *assets = [self.assets objectAtIndex:index];
            photoNew.asset = assets;
            
        }else{
            
            photoNew = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:photo];
        }
        [arrM addObject:photoNew];
    }
    
    pickerBrowser.photos = arrM;
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
    }
    [self.collectionView reloadData];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}

#pragma mark - 懒加载

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.collectionH.constant = (UIScreenWidth - 20)/3.0;
}


@end
