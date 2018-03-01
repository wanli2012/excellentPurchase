//
//  GLMine_Team_UploadLicenseController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_UploadLicenseController.h"

@interface GLMine_Team_UploadLicenseController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImageV;

@property (nonatomic, strong)UIButton *rightBtn;

@end

@implementation GLMine_Team_UploadLicenseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    if (self.firstUrl.length != 0) {
        
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.firstUrl] placeholderImage:nil];
        if (self.imageV.image == nil) {
            self.placeHolderImageV.hidden = NO;
        }else{
            self.placeHolderImageV.hidden = YES;
        }
    }
}

/**
 导航栏设置
 */
- (void)setNav{
    
//    self.navigationItem.title = @"上传营业执照";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    self.rightBtn = button;
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

//保存
- (void)save{
    
    if (self.imageV.image == nil) {
        [EasyShowTextView showInfoText:@"请上传营业执照"];
        return;
    }
    
    [self uploadImage];
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
    
    self.rightBtn.enabled = NO;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:URL_Base]];
    if ([URL_Base containsString:@"https"]) {
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    }
    
    manager.requestSerializer.timeoutInterval = 20;
    [EasyShowLodingView showLodingText:@"上传中"];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kappend_upload] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (self.imageV.image) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
            NSString *title = [NSString stringWithFormat:@"uploadfile"];
            NSData *data;
            data = UIImageJPEGRepresentation(self.imageV.image,0.1);
            [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/jpeg"];
            [EasyShowLodingView showLodingText:@"图片上传中"];
        }
    
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.rightBtn.enabled = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showSuccessText:@"上传成功"];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.firstUrl = responseObject[@"data"][@"url"];
            
            if(self.block){
                self.block(self.firstUrl);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.rightBtn.enabled = YES;
        [EasyShowTextView showErrorText:error.localizedDescription];
        [EasyShowLodingView hidenLoding];
        
    }];
}

//拍照颗照片选取
- (IBAction)choosePicType:(id)sender {
    
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePic = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self; //设置代理
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; //图片来源
        [self presentViewController:imagePickerController animated:YES completion:nil];

    }];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self; //设置代理
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片来源
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertV addAction:takePic];
    [alertV addAction:photos];
    [alertV addAction:cancel];
    
    [self presentViewController:alertV animated:YES completion:nil];
    
}
#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    self.imageV.image = image;  //给UIimageView赋值已经选择的相片
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍

}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
@end
