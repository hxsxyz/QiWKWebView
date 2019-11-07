//
//  QiCustomSchemeHandler.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/23.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "QiCustomSchemeHandler.h"
#import <WebKit/WebKit.h>

@interface QiCustomSchemeHandler () <WKURLSchemeHandler>

@end

@implementation QiCustomSchemeHandler

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    
    NSLog(@"%@", urlSchemeTask);
    NSLog(@"request：%@", urlSchemeTask.request);
    NSLog(@"absoluteString：%@", urlSchemeTask.request.URL.absoluteString);
    if ([urlSchemeTask.request.URL.absoluteString hasPrefix:@"qilocal://"]) { // qiLocal
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageDataBlock = ^(NSData * _Nonnull data, NSURLResponse * _Nonnull response) {
                NSLog(@"response信息：%@", response);
                [urlSchemeTask didReceiveResponse:response];
                [urlSchemeTask didReceiveData:data];
                [urlSchemeTask didFinish];
            };
            UIImagePickerController *imagePicker = [UIImagePickerController new];
            imagePicker.delegate = self.sourceViewController;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.sourceViewController showViewController:imagePicker sender:nil];
            self.imagePickerController = imagePicker;
        });
    }
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    
}

@end
