//
//  LBriceshopwebviewTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBriceshopwebviewTableViewCell.h"

@implementation LBriceshopwebviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.webview.delegate = self;
}

-(void)setUrlstr:(NSString *)urlstr{
    _urlstr = urlstr;
    if ([NSString StringIsNullOrEmpty:urlstr] ==  NO && self.isload == NO) {
         [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
    }

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.isload = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //  float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];     //此方法获取webview的内容高度，但是有时获取的不完全
    //  float height = [webView sizeThatFits:CGSizeZero].height; //此方法获取webview的高度
    float height = [[self.webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
    //设置通知或者代理来传高度
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil  userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.isload = NO;
}

@end
