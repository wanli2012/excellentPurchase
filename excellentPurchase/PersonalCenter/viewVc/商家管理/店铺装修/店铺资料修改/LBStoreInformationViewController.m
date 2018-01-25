//
//  LBStoreInformationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreInformationViewController.h"

@interface LBStoreInformationViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LBStoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"店铺资料修改";
    
    
}

/**
 修改营业执照

 @param sender <#sender description#>
 */
- (IBAction)tapgesturePhoto:(UITapGestureRecognizer *)sender {
    
    
    
}


@end
