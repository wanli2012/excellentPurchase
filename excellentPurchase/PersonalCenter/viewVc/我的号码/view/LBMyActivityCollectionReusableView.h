//
//  LBMyActivityCollectionReusableView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/21.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBDolphinRecodermodel.h"



@interface LBMyActivityCollectionReusableView : UICollectionReusableView

@property (copy , nonatomic)void(^changeCollectionType)(void);
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *peoplelb;

@property (strong , nonatomic)LBDolphinRecodermodel *model;

@property (copy , nonatomic)void(^chechfly)(void);//查看物流
@property (copy , nonatomic)void(^chooseAdress)(void);//选择地址

@end
