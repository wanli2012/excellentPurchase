//
//  LBRiceShopTagTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBRiceShopTagTableViewCelldelegete <NSObject>

-(void)jumpGoodsClassify:(NSString*)cate_id cataname:(NSString*)catename;

@end

@interface LBRiceShopTagTableViewCell : UITableViewCell

@property (strong, nonatomic)NSArray *dataArr;
@property (nonatomic, assign)id<LBRiceShopTagTableViewCelldelegete> delegate;

@end
