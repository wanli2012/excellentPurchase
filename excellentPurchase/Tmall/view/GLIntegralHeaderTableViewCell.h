//
//  GLIntegralHeaderTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLIntegralHeaderTableViewCell : UITableViewCell

@property (copy , nonatomic)void(^checkMoreProducts)(NSInteger section);

@property (assign , nonatomic)NSInteger section;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@end
