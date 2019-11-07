//
//  QiWKDetailViewController.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/8.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "QiWKDetailViewController.h"
#import <WebKit/WebKit.h>

@interface QiWKDetailViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation QiWKDetailViewController

- (void)loadView {
    
    WKWebViewConfiguration *webConfig = [WKWebViewConfiguration new];
    webConfig.dataDetectorTypes = WKDataDetectorTypePhoneNumber;
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.backgroundColor = [UIColor whiteColor];
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WKWebView常见问题";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"WKBack" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadFileURL:[[NSBundle mainBundle] URLForResource:@"QiLink" withExtension:@"html"] allowingReadAccessToURL:[[NSBundle mainBundle] bundleURL]];
    /*
    NSString *localHtmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QiLink" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:localHtmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
     */
}

- (void)leftItemClicked:(UIBarButtonItem *)sender {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSInteger index = viewControllers.count - 2 > 0 ? viewControllers.count - 2 : 0;
    [self.navigationController popToViewController:viewControllers[index] animated:YES];
}

#pragma mark - Delegates

#pragma mark - UIDelegate
// creates a new web view.
// The web view returned must be created with the specified configuration. WebKit loads the request in the returned web view.
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
    /* // 跳转到Safari打开url
    if (navigationAction.request.URL) {
        
        NSURL *url = navigationAction.request.URL;
        if ([navigationAction.request.URL.absoluteString hasPrefix:@"http"]) {
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @(NO)} completionHandler:^(BOOL success) {
                NSLog(@"success：%@", @(success));
            }];
        }
    }
    return nil;
     */
}

//! Alert弹框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//! Confirm弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];

    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

//! prompt弹框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// Decides whether to allow or cancel a navigation.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url = navigationAction.request.URL;

    if ([url.absoluteString hasPrefix:@"http"]) {
        // The target frame, or nil if this is a new window navigation.
        if (!navigationAction.targetFrame) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if ([url.absoluteString hasPrefix:@"file://"]) {
        // 加载本地文件
        if (!navigationAction.targetFrame) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @(NO)} completionHandler:^(BOOL success) {
                // 成功调起三方App之后
                NSLog(@"success：%@", @(success));
            }];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            // was called more than once'
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }
}

//// Decides whether to allow or cancel a navigation.
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    NSLog(@"%@", webView.URL);
//    NSLog(@"%@", navigationAction.request.URL);
//    NSURL *url = navigationAction.request.URL;
//
//    if ([url.absoluteString hasPrefix:@"http"]) {
//        // The target frame, or nil if this is a new window navigation.
////        if (!navigationAction.targetFrame) {
////            [webView loadRequest:navigationAction.request];
////        }
////        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

/*
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"错误信息：%@", error);
    if (error.code == -999) {
        return;
    }
}
 */


@end
