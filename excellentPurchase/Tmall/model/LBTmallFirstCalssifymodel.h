//
//  LBTmallFirstCalssifymodel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTmallFirstCalssifymodel : NSObject

@property (nonatomic, copy)NSString *type_id;
@property (nonatomic, copy)NSString *typeName;

+(LBTmallFirstCalssifymodel*)defaultUser;

@end
