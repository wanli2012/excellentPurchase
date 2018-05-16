//
//  LBMyActivityNumbersViewAdressVc.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyActivityNumbersViewAdressVc.h"
#import "LBMyActivityNumbersViewAdresscell.h"
#import "LBMineOrderDetailAdressTableViewCell.h"
#import "LBMineSureOrdermessageTableViewCell.h"
#import "GLMine_AddressModel.h"
#import "LBMineCentermodifyAdressViewController.h"
#import "LBDolphinRecoderViewController.h"

@interface LBMyActivityNumbersViewAdressVc ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) GLMine_AddressModel *addressModel;
@property (assign, nonatomic) BOOL  refreshAdress;//是否需要更新地址
@property (strong, nonatomic)NSString *remark;//备注
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstrait;

@end

@implementation LBMyActivityNumbersViewAdressVc
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.refreshAdress == NO) {
        [self getAddressList];//获取收货地址
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日好运来";
    self.view.backgroundColor =[UIColor whiteColor];
    self.remark = [NSString string];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineOrderDetailAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineOrderDetailAdressTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMyActivityNumbersViewAdresscell" bundle:nil] forCellReuseIdentifier:@"LBMyActivityNumbersViewAdresscell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineSureOrdermessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineSureOrdermessageTableViewCell"];
    
}
//提交订单
- (IBAction)submitEvent:(UIButton *)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
     dic[@"indiana_id"] = self.model.indiana_id;
    dic[@"remark"] = self.remark;
    dic[@"address_id"] = self.addressModel.address_id;
    
    self.addressModel = nil;
    [NetworkManager requestPOSTWithURLStr:kIndianasetIndianaAddress paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"提交成功"];
            if (self.popvc) {
                self.popvc();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 收货地址
-(void)getAddressList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    
    self.addressModel = nil;
    [NetworkManager requestPOSTWithURLStr:kaddresses paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            __block BOOL Stop = NO;
            WeakSelf;
            [responseObject[@"data"][@"page_data"] enumerateObjectsUsingBlock:^(NSDictionary   *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([dic[@"is_default"] integerValue] == 1) {
                    weakSelf.addressModel = [GLMine_AddressModel mj_objectWithKeyValues:dic];
                    Stop = YES;
                    *stop = YES;//停止循环
                }
            }];
            
            if (Stop == NO && [responseObject[@"data"][@"page_data"]count]>0) {
                self.addressModel = [GLMine_AddressModel mj_objectWithKeyValues:responseObject[@"data"][@"page_data"][0]];
            }
            self.refreshAdress = NO;
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
            LBMineOrderDetailAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineOrderDetailAdressTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
            if (self.addressModel) {
                cell.adresslb.text = [NSString stringWithFormat:@"收货地址：%@",_addressModel.address_address];
                cell.phonelb.text = [NSString stringWithFormat:@"%@",_addressModel.phone];
                cell.namelb.text = [NSString stringWithFormat:@"收货人：%@",_addressModel.truename];
            }else{
                cell.adresslb.text = [NSString stringWithFormat:@"收货地址："];
                cell.phonelb.text = @"";
                cell.namelb.text = [NSString stringWithFormat:@"收货人："];
            }
            
            return cell;
    }else if (indexPath.row == 1){
        LBMyActivityNumbersViewAdresscell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyActivityNumbersViewAdresscell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
        cell.namelb.text = _model.indiana_goods_name;
        cell.numbers.text = [NSString stringWithFormat:@"期号:%@     参与了:%@",_model.indiana_number,_model.u_count];
        
        return cell;
    }else{
        LBMineSureOrdermessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineSureOrdermessageTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexpath = indexPath;
        WeakSelf;
        cell.returntextview = ^(NSString *text, NSIndexPath *indexpath) {
            weakSelf.remark = text;
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else if (indexPath.row == 1){
        return 118;
    }else if (indexPath.row == 2){
         return 80;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed =YES;
        LBMineCentermodifyAdressViewController *vc =[[LBMineCentermodifyAdressViewController alloc]init];
        vc.block = ^(GLMine_AddressModel *adressmodel) {
            self.refreshAdress = YES;
            self.addressModel = adressmodel;
            [_tableview reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.topconstrait.constant = SafeAreaTopHeight;
}

@end
