//
//  LBAccountManagementViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAccountManagementViewController.h"
#import "LBAccountManagementTableViewCell.h"
#import "GLAccountManagementModel.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

//弹出的选择器 类似alertViewSheet
#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"
#import <Photos/Photos.h>

//#import "LBMineCenterAddAdreassViewController.h"//修改收货地址
#import "LBModifyingUsernameViewController.h"//用户名修改
#import "LBImprovePersonalInformationViewController.h"//完善资料
#import "GLMine_Seller_IncomeCodeController.h"//我的二维码
#import "LBMineCentermodifyAdressViewController.h"//收货地址列表

@interface LBAccountManagementViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *headImge;//头像
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *titleArr2;
@property (nonatomic, strong)GLAccountManagementModel *model;
@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, copy)NSString *headImageUrl;//头像地址

@end

static NSString *accountManagementTableViewCell = @"LBAccountManagementTableViewCell";

@implementation LBAccountManagementViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    //请求数据
    [self postData];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    
    if (self.type == 1) {//编辑资料
        self.headNameLabel.text = @"头像";
    }else{//不可编辑
        self.headNameLabel.text = @"其他资料";
    }
    
    self.titleArr = @[@"真实姓名",@"身份",@"账号",@"推荐账号",@"推荐人用户名"];
    
    self.titleArr2 = @[@"用户名",@"账号状态",@"收货地址",@"我的二维码",@"所在地区"];
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:accountManagementTableViewCell bundle:nil] forCellReuseIdentifier:accountManagementTableViewCell];
    
    //底部视图高度
    self.tableview.tableFooterView.height = 60;
    
}

#pragma mark - 请求数据

- (void)postData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    
    NSString *url;
    if (self.type == 1) {
        url = kget_user_info;
    }else {
        url = kuser_relevant;
    }
    
    [NetworkManager requestPOSTWithURLStr:url paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.dataDic = responseObject[@"data"];
            
            self.model = [GLAccountManagementModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self.headImge sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 跳转到可编辑资料
/** 跳转到可编辑资料*/
- (IBAction)editInfo:(id)sender {
    
    if (self.type == 1) {
        
        HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
        
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
        
    }else if(self.type == 0){
        self.hidesBottomBarWhenPushed = YES;
        LBAccountManagementViewController *vc = [[LBAccountManagementViewController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        
//        UIImagePickerControllerOriginalImage
//        NSData *data;UIImagePickerControllerOriginalImage
//        if (UIImagePNGRepresentation(image) == nil) {
//            data = UIImageJPEGRepresentation(image, 0.1);
//        }else {
//            data = UIImageJPEGRepresentation(image, 0.1);
//        }
        
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
//        UIImage *finImage = [UIImage imageWithData:data];
//
//        self.headImge.image = finImage;
        
//        self.headImge.image = image;
        
        [self uploadImage:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 相册读取
- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    // 3. 设置打开照片相册类型(显示所有相簿)
//    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    ipc.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    ipc.allowsEditing = YES;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 上传图片
 */
- (void)uploadImage:(UIImage *)image{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"3";
    dic[@"port"] = @"3";//端口 1.pc 2.安卓 3.ios 4.H5手机网站
    dic[@"app_version"] = @"1.0.0";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    
    [EasyShowLodingView showLoding];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kappend_upload] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        NSString *title = [NSString stringWithFormat:@"uploadfile"];
        
        NSData *data;
        
        data = UIImageJPEGRepresentation(image,0.1);
        
        [formData appendPartWithFileData:data name:title fileName:fileName mimeType:@"image/jpeg"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.headImageUrl = responseObject[@"data"][@"url"];
            
            if (self.headImageUrl.length != 0) {
                
                [self modifyPic];
            }else{
                
                [EasyShowTextView showErrorText:@"图片上传失败"];
            }
            
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

#pragma mark - 修改头像
- (void)modifyPic{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"UPDATE";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"pic"] = self.headImageUrl;
    
    [NetworkManager requestPOSTWithURLStr:kperfect_get_info paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.headImge sd_setImageWithURL:[NSURL URLWithString:self.headImageUrl] placeholderImage:[UIImage imageNamed:PlaceHolder]];
            
            [UserModel defaultUser].pic = self.headImageUrl;
            [usermodelachivar achive];
            
            [EasyShowTextView showSuccessText:@"头像修改成功"];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1; //返回值是多少既有几个分区
}

#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.type == 1){
        return self.titleArr2.count;
    }else{
        
        return self.titleArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBAccountManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:accountManagementTableViewCell forIndexPath:indexPath];
    
    if (self.type == 1) {//1:编辑资料 0:不可编辑资料
        cell.titleLabel.text = self.titleArr2[indexPath.row];
        
        cell.type = self.type;
        if (indexPath.row == 0) {
            cell.valueLabel.text = self.dataDic[@"nickname"];
        }else  if (indexPath.row == 1) {
            switch ([self.model.rzstatus integerValue]) {////认证状态 0没有认证 1:申请实名认证 2审核通过3失败',
                case 0:
                {
                    cell.valueLabel.text = @"没有认证";
                }
                    break;
                case 1:
                {
                    cell.valueLabel.text = @"实名认证中";
                }
                    break;
                case 2:
                {
                    cell.valueLabel.text = @"审核通过";
                }
                    break;
                case 3:
                {
                    cell.valueLabel.text = @"认证失败";
                }
                    break;
                    
                default:
                    break;
            }
        }else if(indexPath.row == 2){
            
            cell.valueLabel.text = self.dataDic[@"address"];
            
        }else if(indexPath.row == 3){//我的二维码
            cell.type = 2;
        }else if(indexPath.row == 4){
            
            cell.valueLabel.text = self.dataDic[@"detail_address"];
        }
        
    }else{
        cell.type = self.type;
        
        cell.titleLabel.text = self.titleArr[indexPath.row];
        if(indexPath.row == 0){
            cell.valueLabel.text = self.dataDic[@"truename"];
        }else if(indexPath.row == 1){
            cell.valueLabel.text = self.dataDic[@"group_name"];
        }else if(indexPath.row == 2){
            cell.valueLabel.text = self.dataDic[@"user_name"];
        }else if(indexPath.row == 3){
            cell.valueLabel.text = self.dataDic[@"tj_username"];
        }else if(indexPath.row == 4){
            cell.valueLabel.text = self.dataDic[@"tj_nickname"];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 1) {
        
        __block typeof(self)weakSelf = self;
        switch (indexPath.row) {
            case 0://用户名修改
            {
                self.hidesBottomBarWhenPushed = YES;
                LBModifyingUsernameViewController *modifyUserNameVC = [[LBModifyingUsernameViewController alloc] init];
                
                modifyUserNameVC.block = ^(NSString *name) {
                    [weakSelf postData];
                };
                
                [self.navigationController pushViewController:modifyUserNameVC animated:YES];
            }
                break;
            case 1://未审核  跳转到 完善信息
            {
                ////认证状态 0没有认证 1:申请实名认证 2审核通过3失败
                
                if ([self.model.rzstatus integerValue] == 0 ||[self.model.rzstatus integerValue] == 3) {
                    
                    self.hidesBottomBarWhenPushed = YES;
                    LBImprovePersonalInformationViewController *vc = [[LBImprovePersonalInformationViewController alloc] init];
                    
                    vc.block = ^(BOOL isRefresh) {
                        if (isRefresh) {
                            [weakSelf postData];
                        }
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 2://收货地址
            {
                self.hidesBottomBarWhenPushed = YES;
                LBMineCentermodifyAdressViewController *addListVC = [[LBMineCentermodifyAdressViewController alloc] init];
                
                [self.navigationController pushViewController:addListVC animated:YES];
            }
                break;
            case 3://我的二维码
            {
                self.hidesBottomBarWhenPushed = YES;
                GLMine_Seller_IncomeCodeController *vc = [[GLMine_Seller_IncomeCodeController alloc] init];
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4://所在地区
            {
                
                //                [CZHAddressPickerView areaPickerViewWithDataArr:(NSArray *) AreaDetailBlock:^(NSString *province, NSString *city, NSString *area, NSString *province_id, NSString *city_id, NSString *area_id) {
                //
                //                }];
                
                
                //                [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
                //                    [weakSelf postData];
                //                    NSString *str = [NSString stringWithFormat:@"%@%@%@",province,city,area];
                //
                //                    [weakSelf.valueArr2 replaceObjectAtIndex:indexPath.row withObject:str];
                //
                //                    [weakSelf.tableview reloadData];
                //                }];
            }
                
            default:
                break;
        }
    }
}

#pragma mark - 懒加载

@end
