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
{
    NSInteger _picIndex;//1:招牌照 2:内景照
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHH1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH2;

@property (nonatomic , strong) NSMutableArray *assets1;
@property (nonatomic , strong) NSMutableArray *photos1;
@property (nonatomic , strong) NSMutableArray *assets2;
@property (nonatomic , strong) NSMutableArray *photos2;

@property (nonatomic, strong)UIButton *rightBtn;//右键

@property (nonatomic, copy)NSString *picUrl;//招牌图片url
@property (nonatomic, strong)NSMutableArray *picUrlArr;//图片url数组

@end

static NSString *ID = @"LBStoreAmendPhotosCell";

@implementation LBFinishAmendPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];

    [self.collectionview1 registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.collectionview2 registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];

    [self postRequest];
    
}
#pragma mark - 设置导航栏

- (void)setNav{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"照片修改";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightBtn = button;
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = ba;
}

#pragma mark - 请求数据
- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"2";//1获取店铺资料 2获取商铺牌照
    dic[@"store_id"] = self.store_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_receive paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.assets1 removeAllObjects];
            [self.assets2 removeAllObjects];
            
            NSString *str = responseObject[@"data"][@"store_thumb"];
            
            if(str.length != 0){
                
                [self.assets1 addObject:responseObject[@"data"][@"store_thumb"]];
            }
            
            [self.assets2 addObjectsFromArray:responseObject[@"data"][@"store_homepage"]];
            
            [self assignment];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

#pragma mark - 赋值
- (void)assignment{
    
    [self.collectionview1 reloadData];
    [self.collectionview2 reloadData];
    
    if(self.assets2.count >= 4){
        self.collectionH2.constant = (UIScreenWidth - 20)/2.0 * 2;
    }else{
        self.collectionH2.constant = (UIScreenWidth - 20)/2.0 * (self.assets2.count/2 + 1);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 保存
- (void)save{
    
    [self creatDispathGroup];
}

#pragma mark -  上传图片 操作
-(void)creatDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLoding];
    self.rightBtn.enabled = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建任务
    NSInteger count1 = 0;
    self.picUrl = nil;
    for (int i = 0; i < self.assets1.count ; i++) {
        
        UIImage *image;
        if([[self.assets1 objectAtIndex:i] isKindOfClass:[NSString class]]){
            
            self.picUrl = [self.assets1 objectAtIndex:i];
        }else{
            count1 ++;
            if ([self.assets1 objectAtIndex:i] != nil && [[self.assets1 objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                
                ZLPhotoAssets *assets = [self.assets1 objectAtIndex:i];
                
                image = [assets originImage];
            
            }else if([[self.assets1 objectAtIndex:i] isKindOfClass:[UIImage class]]){
                
                image = [self.assets1 objectAtIndex:i];
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
    NSInteger count2 = 0;
    [self.picUrlArr removeAllObjects];
    
    for (int i = 0; i < self.assets2.count ; i++) {
        
        UIImage *image = [[UIImage alloc]init];
        if([[self.assets2 objectAtIndex:i] isKindOfClass:[NSString class]]){
            
            [self.picUrlArr addObject:[self.assets2 objectAtIndex:i]];
            
        }else{
            count2++;
            if ([self.assets2 objectAtIndex:i] != nil && [[self.assets2 objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                ZLPhotoAssets *assets = [self.assets2 objectAtIndex:i];
                image = [assets originImage];
                
            }else if([[self.assets2 objectAtIndex:i] isKindOfClass:[UIImage class]]){
                
                image = [self.assets2 objectAtIndex:i];
            }
            
            //type 1:招牌照 2:内景照
            dispatch_group_async(group, queue, ^{
                [weakSelf uploadImageV:image type:2 block:^(){ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
                    
                    //一个任务结束时标记一个信号量
                    dispatch_semaphore_signal(semaphore);
                }];
            });
            
        }
   
    }

    dispatch_group_notify(group, queue, ^{
        //2个任务,2个信号等待.
        for (int i = 0; i < (count1 + count2) ; i++) {
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{//返回主线程
            
            //这里就是所有异步任务请求结束后执行的代码
            [weakSelf modifyPic];
            
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
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:URL_Base]];
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kappend_upload] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (image) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
            NSString *title = [NSString stringWithFormat:@"uploadfile"];
            NSData *data;
            data = UIImageJPEGRepresentation(image,1);
            [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if(type == 1){
                self.picUrl = responseObject[@"data"][@"url"];
            }else{
                
                [self.picUrlArr addObject:responseObject[@"data"][@"url"]];
            }
        }
        
        finish();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finish();
    }];
    
}

/**
 修改内景照和招牌照
 */
- (void)modifyPic{
    
    if (self.picUrl.length == 0) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showInfoText:@"请重新上传招牌照"];
        return;
    }
    
    if (self.picUrlArr.count == 0) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showInfoText:@"请至少上传一张内景照"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"store_id"] = self.store_id;
    dic[@"type"] = @"2";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"thumb"] = self.picUrl;
    
    for (int i = 0; i < self.picUrlArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"homepage[%zd]",i];
        dic[str] = self.picUrlArr[i];
    }
    
    [NetworkManager requestPOSTWithURLStr:kstore_info_edit paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.rightBtn.enabled = YES;
            [EasyShowTextView showSuccessText:@"已保存"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        self.rightBtn.enabled = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];

}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.collectionview1) {
        return 1;
    }else{
        if (self.assets2.count >= 4) {
            return 4;
        }else{
            return self.assets2.count + 1;
        }
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBStoreAmendPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.index = indexPath.row;
    
    if (collectionView == self.collectionview1) {
        
        //删除
        if (indexPath.item == self.assets1.count) {
            cell.deleteBt.hidden = YES;
            cell.imagev.image = [UIImage imageNamed:@"addphotograph"];
        }else{
            
            if ([self.assets1 objectAtIndex:indexPath.row] != nil && [[self.assets1 objectAtIndex:indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
                ZLPhotoAssets *assets = [self.assets1 objectAtIndex:indexPath.row];
                
                cell.imagev.image = [assets thumbImage];
                
            }else if([[self.assets1 objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
                
                cell.imagev.image = [self.assets1 objectAtIndex:indexPath.row];
                
            } else{

                NSString *url = [self.assets1 objectAtIndex:indexPath.row];
                [cell.imagev sd_setImageWithURL:[NSURL URLWithString:url]];
                
            }
            
            cell.deleteBt.hidden = NO;
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
            
            if ([self.assets2 objectAtIndex:indexPath.row] != nil && [[self.assets2 objectAtIndex:indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
                ZLPhotoAssets *assets = [self.assets2 objectAtIndex:indexPath.row];
                
                cell.imagev.image = [assets thumbImage];
                
            }else if([[self.assets2 objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
                
                cell.imagev.image = [self.assets2 objectAtIndex:indexPath.row];
                
            } else{

                NSString *url = [self.assets2 objectAtIndex:indexPath.row];
                [cell.imagev sd_setImageWithURL:[NSURL URLWithString:url]];
                
            }
            
            cell.deleteBt.hidden = NO;
            
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
        _picIndex = 1;
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
            
//            HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
            
            [pc addAction:action1];
            [pc addAction:action2];
//            [pc addAction:action3];
            [pc addAction:action4];
            
            [self presentViewController:pc animated:YES completion:nil];
        }else{//放大
            [self tapBrowser:indexPath.row andPicIndex:1];
            
        }
    }else{
        _picIndex = 2;
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
            
//            HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
            
            HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
            
            [pc addAction:action1];
            [pc addAction:action2];
//            [pc addAction:action3];
            [pc addAction:action4];
            
            [self presentViewController:pc animated:YES completion:nil];
        }else{//放大
            [self tapBrowser:indexPath.row andPicIndex:2];
            
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
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else{
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        if(_picIndex == 1){//招牌照
            [self.assets1 addObject:image];
        }else{//2:内景照
            [self.assets2 addObject:image];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    if(_picIndex == 1){//招牌照
        
        [self.collectionview1 reloadData];
    }else{
        [self.collectionview2 reloadData];
    }
}

#pragma mark - 选择图片
- (void)photoSelectet:(NSMutableArray*)assets collectionview:(UICollectionView*)collectionview{
    
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    
    if (_picIndex == 1) {
        
        pickerVc.maxCount = 1;
        
    }else{
        pickerVc.maxCount = 4;
        
        [self.assets2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImage class]] || [obj isKindOfClass:[NSString class]]) {
                pickerVc.maxCount = pickerVc.maxCount - 1;
            }
        }];
    }
    
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.selectPickers = assets;
    
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    
    WeakSelf;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 0; i < assets.count; i ++) {
            if([assets[i] isKindOfClass:[ZLPhotoAssets class]]){
                [arrM addObject:assets[i]];
            }
        }
        
        [assets removeObjectsInArray:arrM];
        [assets addObjectsFromArray:status.mutableCopy];
        [collectionview reloadData];
        
        if(weakSelf.assets2.count >= 4){
            weakSelf.collectionH2.constant = (UIScreenWidth - 20)/2.0 * 2;
        }else{
            weakSelf.collectionH2.constant = (UIScreenWidth - 20)/2.0 * (self.assets2.count/2 + 1);
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [weakSelf.view layoutIfNeeded];
        }];
        
    };
    [pickerVc showPickerVc:self];
}

- (void)tapBrowser:(NSInteger)index andPicIndex:(NSInteger)picIndex{
//    // 图片游览器
//    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
//    // 淡入淡出效果
//    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
//    // 数据源/delegate
//    pickerBrowser.editing = YES;
//    
//    NSMutableArray *arrM = [NSMutableArray array];
//    if (picIndex == 1) {//招牌照
//        for (id photo in self.assets1) {
//            ZLPhotoPickerBrowserPhoto *photoNew = [[ZLPhotoPickerBrowserPhoto alloc] init];
//            if (photo != nil && [photo isKindOfClass:[ZLPhotoAssets class]]) {
//                
//                ZLPhotoAssets *assets = [self.assets1 objectAtIndex:index];
//                photoNew.asset = assets;
//                
//            }else{
//                
//                photoNew = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:photo];
//            }
//            [arrM addObject:photoNew];
//        }
//        
//    }else{//内景照
//        
//        for (id photo in self.assets2) {
//            ZLPhotoPickerBrowserPhoto *photoNew = [[ZLPhotoPickerBrowserPhoto alloc] init];
//            if (photo != nil && [photo isKindOfClass:[ZLPhotoAssets class]]) {
//                
//                ZLPhotoAssets *assets = [self.assets2 objectAtIndex:index];
//                photoNew.asset = assets;
//                
//            }else{
//                
//                photoNew = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:photo];
//            }
//            [arrM addObject:photoNew];
//        }
//    }
//    
//    pickerBrowser.photos = arrM;
//    // 能够删除
//    pickerBrowser.delegate = self;
//    // 当前选中的值
//    pickerBrowser.currentIndex = index;
//    // 展示控制器
//    [pickerBrowser showPickerVc:self];
}
//
//- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
//    if (_picIndex == 1) {//招牌照
//        if (self.assets1.count > index) {
//            [self.assets1 removeObjectAtIndex:index];
//            [self.collectionview1 reloadData];
//        }
//    }else{
//        if (self.assets2.count > index) {
//            [self.assets2 removeObjectAtIndex:index];
//            [self.collectionview2 reloadData];
//        }
//    }
//}

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
        _assets1 = [NSMutableArray array];
    }
    return _assets1;
}

- (NSMutableArray *)assets2{
    if (!_assets2) {
        _assets2 = [NSMutableArray array];
    }
    return _assets2;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.collectionHH1.constant = (UIScreenWidth - 20)/3.0;
    self.collectionH2.constant = (UIScreenWidth - 20)/2.0 * (self.assets2.count/2 + 1);
    
}

//图片url数组
- (NSMutableArray *)picUrlArr{
    if (!_picUrlArr) {
        _picUrlArr = [NSMutableArray array];
    }
    return _picUrlArr;
}

@end
