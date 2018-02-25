//
//  LBTmallProductListViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallProductListViewController.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBIntegralGoodsTwoCollectionViewCell.h"
#import "LBShowProductListCollectionViewCell.h"
#import "LBFiltrateProductViewController.h"
#import "LBTmallhomepageDataModel.h"
#import "LBEat_WholeClassifyView.h"
#import "LBTmallHotsearchViewController.h"
#import "LBProductDetailViewController.h"

typedef NS_ENUM(NSInteger, CollectionViewType) {
    LBCollectionViewTypeDefault ,   // 默认一排两个item
    LBCollectionViewTypeOne,      // 一排一个item
};

@interface LBTmallProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**
 记录菜单选中
 */
@property (strong, nonatomic) UIButton *currentBt;

@property (weak, nonatomic) IBOutlet UIButton *compositeBt;
@property (weak, nonatomic) IBOutlet UIButton *saleBt;
@property (weak, nonatomic) IBOutlet UIButton *priceBt;
@property (weak, nonatomic) IBOutlet UIButton *filtrateBt;

@property (assign, nonatomic) CollectionViewType showType;

@property (strong, nonatomic) UICollectionViewFlowLayout *tableFlowLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowyout;

@property (nonatomic, strong) NSMutableArray *dataArr;//数据源
@property (nonatomic, assign) NSInteger  allCount;//总数
@property (nonatomic, assign) NSInteger  page;//页数
@property (nonatomic, assign) NSInteger  sale;//1销量升序 2销量降序
@property (nonatomic, assign) NSInteger  price;//1价格升序 2价格降序
@property (nonatomic, strong) NSString *keyWord;//关键字
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end

static NSString *ID = @"LBIntegralGoodsTwoCollectionViewCell";
static NSString *ID2 = @"LBShowProductListCollectionViewCell";

@implementation LBTmallProductListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.topViewHeight.constant = SafeAreaTopHeight;
    
    if (UIScreenHeight == 812) {
        self.bottomHeight.constant = 34;
    }else{
        self.bottomHeight.constant = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    UIImageView *search=[[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, 20, 20)];
    search.contentMode = UIViewContentModeScaleAspectFit;
    search.image=[UIImage imageNamed:@"taotao-saerch"];
    self.searchTf.leftView = search;
    self.searchTf.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    self.searchTf.placeholder = self.catename;

    UIButton *selectBt = [self.view viewWithTag:10];
    selectBt.selected = YES;
    self.currentBt = selectBt;
//    设置按钮文字与图片的距离
     [self.saleBt horizontalCenterTitleAndImage:5];
     [self.priceBt horizontalCenterTitleAndImage:5];
     [self.filtrateBt horizontalCenterTitleAndImage:5];
//    注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.collectionView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellWithReuseIdentifier:ID2];
//    默认展示样式
    self.showType = LBCollectionViewTypeDefault;
    [self.collectionView setCollectionViewLayout:self.collectionFlowyout];
    
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//数据刷新
    
    if (self.goods_type != 0) {//1每日推荐 2精品优选 跳转进来请求数据
        UITapGestureRecognizer  *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpSearch)];
        [self.searchView addGestureRecognizer:tapgesture];
        self.searchTf.userInteractionEnabled = NO;
    }
    
}

-(void)setupNpdata{
    WeakSelf;
    
    self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    
    self.collectionView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.collectionView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.collectionView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.collectionView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    //emptyView内容上的点击事件监听
    [self.collectionView.ly_emptyView setTapContentViewBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    }];
}

-(void)setuprefrsh{
    [self loadData:1 refreshDirect:YES];
    WeakSelf;
    [LBDefineRefrsh defineCollectionViewRefresh:self.collectionView headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionView];
        }else{
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
        }
    }];
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"page"] = @(page);
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }else{
        dic[@"uid"] = @"";
        dic[@"token"] = @"";
    }
    
    if (self.sale != 0) {
        dic[@"num"] = @(self.sale);
    }
    
    if (self.price != 0) {
        dic[@"money"] = @(self.price);
    }
    
    NSString *urlstr = @"";
    if (self.goods_type != 0) {//1每日推荐 2精品优选 跳转进来请求数据
        urlstr = SeaShoppingMore_goods;
        dic[@"goods_type"] = @(self.goods_type);
        dic[@"s_type"] = self.s_type;
        if ([NSString StringIsNullOrEmpty:self.cate_id] == NO) {
            dic[@"cate_id"] = self.cate_id;
        }
    }else{//二级分类跳转
        urlstr = SeaShoppingGoods_search;
        dic[@"s_type"] = self.s_type;
        if ([NSString StringIsNullOrEmpty:self.keyWord] == NO) {
            dic[@"name"] = self.keyWord;
        }else{
            dic[@"cate_id"] = self.cate_id;
        }
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:urlstr paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionView];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
        
            if (isDirect) {
                if (self.allCount == 0) {
                    [EasyShowTextView showText:@"未找到相关信息"];
                }
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBTmallhomepageDataStructureModel *model = [LBTmallhomepageDataStructureModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.collectionView reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [LBDefineRefrsh dismissCollectionViewRefresh:self.collectionView];
    }];
    
}
#pragma mark --- 跳转搜索
-(void)jumpSearch{
    self.hidesBottomBarWhenPushed = YES;
    LBTmallHotsearchViewController *vc =[[LBTmallHotsearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark --- 商品菜单点击
- (IBAction)comprehensiveEvent:(UIButton *)sender {
    
    if (sender == self.currentBt) {
        if (sender.tag == 11 || sender.tag == 12) {
            sender.selected = !sender.selected;
            [self.currentBt setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        }
    }else{
        sender.selected = YES;
        self.currentBt.selected = NO;
        [self.currentBt setTitleColor:LBHexadecimalColor(0x3f3f3f) forState:UIControlStateNormal];
        [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.currentBt = sender;
    }
    
    switch (sender.tag ) {
        case 10://综合
        {
            self.sale = 0;
            self.price = 0;
            self.page = 1;
            [self loadData:self.page refreshDirect:YES];
        }
            break;
        case 11://销量
        {
            if (sender.selected == YES) {
                self.sale = 2;
                self.price = 0;
            }else{
                self.sale = 1;
                self.price = 0;
            }
            self.page = 1;
            [self loadData:self.page refreshDirect:YES];
        }
            break;
        case 12://价格
        {
            if (sender.selected == YES) {
                self.sale = 0;
                self.price = 2;
            }else{
                self.sale = 0;
                self.price = 1;
            }
            self.page = 1;
            [self loadData:self.page refreshDirect:YES];
        }
            break;
        case 13://筛选
        {
            self.sale = 0;
            self.price = 0;
            WeakSelf;
            [LBEat_WholeClassifyView showWholeClassifyViewBlock:^(NSString *cate_id,NSString *catename) {
                [weakSelf.filtrateBt setTitle:catename forState:UIControlStateNormal];
                [weakSelf.filtrateBt horizontalCenterTitleAndImage:5];
                weakSelf.cate_id = cate_id;
                weakSelf.keyWord = @"";
                weakSelf.currentBt = weakSelf.compositeBt;
                weakSelf.currentBt.selected = YES;
                weakSelf.page = 1;
                [weakSelf loadData:weakSelf.page refreshDirect:YES];
            }];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark --- 商品列表展示效果
- (IBAction)productsListShowType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.showType == LBCollectionViewTypeDefault) {
        self.showType = LBCollectionViewTypeOne;
        [self.collectionView setCollectionViewLayout:self.tableFlowLayout];
    }else{
        self.showType = LBCollectionViewTypeDefault;
        [self.collectionView setCollectionViewLayout:self.collectionFlowyout];
    }
    [self.collectionView reloadData];
   
}


#pragma mark --- 退出
- (IBAction)backEvent:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    if (self.showType == LBCollectionViewTypeDefault) {
        
        LBIntegralGoodsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.item];
        cell.refrshDatasorece = ^{
            [_collectionView reloadData];
            if(weakSelf.refreshBlock){
                weakSelf.refreshBlock(YES);
            }
        };
        
        return cell;
    }else{
        LBShowProductListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID2 forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.item];
        cell.refrshDatasorece = ^{
            [_collectionView reloadData];
            if(weakSelf.refreshBlock){
                weakSelf.refreshBlock(YES);
            }
        };
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    LBTmallhomepageDataStructureModel *model = self.dataArr[indexPath.item];
    self.hidesBottomBarWhenPushed = YES;
    LBProductDetailViewController  *vc =[[LBProductDetailViewController alloc]init];
    vc.goods_id = model.goods_id;
    vc.index = indexPath.row;
    
    vc.block = ^(NSInteger index, BOOL isCollected) {
        if (isCollected) {
            model.is_collect = @"1";
        }else{
            model.is_collect = @"0";
        }
        if (self.refreshBlock) {
            
            self.refreshBlock(isCollected);
        }
        
        [collectionView reloadData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        self.keyWord = textField.text;
        if (self.keyWord.length <= 0) {
             [EasyShowTextView showText:@"请输入关键字查询"];
            return NO;
        }
        self.page = 1;
        [self loadData:1 refreshDirect:YES];
        return NO;
    }
    
    if ([string isEqualToString:@""] ) {
       
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength == 0) {
            self.keyWord = @"";
            self.page = 1;
            [self loadData:1 refreshDirect:YES];
        }
        
    }
    return YES;
    
}

-(UICollectionViewFlowLayout *)tableFlowLayout{
    
    if (_tableFlowLayout == nil) {
        
        _tableFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _tableFlowLayout.itemSize = CGSizeMake(UIScreenWidth, 100);
        
        _tableFlowLayout.minimumInteritemSpacing = 0;
        
        _tableFlowLayout.minimumLineSpacing = 0;
        
    }
    
    return _tableFlowLayout;
    
}

-(UICollectionViewFlowLayout *)collectionFlowyout{
    
    if (_collectionFlowyout == nil) {
        
        _collectionFlowyout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionFlowyout.itemSize = CGSizeMake((UIScreenWidth - 35)/2.0, (UIScreenWidth - 35)/2.0 + 100);
        
        _collectionFlowyout.minimumLineSpacing = 15;
        
        _collectionFlowyout.minimumInteritemSpacing = 10;
        
        [_collectionFlowyout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
    }
    
    return _collectionFlowyout;
    
}

-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
    
}
@end
