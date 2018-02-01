//
//  LBCommentListsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCommentListsTableViewCell.h"
#import "XHStarRateView.h"
#import "formattime.h"
#import "LBEat_StoreCommentsTableViewCell.h"

@interface LBCommentListsTableViewCell()<UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic)UIImageView *headimage;//头像

@property (strong , nonatomic)UILabel *nameLb;//呢称

@property (strong , nonatomic)UILabel *identifyLb;//ID

@property (strong, nonatomic) XHStarRateView *starRateView;//评分

@property (strong , nonatomic)UILabel *contentLb;//内容

@property (strong , nonatomic)UILabel *timeLb;//时间

@property (strong , nonatomic)UIButton *replayBt;//回复按钮

@property (strong , nonatomic)UILabel *ord_spec_info;//规格名称

@property (strong , nonatomic)UITableView *replaytableview;//评论

@end

static NSString *eat_StoreCommentsTableViewCell = @"LBEat_StoreCommentsTableViewCell";

@implementation LBCommentListsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.replaytableview registerNib:[UINib nibWithNibName:eat_StoreCommentsTableViewCell bundle:nil] forCellReuseIdentifier:eat_StoreCommentsTableViewCell];
    [self initInterFace];
}

-(void)setModel:(LBTmallProductDetailgoodsCommentModel *)model{
    _model = model;
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:nil];
    if ([NSString StringIsNullOrEmpty:_model.nickname] == NO) {
        self.nameLb.text = [NSString stringWithFormat:@"%@",_model.nickname];
    }else{
        self.nameLb.text = [NSString stringWithFormat:@"无呢称"];
    }
    _starRateView.currentScore = [_model.mark floatValue];
    
    self.contentLb.text=[_model.comment stringByRemovingPercentEncoding];
    
    self.identifyLb.text = [NSString stringWithFormat:@"%@",_model.user_name];
    self.timeLb.text = [formattime formateTimeYM:_model.addtime];
    
    if (_model.ord_spec_info.length <= 0) {
        //修改下边距约束
        [self.ord_spec_info mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.identifyLb.mas_bottom).offset(0);
        }];
        
        //更新约束
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
        self.ord_spec_info.text = @"";
    
    }else{
        //修改下边距约束
        [self.ord_spec_info mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.identifyLb.mas_bottom).offset(10);
        }];
        
        //更新约束
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
        self.ord_spec_info.text = [NSString stringWithFormat:@"规格：%@",_model.ord_spec_info];
        
    }
    
    if ([NSString StringIsNullOrEmpty:[self.model.reply stringByRemovingPercentEncoding]]) {//没有回复
        self.replaytableview.hidden = YES;
        //修改下边距约束
        [self.replaytableview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLb.mas_bottom).offset(0);
            make.height.equalTo(@0);
        }];
        //更新约束
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
        
    }else{//有回复
        NSString  *str  = [NSString stringWithFormat:@"商家回复：%@",[self.model.reply stringByRemovingPercentEncoding]];
        CGFloat repalycellH = 0;
         CGRect sizeconent=[str boundingRectWithSize:CGSizeMake(UIScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];//计算评论cell的高度
        
        repalycellH = sizeconent.size.height + 10;
        
        self.replaytableview.hidden = NO;
        //修改下边距约束
        [self.replaytableview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLb.mas_bottom).offset(10);
            make.height.equalTo(@(repalycellH));
        }];
        //更新约束
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }];
        
    }
    
    [self.replaytableview reloadData];
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    if ([NSString StringIsNullOrEmpty:self.model.reply] == NO) {
        return 1;
    }
    return 0; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        tableView.estimatedRowHeight = 10;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;

}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBEat_StoreCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_StoreCommentsTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentReply = [NSString stringWithFormat:@"%@",[self.model.reply stringByRemovingPercentEncoding]];
    return cell;
}

-(void)initInterFace{
    [self addSubview:self.headimage];
    [self addSubview:self.starRateView];
    [self addSubview:self.nameLb];
    [self addSubview:self.identifyLb];
    [self addSubview:self.contentLb];
    [self addSubview:self.timeLb];
    [self addSubview:self.ord_spec_info];
    [self addSubview:self.replaytableview];
    
    //[self addSubview:self.replayBt];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.starRateView.mas_leading).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.headimage.mas_top).offset(0);
        
    }];
    
    [self.identifyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.nameLb.mas_bottom).offset(10);
        
    }];
    
    [self.ord_spec_info mas_makeConstraints:^(MASConstraintMaker *make) {

        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.identifyLb.mas_bottom).offset(0);

    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.ord_spec_info.mas_bottom).offset(13);
        
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.contentLb.mas_bottom).offset(13);

    }];
    
    [self.replaytableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.timeLb.mas_bottom).offset(10);
        
    }];
    
    //    [self.replayBt mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.trailing.equalTo(self).offset(-10);
    //        make.centerY.equalTo(self.timeLb);
    //
    //    }];
    
}

-(UILabel*)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = LBHexadecimalColor(0x666666);
        _nameLb.font = [UIFont systemFontOfSize:13];
    }
    return _nameLb;
}

-(UILabel*)identifyLb{
    if (!_identifyLb) {
        _identifyLb = [[UILabel alloc]init];
        _identifyLb.textColor = LBHexadecimalColor(0x808080);
        _identifyLb.font = [UIFont systemFontOfSize:10];
    }
    return _identifyLb;
}

-(UILabel*)contentLb{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.textColor = LBHexadecimalColor(0x333333);
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}
-(UILabel*)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = LBHexadecimalColor(0x999999);
        _timeLb.font = [UIFont systemFontOfSize:10];
    }
    return _timeLb;
}

-(UILabel*)ord_spec_info{
    if (!_ord_spec_info) {
        _ord_spec_info = [[UILabel alloc]init];
        _ord_spec_info.textColor = LBHexadecimalColor(0x999999);
        _ord_spec_info.font = [UIFont systemFontOfSize:11];
    }
    return _ord_spec_info;
}


-(UIImageView*)headimage{
    if (!_headimage) {
        _headimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        _headimage.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _headimage.layer.cornerRadius = 20;
        _headimage.clipsToBounds = YES;
    }
    return _headimage;
}

//-(UIButton*)replayBt{
//    if (!_replayBt) {
//        _replayBt = [[UIButton alloc]init];
//        _replayBt.bounds = CGRectMake(0, 0, 35, 25);
//        _replayBt.backgroundColor = [UIColor whiteColor];
//        [_replayBt setImage:[UIImage imageNamed:@"eat-pinglun"] forState:UIControlStateNormal];
//        [_replayBt addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return _replayBt;
//}

-(UITableView*)replaytableview{
    if (!_replaytableview) {
        _replaytableview = [[UITableView alloc]init];
        _replaytableview.tableFooterView = [UIView new];
        _replaytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _replaytableview.dataSource = self;
        _replaytableview.delegate = self;
        _replaytableview.scrollEnabled = NO;
    }
    
    return _replaytableview;
}

-(XHStarRateView*)starRateView{
    if (!_starRateView) {
        _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(UIScreenWidth - 90, CGRectGetMinY(self.headimage.frame), 80, 13)];
        _starRateView.isAnimation = YES;
        _starRateView.rateStyle = IncompleteStar;
        _starRateView.backgroundColor = [UIColor clearColor];
    }
    return _starRateView;
}


@end
