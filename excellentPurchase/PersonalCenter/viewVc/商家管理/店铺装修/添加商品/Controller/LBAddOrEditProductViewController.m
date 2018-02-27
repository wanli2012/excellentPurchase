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

#import "GLAddOrEditProductCateModel.h"

@interface LBAddOrEditProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HCBasePopupViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSInteger _cameraCount;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;
@property (nonatomic , strong) NSMutableArray *assets;
//@property (nonatomic , strong) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UILabel *limitLb;//现在字数
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong)NSMutableArray *titlesArr;
@property (nonatomic, strong)GLAddOrEditProductCateModel *model;

@property (weak, nonatomic) IBOutlet UITextField *goodsNameTF;//商品名字
@property (weak, nonatomic) IBOutlet UITextField *brandTF;//品牌
@property (weak, nonatomic) IBOutlet UITextField *labelTF;//标签
@property (weak, nonatomic) IBOutlet UITextField *attrTF;//属性
@property (weak, nonatomic) IBOutlet UITextField *priceTF;//价格
@property (weak, nonatomic) IBOutlet UITextField *stockTF;//库存
@property (weak, nonatomic) IBOutlet UITextField *discountTF;//让利金额

@property (nonatomic, copy)NSString *brand_id;
@property (nonatomic, strong)NSMutableArray *labe_idArr;
@property (nonatomic, strong)NSMutableArray *attr_idArr;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong)NSMutableArray *picUrlArr;//图片url数组

@property (nonatomic, assign)BOOL isHaveDian;

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
    
    [self postCate];//请求数据
}

//请求数据
- (void)postCate{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"conid"] = self.store_id;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kgoods_cate_subordinate paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            GLAddOrEditProductCateModel *model = [GLAddOrEditProductCateModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.model = model;
            
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 品牌 标签 属性
/**品牌*/
- (IBAction)tapgesturebrand:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (GLAddOrEditProductCate_brandModel *model in self.model.brand) {
        model.isSelected = NO;
        [arrM addObject:model];
    }
    
    WeakSelf; //1:品牌(单选)  2:标签(复选) 3:属性(复选)
    [LBAddOrEditProductChooseSingalView showWholeClassifyViewWith:arrM type:1 Block:^(NSArray *indexArr) {
        weakSelf.brand_id = @"";
        
        if (indexArr.count != 0) {
            
            NSInteger index = [indexArr.firstObject integerValue];
            
            weakSelf.brandTF.text = weakSelf.model.brand[index].brand_name;
            weakSelf.brand_id = weakSelf.model.brand[index].brand_id;

        }
        
    }cancelBlock:^{
        
    }];
}

/**
 标签选择
 */
- (IBAction)labelSelection:(id)sender {
    [self.view endEditing:YES];
    
    NSMutableArray *arrM = [NSMutableArray array];
    WeakSelf; //1:品牌(单选)  2:标签(复选) 3:属性(复选)
    for (GLAddOrEditProductCate_labeModel *model in self.model.labe) {
        model.isSelected = NO;
        [arrM addObject:model];
    }
    
    [LBAddOrEditProductChooseSingalView showWholeClassifyViewWith:arrM type:2 Block:^(NSArray *indexArr) {
        
        [weakSelf.labe_idArr removeAllObjects];
        NSMutableArray *arrm = [NSMutableArray array];
        for (NSNumber *num in indexArr) {
            
            NSInteger index = [num integerValue];
            
            [arrm addObject:weakSelf.model.labe[index].label_name];
            [weakSelf.labe_idArr addObject:weakSelf.model.labe[index].label_id];
        }
        weakSelf.labelTF.text = [arrm componentsJoinedByString:@","];

    }cancelBlock:^{
        
    }];
}

/**
 属性选择
 */
- (IBAction)attributeSelection:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arrM = [NSMutableArray array];
    WeakSelf; //1:品牌(单选)  2:标签(复选) 3:属性(复选)
    for (GLAddOrEditProductCate_attrModel *model in self.model.attr) {
        
        model.isSelected = NO;
        
        [arrM addObject:model];
    }
    
    [LBAddOrEditProductChooseSingalView showWholeClassifyViewWith:arrM type:3 Block:^(NSArray *indexArr) {

        [weakSelf.attr_idArr removeAllObjects];
        NSMutableArray *arrm = [NSMutableArray array];
        
        for (NSNumber *num in indexArr) {
            
            NSInteger index = [num integerValue];
            [arrm addObject:weakSelf.model.attr[index].attr_info];
            [weakSelf.attr_idArr addObject:weakSelf.model.attr[index].attr_id];
        }
        
        weakSelf.attrTF.text = [arrm componentsJoinedByString:@","];
        
    }cancelBlock:^{
        
    }];
}

/**
 提示消息
 */
- (IBAction)noticeEvent:(UIButton *)sender {
    
    [SXAlertView showWithTitle:@"温馨提示" message:@"我的万册完成范文芳测无法测完饭" cancelButtonTitle:@"取消" otherButtonTitle:nil clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSUInteger buttonIndex) {
        
    }];
    
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *str = [self.goodsNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(str.length == 0){
        [EasyShowTextView showInfoText:@"请填写商品名字"];
        return;
    }
    
    if(self.priceTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请填写商品价格"];
        return;
    }
    
    if(self.discountTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请填写商品让利金额"];
        return;
    }

    if(self.assets.count != 3){
        [EasyShowTextView showInfoText:@"请上传3张商品图片"];
        return;
    }
    
    //创建
    [self creatDispathGroup];
}

#pragma mark -  上传图片 操作
-(void)creatDispathGroup{
    WeakSelf;
    //信号量
    [EasyShowLodingView showLoding];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建任务
    for (int i = 0; i < self.assets.count ; i++) {
        
        UIImage *image;
        if ([self.assets objectAtIndex:i] != nil && [[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *assets = [self.assets objectAtIndex:i];
            
            image = [assets thumbImage];
            
        }else if([[self.assets objectAtIndex:i] isKindOfClass:[UIImage class]]){
            
            image = [self.assets objectAtIndex:i];
            
        }else if([[self.assets objectAtIndex:i] isKindOfClass:[NSString class]]){
//            ZLPhotoPickerBrowserPhoto *photo = self.assets[i];
//            [cell.imagev sd_setImageWithURL:photo.photoURL];
         
        }
        
        dispatch_group_async(group, queue, ^{
            [weakSelf uploadImageV:image block:^(){ //这个block是此网络任务异步请求结束时调用的,代表着网络请求的结束.
                
                //一个任务结束时标记一个信号量
                dispatch_semaphore_signal(semaphore);
            }];
        });
    }
    
    
    dispatch_group_notify(group, queue, ^{
        //2个任务,2个信号等待.
        for (int i = 0; i < self.assets.count ; i++) {
            
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
-(void)uploadImageV:(UIImage *) image block:(void(^)(void))finish
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"1";//图片保存文件区别 1goods 2store 3user
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

            [self.picUrlArr addObject:responseObject[@"data"][@"url"]];
        }
        
        finish();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        finish();
    }];

}

/**
 提交请求
 */
- (void)submitRequest{
    
    //kcontainer_goods_append
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
//    dic[@"goodsid"] = self.store_id;
    dic[@"conid"] = self.store_id;
    dic[@"goods_name"] = self.goodsNameTF.text;
    dic[@"brand"] = self.brand_id;
    dic[@"discount"] = self.priceTF.text;
    dic[@"reward"] = self.discountTF.text;
    dic[@"num"] = self.stockTF.text;
    dic[@"info"] = self.textView.text;
    dic[@"type"] = @(self.type);
    
    for (int i = 0; i < self.picUrlArr.count; i++) {
        NSString *keyStr = [NSString stringWithFormat:@"picture[%zd]",i];
        dic[keyStr] = self.picUrlArr[i];
    }
    for (int i = 0; i < self.labe_idArr.count; i++) {
        NSString *keyStr = [NSString stringWithFormat:@"label[%zd]",i];
        dic[keyStr] = self.labe_idArr[i];
    }
    for (int i = 0; i < self.attr_idArr.count; i++) {
        NSString *keyStr = [NSString stringWithFormat:@"attr[%zd]",i];
        dic[keyStr] = self.attr_idArr[i];
    }

    [NetworkManager requestPOSTWithURLStr:kcontainer_goods_append paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOrEditGoodsNotification" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
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
    return self.assets.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBStoreAmendPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.index = indexPath.row;
    //删除
    if (indexPath.item == self.assets.count) {
        cell.deleteBt.hidden = YES;
        cell.imagev.image = [UIImage imageNamed:@"addphotograph"];
        
    }else{
        
        if ([self.assets objectAtIndex:indexPath.row] != nil && [[self.assets objectAtIndex:indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *assets = [self.assets objectAtIndex:indexPath.row];
            
            cell.imagev.image = [assets thumbImage];

        }else if([[self.assets objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
            
            cell.imagev.image = [self.assets objectAtIndex:indexPath.row];
            
        } else{
            ZLPhotoPickerBrowserPhoto *photo = self.assets[indexPath.row];
            [cell.imagev sd_setImageWithURL:photo.photoURL];

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
        }else{
            data = UIImageJPEGRepresentation(image, 0.2);
        }

        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        [self.assets addObject:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    [self.collectionView reloadData];
}

//这个地方只做一个提示的功能
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
    }
}

#pragma mark - 选择图片
- (void)photoSelectet{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];

    pickerVc.maxCount = 3;
    
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

        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 0; i < weakSelf.assets.count; i ++) {
            if([weakSelf.assets[i] isKindOfClass:[ZLPhotoAssets class]]){
                [arrM addObject:weakSelf.assets[i]];
            }
        }
        
        [weakSelf.assets removeObjectsInArray:arrM];
        [weakSelf.assets addObjectsFromArray:status.mutableCopy];
        [weakSelf.collectionView reloadData];
        
    };
    [pickerVc showPickerVc:self];
}

- (void)tapBrowser:(NSInteger)index{
//
//    // 图片游览器
//    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
//    // 淡入淡出效果
//    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
//    // 数据源/delegate
//    pickerBrowser.editing = YES;
//
//    NSMutableArray *arrM = [NSMutableArray array];
//
//    for (id photo in self.assets) {
//        ZLPhotoPickerBrowserPhoto *photoNew = [[ZLPhotoPickerBrowserPhoto alloc] init];
//        if (photo != nil && [photo isKindOfClass:[ZLPhotoAssets class]]) {
//
//            ZLPhotoAssets *assets = [self.assets objectAtIndex:index];
//            photoNew.asset = assets;
//
//        }else{
//
//            photoNew = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:photo];
//        }
//
//        [arrM addObject:photoNew];
//    }
//
//    pickerBrowser.photos = arrM;
//    // 能够删除
//    pickerBrowser.delegate = self;
//    // 当前选中的值
//    pickerBrowser.currentIndex = index;
//    // 展示控制器
//    [pickerBrowser showPickerVc:self];
//
}
//
//- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
//
//    if (self.assets.count > index) {
//        [self.assets removeObjectAtIndex:index];
//    }
//    [self.collectionView reloadData];
//
//}

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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(self.goodsNameTF == textField){
        [self.priceTF becomeFirstResponder];
    }else if(self.priceTF == textField){
        [self.stockTF becomeFirstResponder];
   }else if(self.stockTF == textField){
        [self.discountTF becomeFirstResponder];
   }else if(self.discountTF == textField){
       [self.view endEditing:YES];
   }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        [self.view endEditing:YES];
        [EasyShowTextView showInfoText:@"商品名不能输入空格"];
        return NO;
    }
    
    if (textField == self.stockTF) {
        if (![predicateModel inputShouldNumber:string]) {
            [EasyShowTextView showInfoText:@"库存只能输入数字"];
            return NO;
        }
    }
    
    if (textField == self.priceTF || textField == self.discountTF) {
 
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.' || single == '\n'))
            {
                [self.view endEditing:YES];
                [EasyShowTextView showInfoText:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                
                [self.view endEditing:YES];
                [EasyShowTextView showInfoText:@"最多只能输入一个小数点"];
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        
                        [self.view endEditing:YES];
                        [EasyShowTextView showInfoText:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        [self.view endEditing:YES];
                        [EasyShowTextView showInfoText:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        [self.view endEditing:YES];
                        [EasyShowTextView showInfoText:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES;
}

#pragma mark - 懒加载

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

//- (NSMutableArray *)photos{
//    if (!_photos) {
//
//        NSArray *urls = @[];
//        _photos = [NSMutableArray arrayWithCapacity:urls.count];
//        for (NSString *url in urls) {
//            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
//            photo.photoURL = [NSURL URLWithString:url];
//            [_photos addObject:photo];
//        }
//        
//    }
//    return _photos;
//}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.collectionH.constant = (UIScreenWidth - 20)/3.0;
    
}

- (NSMutableArray *)labe_idArr{
    if (!_labe_idArr) {
        _labe_idArr = [NSMutableArray array];
    }
    return _labe_idArr;
}
- (NSMutableArray *)attr_idArr{
    if (!_attr_idArr) {
        _attr_idArr = [NSMutableArray array];
    }
    return _attr_idArr;
}

//图片url数组
- (NSMutableArray *)picUrlArr{
    if (!_picUrlArr) {
        _picUrlArr = [NSMutableArray array];
    }
    return _picUrlArr;
}


@end
