//
//  LBSendShowPicturecell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LBSendShowPicturedelegete <NSObject>

-(void)choosepicture;
-(void)delegetepicture:(NSInteger )index;
-(void)bigpicture:(NSInteger )index;

@end

@interface LBSendShowPicturecell : UITableViewCell

@property (strong , nonatomic)NSArray *imagearrdata;
@property (assign , nonatomic)id<LBSendShowPicturedelegete>  delegete;

@end
