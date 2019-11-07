//
//  QiWKWebViewController.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/8.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "QiWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "QiWKDetailViewController.h"

@interface QiWKWebViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation QiWKWebViewController

- (void)loadView {

    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    webConfiguration.dataDetectorTypes = WKDataDetectorTypePhoneNumber;
    _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
    _webView.backgroundColor = [UIColor whiteColor];
    // 允许左滑右滑手势
    _webView.allowsBackForwardNavigationGestures = YES;
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


#pragma mark - Private Functions

- (void)setupUI {
    
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"WKWebView基本使用";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"WKBack" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(moreItemClicked:)];
    
    CGFloat toolBarH = 44.0;
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barTintColor = [UIColor lightGrayColor];
    toolBar.frame = (CGRect){.0, CGRectGetHeight(self.view.frame) - toolBarH - [[UIApplication sharedApplication].windows firstObject].safeAreaInsets.bottom, CGRectGetWidth(self.view.frame), toolBarH};
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithTitle:@"forward" style:UIBarButtonItemStyleDone target:self action:@selector(forwardButtonClicked:)];
    UIBarButtonItem *backwardItem = [[UIBarButtonItem alloc] initWithTitle:@"backward" style:UIBarButtonItemStyleDone target:self action:@selector(backwardButtonClicked:)];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleDone target:self action:@selector(backwardButtonClicked:)];
    UIBarButtonItem *backforwardListItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleDone target:self action:@selector(backforwardListItemClicked:)];
    UIBarButtonItem *snapItem = [[UIBarButtonItem alloc] initWithTitle:@"snap" style:UIBarButtonItemStyleDone target:self action:@selector(snapItemClicked:)];
    
    toolBar.items = @[backwardItem,forwardItem,refreshItem, backforwardListItem, snapItem];
    
    NSString *urlStr = @"https://www.so.com";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}


#pragma mark - Actions

- (void)leftItemClicked:(UIButton *)sender {
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)forwardButtonClicked:(UIButton *)sender {
    
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}


- (void)backwardButtonClicked:(UIButton *)sender {
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}


- (void)refreshButtonClicked:(UIButton *)sender {
    
    [_webView reload];
}


- (void)backforwardListItemClicked:(UIBarButtonItem *) sender {
    
    NSLog(@"%s", __FUNCTION__);
    if (_webView.backForwardList.forwardList.count > 0) {
        NSLog(@"forwardItem");
        NSLog(@"title：%@", _webView.backForwardList.forwardItem.title);
        NSLog(@"URL：%@", _webView.backForwardList.forwardItem.URL);
    }
    if (_webView.backForwardList.backList.count > 0) {
        NSLog(@"backwardItem");
        NSLog(@"title：%@", _webView.backForwardList.backItem.title);
        NSLog(@"URL：%@", _webView.backForwardList.backItem.URL);
    }
}

- (void)snapItemClicked:(UIBarButtonItem *)sender {
    
    WKSnapshotConfiguration *snapConfig = [[WKSnapshotConfiguration alloc] init];
    [_webView takeSnapshotWithConfiguration:snapConfig completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"%@", snapshotImage);
             UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        } else {
            NSLog(@"error：%@", error);
        }
    }];
}

- (void)moreItemClicked:(UIBarButtonItem *)sender {
    
    QiWKDetailViewController *detailVC = [QiWKDetailViewController new];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@", msg);
}

@end
