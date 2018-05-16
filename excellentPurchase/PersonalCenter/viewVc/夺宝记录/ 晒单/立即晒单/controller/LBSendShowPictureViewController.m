////
//  LBSendShowPictureViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendShowPictureViewController.h"
#import "LBSendShowinfoViewcell.h"
#import "LBSendShowPicturecell.h"
#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIImage+ZLPhotoLib.h"


@interface LBSendShowPictureViewController ()<UITableViewDelegate,UITableViewDataSource,LBSendShowPicturedelegete,HCBasePopupViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic , strong) NSMutableArray *assets1;
@property (nonatomic , strong) NSMutableArray *assets2;
@property (nonatomic , strong) NSMutableArray *assets3;
@property (nonatomic , strong) NSString *content;
@property (nonatomic, copy)NSMutableArray *picUrl;//图片url
@property (weak, nonatomic) IBOutlet UIButton *submutbt;
@property (nonatomic , assign) NSInteger  isuploadfail;//判断图片是否上传失败 默认为0 1为失败

@end

static NSString *sendShowinfoViewcell = @"LBSendShowinfoViewcell";
static NSString *sendShowPicturecell = @"LBSendShowPicturecell";

@implementation LBSendShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"晒单";
    _assets1 = [NSMutableArray array];
    _assets2 = [NSMutableArray array];
    _assets3 = [NSMutableArray array];
    _content = [NSString string];
    _picUrl = [NSMutableArray array];
    [self.tableview registerNib:[UINib nibWithNibName:sendShowinfoViewcell bundle:nil] forCellReuseIdentifier:sendShowinfoViewcell];
    [self.tableview registerNib:[UINib nibWithNibName:sendShowPicturecell bundle:nil] forCellReuseIdentifier:sendShowPicturecell];
}

- (IBAction)submitEvent:(UIButton *)sender {
    
    if ([NSString StringIsNullOrEmpty:self.content]) {
        [EasyShowTextView showErrorText:@"请文字描述"];
        return;
    }
    
    if (self.assets1.count <= 0) {
        [EasyShowTextView showErrorText:@"请上传图片"];
        return;
    }
    
    [self creatDispathGroup];
    
}

#pragma mark -  上传图片 操作
-(void)creatDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLoding];
    self.submutbt.enabled = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建任务
    NSInteger count1 = 0;
    for (int i = 0; i < self.assets1.count ; i++) {
        
        UIImage *image;
        if([[self.assets1 objectAtIndex:i] isKindOfClass:[NSString class]]){
            
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
                [weakSelf uploadImageV:image  block:^(){ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
                    
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
            
            if (self.isuploadfail == 1) {
                [EasyShowTextView showSuccessText:@"上传图片失败"];
            }else{
                //这里就是所有异步任务请求结束后执行的代码
                [weakSelf sendPic];
            }
            
        });
    });
}


/**
 上传图片请求
 
 @param image 需要上传的图片
 @param finish 请求结束信号
 */
-(void)uploadImageV:(UIImage *)image  block:(void(^)(void))finish
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"4";//图片保存文件区别 1goods 2store 3user
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
            
                [self.picUrl addObject:responseObject[@"data"][@"url"]];
            
        }else{
            self.isuploadfail = 1;
        }
        
        finish();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish();
        self.isuploadfail = 1;
    }];
    
}

-(void)sendPic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"thumb"] = [self.picUrl componentsJoinedByString:@","];
    dic[@"content"] = self.content;
    dic[@"indiana_id"] = self.indiana_id;
    
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_slide paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.submutbt.enabled = YES;
            [EasyShowTextView showSuccessText:@"晒图成功"];
            if (self.uploadsucess) {
                self.uploadsucess();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        self.submutbt.enabled = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

#pragma mark - LBSendShowPicturedelegete
-(void)delegetepicture:(NSInteger)index{
    [self.assets1 removeObjectAtIndex:index];
    [self.tableview reloadData];
}

-(void)bigpicture:(NSInteger)index{
    
     [self tapBrowser:index];

}

-(void)choosepicture{
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
    
    //            HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
    
    HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
    
    [pc addAction:action1];
    [pc addAction:action2];
    //            [pc addAction:action3];
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
        }else{
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        
        [self.assets1 insertObject:image atIndex:0];
      
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self.tableview reloadData];
}

-(void)photoSelectet{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
     pickerVc.maxCount = 5 ;
    [self.assets1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]] || [obj isKindOfClass:[NSString class]]) {
            pickerVc.maxCount = pickerVc.maxCount - 1;
        }
    }];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.selectPickers = self.assets2;
    
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    
    WeakSelf;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 0; i < weakSelf.assets2.count; i ++) {
            if([self.assets2[i] isKindOfClass:[ZLPhotoAssets class]]){
                [arrM addObject:weakSelf.assets2[i]];
            }
        }
        
        [weakSelf.assets2 removeObjectsInArray:arrM];
        [weakSelf.assets2 addObjectsFromArray:status.mutableCopy];
        NSRange range=NSMakeRange(0,[weakSelf.assets2 count]);
        [self.assets1 insertObjects:self.assets2 atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        [weakSelf.tableview reloadData];
        
    };
    [pickerVc showPickerVc:self];

}
- (void)tapBrowser:(NSInteger)index{
        // 图片游览器
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        // 淡入淡出效果
        pickerBrowser.status = UIViewAnimationAnimationStatusFade;
        // 数据源/delegate
        pickerBrowser.editing = YES;
    
        NSMutableArray *arrM = [NSMutableArray array];

            for (id photo in self.assets1) {
                ZLPhotoPickerBrowserPhoto *photoNew = [[ZLPhotoPickerBrowserPhoto alloc] init];
                if (photo != nil && [photo isKindOfClass:[ZLPhotoAssets class]]) {
    
                    ZLPhotoAssets *assets = (ZLPhotoAssets*)photo;
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
        pickerBrowser.currentIndex = index;
        // 展示控制器
        [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{

        if (self.assets1.count > index) {
            [self.assets1 removeObjectAtIndex:index];
            [self.tableview reloadData];
        }
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 132;
    }
    
    return UIScreenWidth/3.0 + UIScreenWidth/3.0  * ((self.assets1.count ) / 3);
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LBSendShowinfoViewcell *cell = [tableView dequeueReusableCellWithIdentifier:sendShowinfoViewcell forIndexPath:indexPath];
        WeakSelf;
        cell.returntext = ^(NSString *content) {
            weakSelf.content = content;
        };
        return cell;
    }else{
        LBSendShowPicturecell *cell = [tableView dequeueReusableCellWithIdentifier:sendShowPicturecell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
        cell.imagearrdata = self.assets1;
        return cell;
    }
    
}

@end
