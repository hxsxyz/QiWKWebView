//
//  QiWKScriptViewController.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/11/4.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "QiWKScriptViewController.h"
#import <WebKit/WebKit.h>

@interface QiWKScriptViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation QiWKScriptViewController

- (void)loadView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame: [UIScreen mainScreen].bounds configuration:config];
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    
    NSURL *url = [NSURL URLWithString:@"https://en.wikipedia.org/wiki/Qihoo_360"];
    // url = [NSURL URLWithString:@"https://www.so.com"];
    // url = [NSURL URLWithString:@"https://m.baike.so.com/doc/824561-872078.html"]; //不能正常加载 除非配置了ATS
    // 手机端使用
    // url =[NSURL URLWithString:@"https://m.baike.so.com/doc/824561-872078.html"];
    // 手机端使用
    // url = [NSURL URLWithString:@"https://en.m.wikipedia.org/wiki/Qihoo_360"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [_webView loadRequest:request];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    [webView reload];
    NSLog(@"进程终止");
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if (navigationAction.targetFrame) {
//
//    } else {
//        [webView loadRequest:navigationAction.request];
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//    /*
//     (lldb) po navigationAction.sourceFrame
//      nil
//     po navigationAction.targetFrame
//     (lldb) po navigationAction.sourceFrame
//      nil
//     (lldb) po navigationAction.sourceFrame.request
//     nil
//     */
//}
//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//
//}
//
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
//
//    NSLog(@"%@", challenge.protectionSpace.serverTrust);
//    NSURLCredential *trustCredential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
//    completionHandler(NSURLSessionAuthChallengeUseCredential, trustCredential);
//}
//
//
//
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//
//    WKFrameInfo *frameInfo = navigationAction.targetFrame;
//    if (!frameInfo.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//
//    NSLog(@"%@", webView.URL);
//    NSLog(@"%@", navigationAction.targetFrame);
//    return nil;
//}


@end
