//
//  LBImprovePersonalInformationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBImprovePersonalInformationViewController.h"
#import "LBUploadIdentityPictureViewController.h"

@interface LBImprovePersonalInformationViewController ()

@end

@implementation LBImprovePersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//上传身份照
- (IBAction)uploadidentitypictures:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBUploadIdentityPictureViewController *vc =[[LBUploadIdentityPictureViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
