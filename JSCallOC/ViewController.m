//
//  ViewController.m
//  JSCallOC
//
//  Created by liujing on 6/24/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"

#define kURLJSParamTagKey @"jsparam"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.webview.delegate=self;
    
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSURL * baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString * htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:(NSUTF8StringEncoding) error:nil];
    [self.webview loadHTMLString:htmlString baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"jean"]) {
        
        NSString *urlStr=[url query];//拿到查询字符串
        NSString *paramString = [urlStr substringFromIndex:[kURLJSParamTagKey length] + 1];//拿到jsparam＝后面的内容
        paramString =[paramString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//URL解码
        
        NSDictionary *urlParamMap = [paramString  objectFromJSONString];//string转换成dictionary
        NSString *param = [urlParamMap objectForKey:@"param"];//拿到h5传给native的数据
        NSLog(@"the data passed from h5 to native is %@",param);
        
        NSString *callbackMethod = [urlParamMap objectForKey:@"callbackMethod"];//拿到callbackMethod的名字
        NSString *callbackParam=@"88888888";//你想回传给h5的数据
        
        NSString * js =[NSString stringWithFormat:@"%@('%@')",callbackMethod,callbackParam];//js字串
        [self.webview stringByEvaluatingJavaScriptFromString:js];//执行js
        
        //        UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:@"test" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        //        [alertView show];
        return NO;
    }
    
    return YES;
}

- (IBAction)tapedBtn:(id)sender {
    
    NSString * js = @" var p = document.createElement('p'); p.innerText = 'new Line';document.body.appendChild(p);";
    [self.webview stringByEvaluatingJavaScriptFromString:js];
}

@end
