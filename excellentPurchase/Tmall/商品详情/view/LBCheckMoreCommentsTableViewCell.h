//
//  LBCheckMoreCommentsTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LBCheckMoreCommentsDelegate <NSObject>

-(void)checkMoreComments;

@end

@interface LBCheckMoreCommentsTableViewCell : UITableViewCell

@property (nonatomic, assign)id<LBCheckMoreCommentsDelegate> delegate;

@end
