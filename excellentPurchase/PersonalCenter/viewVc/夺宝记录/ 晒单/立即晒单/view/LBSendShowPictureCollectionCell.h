//
//  LBSendShowPictureCollectionCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSendShowPictureCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UIButton *deletebt;
@property (strong , nonatomic)NSIndexPath *indexpath;
@property (copy , nonatomic)void(^deletepic)(NSIndexPath *indexpath);

@end
