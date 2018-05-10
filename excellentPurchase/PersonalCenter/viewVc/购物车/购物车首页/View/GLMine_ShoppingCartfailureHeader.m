//
//  GLMine_ShoppingCartfailureHeader.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartfailureHeader.h"

@implementation GLMine_ShoppingCartfailureHeader
//清除过期商品
- (IBAction)clearPastProduct:(UIButton *)sender {
    WeakSelf;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要清除失效商品吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray *idArr = [NSMutableArray array];
        for (GLMine_ShoppingCartModel *sectionModel in self.dataarr) {
            
            for (GLMine_ShoppingPropertyCartModel *model in sectionModel.goods)
            {
                [idArr addObject:model.specification_id];
            }
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"app_handler"] = @"DELETE";
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
        
        dic[@"cart_id"] = [idArr componentsJoinedByString:@","];
        [EasyShowLodingView showLoding];
        [NetworkManager requestPOSTWithURLStr:kdel_user_cart paramDic:dic finish:^(id responseObject) {
            
            [EasyShowLodingView hidenLoding];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                if (weakSelf.refreshData) {
                    weakSelf.refreshData();
                }
                [EasyShowTextView showSuccessText:@"删除成功"];
                
            }else{
                [EasyShowTextView showErrorText:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            
            [EasyShowLodingView hidenLoding];
            [EasyShowTextView showErrorText:error.localizedDescription];
            
        }];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self.Target presentViewController:alertVC animated:YES completion:nil];
}

@end
