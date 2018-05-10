//
//  LBApplyRefundViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBApplyRefundViewController.h"
#import "LBChooseRefuseReseaonView.h"
#import "LBChooseRefuseReseaonModel.h"
#import "LBEatShopProdcutClassifyViewController.h"
#import "ReactiveCocoa.h"

@interface LBApplyRefundViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *specification;
@property (weak, nonatomic) IBOutlet UILabel *newprice;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *reasonlb;
@property (weak, nonatomic) IBOutlet UILabel *refuselb;
@property (weak, nonatomic) IBOutlet UILabel *mostPrice;
@property (weak, nonatomic) IBOutlet UITextView *infotext;
@property (weak, nonatomic) IBOutlet UILabel *placeholderlb;
@property (weak, nonatomic) IBOutlet UILabel *limitelb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UIButton *submitBt;

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITextField *moneytf;

@end

@implementation LBApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请退款";
    [self requestRefuseReason];
    if ([NSString StringIsNullOrEmpty:_model.store_name]) {
        self.storeName.text = [NSString stringWithFormat:@"暂无商家名称 >"];
    }else{
        self.storeName.text = [NSString stringWithFormat:@"%@ >",self.model.store_name];
    }
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.goods_data.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.goods_name.text = [NSString stringWithFormat:@"%@",_model.goods_data.goods_name];
    self.newprice.text = [NSString stringWithFormat:@"¥%@",_model.goods_data.ord_goods_price];
    self.num.text = [NSString stringWithFormat:@"x%@",_model.goods_data.ord_goods_num];
    self.oldprice.text = [NSString stringWithFormat:@"¥%@",_model.goods_data.marketprice];
    self.specification.text = [NSString stringWithFormat:@"规格:%@",_model.goods_data.ord_spec_info];
    if ([NSString StringIsNullOrEmpty:_model.goods_data.store_phone]) {
        self.phonelb.text = [NSString stringWithFormat:@"商家未留联系电话"];
    }else{
        self.phonelb.text = [NSString stringWithFormat:@"商家联系电话:%@",_model.goods_data.store_phone];
    }
    
    if ([_model.goods_data.ord_offset_coupons integerValue] == 0) {
        self.mostPrice.text = [NSString stringWithFormat:@"最多¥%d   不含发货邮费¥%d",([_model.goods_data.ord_goods_price intValue] - [_model.goods_data.ord_offset_coupons intValue])* [_model.goods_data.ord_goods_num intValue],[_model.goods_data.ord_send_price intValue] * [_model.goods_data.ord_goods_num intValue]];
    }else{
        self.mostPrice.text = [NSString stringWithFormat:@"最多¥%d + 购物券%d   不含发货邮费¥%d",([_model.goods_data.ord_goods_price intValue] - [_model.goods_data.ord_offset_coupons intValue])* [_model.goods_data.ord_goods_num intValue],[_model.goods_data.ord_offset_coupons intValue] * [_model.goods_data.ord_goods_num intValue],[_model.goods_data.ord_send_price intValue] * [_model.goods_data.ord_goods_num intValue]];
    }
    
    self.submitBt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.submitBt.layer.borderWidth = 1;
    [self.submitBt setTitle:@"提 交" forState:UIControlStateNormal];
    [self.submitBt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
    self.submitBt.backgroundColor = [UIColor whiteColor];
    self.submitBt.userInteractionEnabled = NO;
    
    [[self.moneytf rac_textSignal]subscribeNext:^(NSString *x) {
        
        if ([x floatValue] > ([_model.goods_data.ord_goods_price floatValue] * [_model.goods_data.ord_goods_num intValue])) {
            [EasyShowTextView showText:@"退款金额不能大于最多可退款的金额"];
        }
        
    }];

    
}

- (IBAction)tapgestureChoosereason:(UITapGestureRecognizer *)sender {
    WeakSelf;
    [LBChooseRefuseReseaonView showMenu:self.dataArr controlFrame:CGRectMake(0, 0, UIScreenWidth, 400)  andReturnBlock:^(NSString *selectstr, NSString *row) {
        for (int i = 0; i < self.dataArr.count; i++) {
            LBChooseRefuseReseaonModel *model1 = self.dataArr[i];
            if (i != [row integerValue]) {
                model1.isselect = NO;
            }else{
                model1.isselect = YES;
            }
        }
        
        weakSelf.reasonlb.text = [NSString stringWithFormat:@"%@ >",selectstr];
        weakSelf.submitBt.layer.borderColor = [UIColor clearColor].CGColor;
        weakSelf.submitBt.layer.borderWidth = 1;
        [weakSelf.submitBt setTitle:@"提 交" forState:UIControlStateNormal];
        [weakSelf.submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        weakSelf.submitBt.backgroundColor = MAIN_COLOR;
        weakSelf.submitBt.userInteractionEnabled = YES;
    }];
}

- (IBAction)submitEvent:(UIButton *)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
     dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"ord_str"] = _model.goods_data.ord_id;
    dic[@"info"] = self.infotext.text;
     dic[@"money"] = self.moneytf.text;
    dic[@"reason"] = [self.reasonlb.text stringByReplacingOccurrencesOfString:@" >" withString:@""];
    
    if ([self.moneytf.text floatValue] <= 0) {
        [EasyShowTextView showText:@"退款金额不能为0"];
        return;
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kOrderRefundorder_refund paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshdata) {
                self.refreshdata(self.moneytf.text);
            }
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
//跳转商家
- (IBAction)chooseRefuseReason:(UITapGestureRecognizer *)sender {
    if ([_model.store_type integerValue] != 5 || [_model.store_type integerValue]!= 6) {
        self.hidesBottomBarWhenPushed = YES;
        LBEatShopProdcutClassifyViewController *vc = [[LBEatShopProdcutClassifyViewController alloc]init];
        vc.store_id = self.model.store_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [EasyShowTextView showInfoText:@"自营商城"];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length <= 0) {
        self.placeholderlb.hidden = NO;
    }else{
        self.placeholderlb.hidden = YES;
    }
    
    if (textView.text.length <= 0 && [self.reasonlb.text isEqualToString:@"请选择 >"]) {
        self.submitBt.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.submitBt.layer.borderWidth = 1;
        [self.submitBt setTitle:@"提 交" forState:UIControlStateNormal];
        [self.submitBt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
        self.submitBt.backgroundColor = [UIColor whiteColor];
        self.submitBt.userInteractionEnabled = NO;
    }else{
        
        self.submitBt.layer.borderColor = [UIColor clearColor].CGColor;
        self.submitBt.layer.borderWidth = 1;
        [self.submitBt setTitle:@"提 交" forState:UIControlStateNormal];
        [self.submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitBt.backgroundColor = MAIN_COLOR;
        self.submitBt.userInteractionEnabled = YES;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}

-(void)textViewDidChange:(UITextView *)textView{
    self.limitelb.text = [NSString stringWithFormat:@"%ld/500",textView.text.length];
    //字数限制操作
    if (textView.text.length >= 500) {
        
        textView.text = [textView.text substringToIndex:500];
        self.limitelb.text = @"500/500";
        
    }
    if (textView.text.length <= 0) {
        self.placeholderlb.hidden = NO;
    }else{
        self.placeholderlb.hidden = YES;
        
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
    }

    return YES;
}

-(void)requestRefuseReason{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
 
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:korder_refund_reason_list paramDic:dic finish:^(id responseObject) {
        [self.dataArr removeAllObjects];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                LBChooseRefuseReseaonModel *model =[LBChooseRefuseReseaonModel mj_objectWithKeyValues:dic];
                model.isselect = NO;
                [self.dataArr addObject:model];
            }

        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

@end
