//
//  LBSetUpViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSetUpViewController.h"
#import "LBSetUpTableViewCell.h"
#import "LBAboutUsViewController.h"
#import "LBAccountSecurityViewController.h"
#import "LBSwitchAccountViewController.h"
#import "LBCloseTabbarMusicTableViewCell.h"

@interface LBSetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**退出*/
@property (weak, nonatomic) IBOutlet UIButton *exitBt;

/**版本*/
@property (weak, nonatomic) IBOutlet UILabel *versionLb;

/**数据*/
@property (strong, nonatomic) NSArray *dataArr;

/**会员控制器数组*/
@property (nonatomic, strong)NSMutableArray *userVcArr;

@property (nonatomic, copy)NSString *memory;//内存
@property (strong, nonatomic)  NSString *app_Version;//当前版本号

@end

static NSString *setUpTableViewCell = @"LBSetUpTableViewCell";
static NSString *closeTabbarMusicTableViewCell = @"LBCloseTabbarMusicTableViewCell";

@implementation LBSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:setUpTableViewCell bundle:nil] forCellReuseIdentifier:setUpTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:closeTabbarMusicTableViewCell bundle:nil] forCellReuseIdentifier:closeTabbarMusicTableViewCell];
    
    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    
//    self.copyrightLabel.text = @"copyright@2017-2018\n贵州蓝众投资管理有限公司";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLb.text = [NSString stringWithFormat:@"当前版本号: %@",_app_Version];
    
}

#pragma mark - 更新约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.exitBt.layer.cornerRadius = 4;
    self.exitBt.layer.borderWidth = 0.5;
    self.exitBt.layer.borderColor = YYSRGBColor(254, 102, 102, 1).CGColor;
}

#pragma mark - 清理缓存
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    [self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES];
}

-(void)clearCachSuccess{
    
    self.memory = [NSString stringWithFormat:@"%.2fM", [self filePath]];
    
    [self.tableview reloadData];
    
}

//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [self folderSizeAtPath :cachPath];
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}

//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

#pragma mark - 退出登录
- (IBAction)exit:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserModel defaultUser].loginstatus = NO;
//        [UserModel defaultUser].user_pic = @"";
        [UserModel defaultUser].token = @"";
        [UserModel defaultUser].uid = @"";
        
        [usermodelachivar achive];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"suckEffect";
        [self.view.window.layer addAnimation:animation forKey:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 检查更新

-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];

//    NSOperationQueue *queue = [NSOperationQueue new];

    [EasyShowLodingView showLodingText:@"正在检查..."];

    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [EasyShowLodingView hidenLoding];
        });
        
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue] > 0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
        
    }];
    
    [sessionDataTask resume];
    
}

-(void)receiveData:(id)sender
{
    NSString  *Newversion = [NSString stringWithFormat:@"%@",sender[@"version"]];
    
    if (![_app_Version isEqualToString:Newversion]) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本是否更新" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
            }
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
//        [EasyShowAlertView showAlertWithTitle:@"版本检测" message:@"当前版本已是最新版本"];
        
        [EasyShowTextView showInfoText:@"当前版本已是最新版本"];
    }
    
}


#pragma mark - UITabelviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataArr.count) {
        LBCloseTabbarMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:closeTabbarMusicTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    LBSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setUpTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLb.text = self.dataArr[indexPath.row];
    cell.cacheLB.text = self.memory;
    if ([self.dataArr[indexPath.row] isEqualToString:@"账户管理"]) {
        cell.headimage.hidden = YES;
        cell.arrowImage.hidden = NO;
        cell.cacheLB.hidden = YES;
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"清除缓存"]){
        cell.headimage.hidden = YES;
        cell.arrowImage.hidden = YES;
        cell.cacheLB.hidden = NO;
    }else{
        cell.headimage.hidden = YES;
        cell.arrowImage.hidden = NO;
        cell.cacheLB.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArr.count) {
        return;
    }
    NSString *vcstr = self.userVcArr[indexPath.row];
    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if(indexPath.row == 2){//清除缓存
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self clearFile];//清楚缓存
            
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }else if(indexPath.row == 4){//检查版本更新
        
        [self Postpath:GET_VERSION];//检查是否有更新版本
        return;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - 懒加载
-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"账户管理",@"安全管理",@"清除缓存",@"关于",@"检查版本更新", nil];
    }
    return _dataArr;
}

-(NSMutableArray *)userVcArr{
    
    if (!_userVcArr) {
        _userVcArr = [NSMutableArray arrayWithObjects:
                    @"LBSwitchAccountViewController",
                    @"LBAccountSecurityViewController",
                    @"",
                    @"LBAboutUsViewController",
                    @"",nil];
        
    }
    
    return _userVcArr;
}

@end
