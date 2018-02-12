//
//  LBCloseTabbarMusicTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCloseTabbarMusicTableViewCell.h"

@implementation LBCloseTabbarMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.switchBt.transform =  CGAffineTransformMakeScale( 0.9, 0.9);//缩放
    NSString * b =  [[NSUserDefaults standardUserDefaults]objectForKey:@"iscloseMusic"];
    
    if (b == nil || [b isEqualToString:@"YES"]) {
        self.switchBt.on = YES;
    }else{
        self.switchBt.on = NO;
    }
    
}
//关闭打开音效
- (IBAction)switchEvent:(UISwitch *)sender {
    
    sender.on = !sender.on;
    if (sender.isOn) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"iscloseMusic"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"iscloseMusic"];
    }
    
}


@end
