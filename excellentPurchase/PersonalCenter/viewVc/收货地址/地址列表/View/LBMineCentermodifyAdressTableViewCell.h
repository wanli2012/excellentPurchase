//
//  LBMineCentermodifyAdressTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_AddressModel.h"

@protocol LBMineCentermodifyAdressTableViewCellDelegate <NSObject>

- (void)defaultSet:(NSInteger)index;

@end

@interface LBMineCentermodifyAdressTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *setupBt;

@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
@property (weak, nonatomic) IBOutlet UIButton *editbt;

@property (nonatomic, strong)GLMine_AddressModel *model;

@property (assign, nonatomic)NSInteger index;

//@property (strong, nonatomic) RACSubject *subject;

@property (nonatomic, copy)void(^returnSetUpbt)(NSInteger index);
@property (nonatomic, copy)void(^returnEditbt)(NSInteger index);
@property (nonatomic, copy)void(^returnDeletebt)(NSInteger index);

@end
