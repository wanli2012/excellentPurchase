//
//  LBTmallChildredViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallChildredViewController.h"
#import "GLIntegralGoodsTwoCell.h"
#import "GLIntegralHeaderTableViewCell.h"
#import "LBintegralGoodsAciticityTableViewCell.h"
#import "GLIntegralGoodsOneCell.h"
#import "LBRiceShopTagTableViewCell.h"


static NSString *integralGoodsOneCell = @"GLIntegralGoodsOneCell";
static NSString *integralGoodsTwoCell = @"GLIntegralGoodsTwoCell";
static NSString *integralHeaderTableViewCell = @"GLIntegralHeaderTableViewCell";
static NSString *integralGoodsAciticityTableViewCell = @"LBintegralGoodsAciticityTableViewCell";
static NSString *riceShopTagTableViewCell = @"LBRiceShopTagTableViewCell";

@interface LBTmallChildredViewController ()<UITableViewDelegate,UITableViewDataSource,LBRiceShopTagViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign , nonatomic)CGFloat productListH;//缓存商品cell高度
@property (assign , nonatomic)CGFloat tagViewHeight;//标签的高度

@end

@implementation LBTmallChildredViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
     [self.tableview registerNib:[UINib nibWithNibName:integralGoodsTwoCell bundle:nil] forCellReuseIdentifier:integralGoodsTwoCell];
     [self.tableview registerNib:[UINib nibWithNibName:integralHeaderTableViewCell bundle:nil] forCellReuseIdentifier:integralHeaderTableViewCell];
     [self.tableview registerNib:[UINib nibWithNibName:integralGoodsAciticityTableViewCell bundle:nil] forCellReuseIdentifier:integralGoodsAciticityTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:integralGoodsOneCell bundle:nil] forCellReuseIdentifier:integralGoodsOneCell];
    [self.tableview registerClass:[LBRiceShopTagTableViewCell class] forCellReuseIdentifier:riceShopTagTableViewCell];
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 4; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return self.tagViewHeight + 30;
    }else  if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
            return 150 * 2/3.0 + 110;
        }
    }else if (indexPath.section == 2){
        return 100;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
//            return self.productListH;
            
            return   ((UIScreenWidth - 35)/2.0 + 110) * 4;
        }
    }
    return 0;
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        LBRiceShopTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:riceShopTagTableViewCell];
        if (!cell) {
            cell = [[LBRiceShopTagTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:riceShopTagTableViewCell];
        }
        cell.dwqTagV.delegate = self;
        /** 将通过数组计算出的tagV的高度存储 */
        cell.hotSearchArr = @[@"成都",@"成都",@"成都成都",@"成都",@"成都成都",@"成都",@"成都"];
        self.tagViewHeight = cell.dwqTagV.frame.size.height;
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GLIntegralHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralHeaderTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            GLIntegralGoodsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsOneCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 2){
        LBintegralGoodsAciticityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsAciticityTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            GLIntegralHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralHeaderTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            GLIntegralGoodsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsTwoCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.beautfHeight = self.productListH;
            return cell;
        }
    }
    
    return [[UITableViewCell alloc]init];
}


#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerLabel;
    
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1.0f;
    }
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark ------LBRiceShopTagViewDelegate
-(void)LBRiceShopTagView:(UIView *)dwq fetchWordToTextFiled:(NSDictionary *)dic{
    
   
    
}

@end
