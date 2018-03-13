//
//  LBUploadIdentityPictureViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/16.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBUploadIdentityPictureViewController.h"
#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"

@interface LBUploadIdentityPictureViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *faceImageV;
@property (weak, nonatomic) IBOutlet UIImageView *oppositeImageV;
@property (weak, nonatomic) IBOutlet UIImageView *oppositeSignImageV;
@property (weak, nonatomic) IBOutlet UIImageView *faceSignImageV;

@property (nonatomic, strong)UIButton *saveBtn;//保存

@property (nonatomic, assign)BOOL isFacePic;//是否为正面照

@end

@implementation LBUploadIdentityPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    if (self.faceUrl.length != 0) {
        
        [self.faceImageV sd_setImageWithURL:[NSURL URLWithString:self.faceUrl] placeholderImage:nil];
        if (self.faceSignImageV.image == nil) {
            self.faceSignImageV.hidden = NO;
        }else{
            self.faceSignImageV.hidden = YES;
        }
    }
    
    if (self.oppositeUrl.length != 0) {
        [self.oppositeImageV sd_setImageWithURL:[NSURL URLWithString:self.oppositeUrl] placeholderImage:nil];
        if (self.oppositeSignImageV.image == nil) {
            self.oppositeSignImageV.hidden = NO;
        }else{
            self.oppositeSignImageV.hidden = YES;
        }
    }
}

/**
 导航栏设置
 */
- (void)setNav{
    
    self.navigationItem.title = @"上传身份证";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    self.saveBtn = button;
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 保存
 */
- (void)save{
    
    if (self.faceImageV.image == nil) {
        [EasyShowTextView showInfoText:@"请上传身份证正面照"];
        return;
    }
    
    if (self.oppositeImageV.image == nil) {
        [EasyShowTextView showInfoText:@"请上传身份证反面照"];
        return;
    }
    
    [self creatDispathGroup];
}

#pragma mark - 上传图片 操作

-(void)creatDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLodingText:@"图片上传中"];
    
//    self.saveBtn.enabled = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建任务
    UIImage *image = self.faceImageV.image;
    dispatch_group_async(group, queue, ^{
        [weakSelf uploadImageV:image type:1 block:^(){ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
            
            //一个任务结束时标记一个信号量
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    
    UIImage *image2 = self.oppositeImageV.image;
    dispatch_group_async(group, queue, ^{
        [weakSelf uploadImageV:image2 type:2 block:^(){ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
            
            //一个任务结束时标记一个信号量
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        //2个任务,2个信号等待.
      
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{//返回主线程
            [EasyShowLodingView hidenLoding];
            
            if(weakSelf.faceUrl.length == 0){
                [EasyShowTextView showInfoText:@"身份证正面照上传失败"];
                return;
            }
            
            if(weakSelf.oppositeUrl.length == 0){
                [EasyShowTextView showInfoText:@"身份证反面照上传失败"];
                return;
            }
            
            //这里就是所有异步任务请求结束后执行的代码
            if(weakSelf.block){
                weakSelf.block(weakSelf.faceUrl, weakSelf.oppositeUrl);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        });
    });
}

///**
// 上传图片请求
//
// @param image 需要上传的图片
// @param finish 请求结束信号
// */
-(void)uploadImageV:(UIImage *)image type:(NSInteger)type block:(void(^)(void))finish
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"3";//图片保存文件区别 1goods 2store 3user
    dic[@"port"] = kPORT;//端口 1.pc 2.安卓 3.ios 4.H5手机网站
    dic[@"app_version"] = kAPP_VERSION;

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:URL_Base]];
    if ([URL_Base containsString:@"https"]) {
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    }
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
                self.faceUrl = responseObject[@"data"][@"url"];
            }else if(type == 2){
                self.oppositeUrl = responseObject[@"data"][@"url"];
            }
        }

        finish();

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        finish();
    }];
}

/**
 上传正面照 和 反面
 */
- (IBAction)uploadIDPic:(UITapGestureRecognizer *)sender {
    
    HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
    
    if (sender.view.tag == 11) {//正面
        self.isFacePic = YES;
    }else{//反面
        self.isFacePic = NO;
    }
    
    __weak typeof(self) wself = self;
    HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"拍照" withSelectedBlock:^{
        [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        [wself getcamera];
    } withType:HCBottomPopupActionSelectItemTypeDefault];
    
    HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"从手机相册选择" withSelectedBlock:^{
        [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        [wself getImageFromIpc];
    } withType:HCBottomPopupActionSelectItemTypeDefault];
    
    HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
    
    [pc addAction:action1];
    [pc addAction:action2];
    [pc addAction:action4];
    
    [self presentViewController:pc animated:YES completion:nil];
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
    
//    NSString *type = [info objectForKey:UIImagePickerControllerEditedImage];
//    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
//        UIImage *image = [info UIImagePickerControllerOriginalImage];
    
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        if (self.isFacePic) {
            self.faceImageV.image = [UIImage imageWithData:data];
            
            if (self.faceSignImageV.image == nil) {
                self.faceSignImageV.hidden = NO;
            }else{
                self.faceSignImageV.hidden = YES;
            }
            
        }else{
            
            self.oppositeImageV.image = [UIImage imageWithData:data];
            
            if (self.oppositeSignImageV.image == nil) {
                self.oppositeSignImageV.hidden = NO;
            }else{
                self.oppositeSignImageV.hidden = YES;
            }
        }

        [picker dismissViewControllerAnimated:YES completion:nil];
        
//    }
}

#pragma mark - 相册读取
- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;

    // 4.设置代理
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];

}


@end
