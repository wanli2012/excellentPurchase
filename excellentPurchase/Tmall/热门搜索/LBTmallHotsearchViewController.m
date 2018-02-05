//
//  LBTmallHotsearchViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallHotsearchViewController.h"
#import "XC_label.h"
#import "LBSaveLocationInfoModel.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"
#import "LBProductDetailViewController.h"

@interface LBTmallHotsearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,selectHotOrHistoryDelegate,UITextFieldDelegate>

@property (nonatomic,strong) XC_label  *xcLabel ;

@property (nonatomic,strong)NSMutableArray *reCommendSource ;//推荐搜索

@property (nonatomic,strong)NSMutableArray *historySource ;//历史搜索
@property (nonatomic, assign) NSInteger  allCount;//总数
@property (nonatomic,strong)NSMutableArray *dataSource ;//数据源

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (weak, nonatomic) IBOutlet UITextField *keyTextfiled;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;

@property (nonatomic,strong)NSString *key ;//关键字
@property (nonatomic,assign)NSInteger page ;//页数

@end

static NSString *nearby_classifyCell = @"LBIntegralGoodsTwoCollectionViewCell";

@implementation LBTmallHotsearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.navigationController.navigationBar.hidden = YES ;
     [self.collectionV registerNib:[UINib nibWithNibName:nearby_classifyCell bundle:nil] forCellWithReuseIdentifier:nearby_classifyCell];
    self.collectionV.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadData];//加载数据
    [self setuprefrsh];
}
//获取数据
-(void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    WeakSelf;
    [NetworkManager requestPOSTWithURLStr:SeaShoppingHot_seach paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                [weakSelf.reCommendSource addObject:dic[@"content"]];
            }
            [weakSelf hotOptions ];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

-(void)setuprefrsh{

    WeakSelf;
    [LBDefineRefrsh defineCollectionViewRefresh:self.collectionV headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf searchKeySource:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataSource.count && weakSelf.dataSource.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionV];
        }else{
            weakSelf.page = weakSelf.page + 1;
            [self searchKeySource:NO];
        }
    }];
}

//搜索
-(void)searchKeySource:(BOOL)isrefresh{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"name"] = self.key;
    dic[@"page"] = @(self.page);
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }else{
        dic[@"uid"] = @"";
        dic[@"token"] = @"";
    }
    WeakSelf;
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:SeaShoppingGoods_search paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            //搜索了关键字 ，就需要历史记录添加进去
            [_xcLabel insertHistorOptions:self.key];
            
            if (isrefresh) {
                [weakSelf.dataSource removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBTmallhomepageDataStructureModel *model = [LBTmallhomepageDataStructureModel mj_objectWithKeyValues:dic];
                [self.dataSource addObject:model];
            }
            
            if (self.dataSource.count  <= 0) {
                [EasyShowTextView showErrorText:@"未找到相关信息"];
            }else{
                self.collectionV.hidden = NO;
                self.xcLabel.hidden = YES;
            }
            [EasyShowLodingView hidenLoding];
            [self.collectionV reloadData];
        }else{
            [EasyShowLodingView hidenLoding];
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionV];
    } enError:^(NSError *error) {
        [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionV];
    }];
    
}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength == 0) {
        _xcLabel.hidden = NO;
        _collectionV.hidden = YES;
        
    }
    
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        self.key = textField.text;
        self.page = 1;
        [self searchKeySource:YES];
        
        return NO;
    }
    
    return YES;
}

-(void)hotOptions
{
    
    _xcLabel = [[XC_label alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight-SafeAreaTopHeight) AndTitleArr:self.reCommendSource AndhistoryArr:self.historySource AndTitleFont:14 AndScrollDirection:UICollectionViewScrollDirectionVertical];
    _xcLabel.delegate = self ;
    _xcLabel.opetionsHeight = 30;
    _xcLabel.isShow_One = YES ;  //默认NO 显示
    _xcLabel.isShow_Two = NO ; //默认NO 显示
    _xcLabel.headTitle_one = @"热门搜索";
    _xcLabel.headTitle_two = @"历史搜索";
    
    [self.view addSubview:_xcLabel];
}
#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:nearby_classifyCell forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.refrshDatasorece = ^{
        [_collectionV reloadData];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBTmallhomepageDataStructureModel *model = self.dataSource[indexPath.item];
    self.hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
    vc.goods_id = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
   
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth - 35)/2.0, (UIScreenWidth - 35)/2.0 + 100);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


#pragma mark selectHotOrHistoryDelegate
//选中某个选项
-(void)selectHotOrHistory:(NSString *)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString *)selectTitle{
    [self.view endEditing:YES];
    self.key = selectTitle;
    [self searchKeySource:YES];
    //这里是选中某个选项， 主要处理跳转逻辑
}

//删除历史选项
-(void)deleteHistoryOptions:(NSString *)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString * _Nullable)selectTitle AndNSdataSource:(NSMutableArray * _Nullable)dataSource{
    [self.view endEditing:YES];
    
    
    
    //这里可以删除本地数据 逻辑 UI 已经处理好了。只需要删除暴露在外面对应的数据源就可以了
    
}

//删除热搜选项
-(void)deleteHotOptions:(NSString * _Nullable)historyOrHot AndIndex:(NSInteger)index AndTitile:(NSString * _Nullable)selectTitle AndNSdataSource:(NSMutableArray *_Nullable)dataSource
{
    
    //这里可以删除热搜数据 逻辑 UI 已经处理好了。只需要删除暴露在外面对应的数据源就可以了
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark Xc_serchViewCilckBtn
-(void)cilckCancle{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchresult:(NSString *)resultString{
    
    [self.view endEditing:YES];
    
    
    //1 ,这里做去重复逻辑
    
    //2 ,去重复逻辑之后直接丢字符串进去，已经处理好了
    
    //搜索了关键字 ，就需要历史记录添加进去
    [_xcLabel insertHistorOptions:resultString];
}

-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

-(NSMutableArray*)reCommendSource{
    if (!_reCommendSource) {
        _reCommendSource = [NSMutableArray array];
        
    }
    return _reCommendSource;
}

-(NSMutableArray*)historySource{
    if (!_historySource) {
        _historySource = [NSMutableArray array];
        
    }
    return _historySource;
}

@end
