//
//  GLMine_Seller_OrderDetail_ExpressCell.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLMine_Seller_OrderDetail_ExpressCellBlock)(NSString *wl_odd_num);

@interface GLMine_Seller_OrderDetail_ExpressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *expressNumberTF;//快递单号

@property (nonatomic, copy) GLMine_Seller_OrderDetail_ExpressCellBlock block;

@end
