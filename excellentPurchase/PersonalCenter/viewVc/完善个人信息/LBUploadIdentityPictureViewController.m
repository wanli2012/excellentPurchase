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

@property (nonatomic, assign)BOOL isFacePic;//是否为正面照

@property (nonatomic, copy)NSString *faceUrl;//正面照url
@property (nonatomic, copy)NSString *oppositeUrl;//反面照url

@end

@implementation LBUploadIdentityPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];

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
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 保存
 */
- (void)save{
    
    if (self.faceUrl.length == 0) {
        [EasyShowTextView showInfoText:@"请上传身份证正面照"];
        return;
    }
    
    if (self.oppositeUrl.length == 0) {
        [EasyShowTextView showInfoText:@"请上传身份证反面照"];
        return;
    }
    
    if(self.block){
        self.block(self.faceUrl, self.oppositeUrl);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 上传图片
 */
- (void)uploadImage{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"3";
    dic[@"port"] = @"3";//端口 1.pc 2.安卓 3.ios 4.H5手机网站
    dic[@"app_version"] = @"1.0.0";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kappend_upload] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        NSString *title = [NSString stringWithFormat:@"uploadfile"];
        
        NSData *data;
        
        if(self.isFacePic){
            data = UIImageJPEGRepresentation(self.faceSignImageV.image,1);
        }else{
            data = UIImageJPEGRepresentation(self.oppositeSignImageV.image,1);
        }
    
        [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/jpeg"];

        [EasyShowLodingView showLodingText:@"图片上传中"];
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showSuccessText:@"上传成功"];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (self.isFacePic) {
                self.faceUrl = responseObject[@"data"][@"url"];
            }else{
                self.oppositeUrl = responseObject[@"data"][@"url"];
            }
            
        }else{

            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
        
        [EasyShowLodingView hidenLoding];
        
//        self.submitBtn.userInteractionEnabled = YES;
//        self.submitBtn.backgroundColor = MAIN_COLOR;
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
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
        [self uploadImage];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
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
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
//// 获取图片后的操作
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    // 销毁控制器
//    [picker dismissViewControllerAnimated:YES completion:nil];
//
//    // 设置图片
//    self.imageView.image = info[UIImagePickerControllerOriginalImage];
//}


@end
