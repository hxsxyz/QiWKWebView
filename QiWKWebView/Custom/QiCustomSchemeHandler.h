//
//  QiCustomSchemeHandler.h
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/23.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QiImageDataBlock)(NSData *data, NSURLResponse *response);

@interface QiCustomSchemeHandler : NSObject <WKURLSchemeHandler>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
//! 从哪个控制器过来
@property (nonatomic, strong) UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> *sourceViewController;
//! 图片数据回调
@property (nonatomic, copy) QiImageDataBlock imageDataBlock;

@end

NS_ASSUME_NONNULL_END
