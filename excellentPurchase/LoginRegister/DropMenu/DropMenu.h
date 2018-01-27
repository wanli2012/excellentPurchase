//
//  DropMenu.h
//  dropMenu
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropMenuModel.h"

@interface DropMenu : UIView

+ (instancetype)showMenu:(NSArray *)titlesArr controlFrame:(CGRect)rect MenuMaxHeight:(CGFloat)menuHeight cellHeight:(CGFloat)cellHeight isHaveMask:(BOOL)isHaveMask andReturnBlock:(void(^)(NSString *selectName,NSString *type_id))menuBlock;


@end
