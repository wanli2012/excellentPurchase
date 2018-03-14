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
//    self.webview.delegate = self;
}

-(void)setUrlstr:(NSString *)urlstr{
    _urlstr = urlstr;
    if ([NSString StringIsNullOrEmpty:urlstr] ==  NO && self.isload == NO) {
         [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
        self.isload = YES;
        
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        NSInvocationOperation *op=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downLoadWeb) object:nil];
        [queue addOperation:op];
    }

}

-(void)downLoadWeb
{
    
    NSURL *url=[NSURL URLWithString:_urlstr];
    
    NSError *error;
    
    NSString *strData=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    NSData *data=[strData dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data !=nil) {
        
        [self performSelectorOnMainThread:@selector(downLoad_completed:) withObject:data waitUntilDone:NO];
    }
    else
    {
        NSLog(@"error when download:%@",error);
        
    }
}
-(void)downLoad_completed:(NSData *)data
{
    
    NSURL *url=[NSURL URLWithString:_urlstr];
    NSString *nameType=[self mimeType:url];
    
    [_webview loadData:data MIMEType:nameType textEncodingName:@"UTF-8" baseURL:url];
    float height = [[self.webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
    //设置通知或者代理来传高度
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil  userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
    
}
- (NSString *)mimeType:(NSURL *)url
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return response.MIMEType;
}


//-(void)webViewDidStartLoad:(UIWebView *)webView{
//
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //  float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];     //此方法获取webview的内容高度，但是有时获取的不完全
//    //  float height = [webView sizeThatFits:CGSizeZero].height; //此方法获取webview的高度
//    float height = [[self.webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
//    //设置通知或者代理来传高度
//
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil  userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//
//}

@end
