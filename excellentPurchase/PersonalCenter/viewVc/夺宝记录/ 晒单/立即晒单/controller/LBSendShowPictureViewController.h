//
//  LBSendShowPictureViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSendShowPictureViewController : UIViewController

@property (strong , nonatomic)NSString *indiana_id;

@property (copy , nonatomic)void(^uploadsucess)(void);

@end
