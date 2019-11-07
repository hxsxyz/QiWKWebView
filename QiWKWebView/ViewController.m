//
//  ViewController.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/8.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "ViewController.h"
#import "QiWKWebViewController.h"
#import "QiCustomWKWebViewController.h"
#import "QiWKScriptViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"WKWebView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *wkBasicUseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wkBasicUseButton setTitle:@"WKWebView基础使用" forState:UIControlStateNormal];
    wkBasicUseButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:wkBasicUseButton];
    [wkBasicUseButton sizeToFit];
    wkBasicUseButton.center = self.view.center;
    [wkBasicUseButton addTarget:self action:@selector(wkBasicUseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *customWKWebViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customWKWebViewButton setTitle:@"自定义WKWebView显示内容" forState:UIControlStateNormal];
    customWKWebViewButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:customWKWebViewButton];
    [customWKWebViewButton sizeToFit];
    customWKWebViewButton.center = (CGPoint){CGRectGetMidX(wkBasicUseButton.frame), CGRectGetMidY(wkBasicUseButton.frame) + 100.0};
    [customWKWebViewButton addTarget:self action:@selector(customWKWebViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *scriptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scriptButton setTitle:@"自定义WKWebView显示内容" forState:UIControlStateNormal];
    scriptButton.backgroundColor = [UIColor grayColor];
    // [self.view addSubview:scriptButton];
    [scriptButton sizeToFit];
    scriptButton.center = (CGPoint){CGRectGetMidX(wkBasicUseButton.frame), CGRectGetMidY(customWKWebViewButton.frame) + 100.0};
    [scriptButton addTarget:self action:@selector(scriptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scriptButtonClicked:(UIButton *)sender {
    
    QiWKScriptViewController *scriptVC = [QiWKScriptViewController new];
    [self.navigationController pushViewController:scriptVC animated:YES];
}

- (void)customWKWebViewButtonClicked:(UIButton *)sender {

   [self.navigationController pushViewController:[QiCustomWKWebViewController new] animated:YES];
}

- (void)wkBasicUseButtonClicked:(UIButton *)sender {
   
   [self.navigationController pushViewController:[QiWKWebViewController new] animated:YES];
}
@end
