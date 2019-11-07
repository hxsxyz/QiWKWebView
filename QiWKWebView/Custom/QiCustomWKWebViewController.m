//
//  QiCustomWKWebViewController.m
//  QiWKWebView
//
//  Created by wangyongwang on 2019/10/23.
//  Copyright © 2019 QiShare. All rights reserved.
//

#import "QiCustomWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "QiCustomSchemeHandler.h"

@interface QiCustomWKWebViewController () < WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) QiCustomSchemeHandler *schemeHandler;

@end

@implementation QiCustomWKWebViewController

- (void)loadView {

    WKWebViewConfiguration *webConfig = [WKWebViewConfiguration new];
    _schemeHandler = [QiCustomSchemeHandler new];
    // [webConfig setURLSchemeHandler:_schemeHandler forURLScheme:@"qiLocal"];
    // https qilocal
    // Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: ''https' is a URL scheme that WKWebView handles natively'

    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.backgroundColor = [UIColor whiteColor];
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClicked:)];
    
    _schemeHandler.sourceViewController = self;
    // [self configMakeHttps];
    // [self configBlockURL];
    // [self configBlockLoadSomeResource];
    
    _webView.navigationDelegate = self;
    [self loadCustomResourceHtml];
    
    // [self loadContentRuleHtml];
    // [self loadWebContent];
    // [self loadCustomResourceHtml];
}

//! 加载自定义资源
- (void)loadCustomResourceHtml {
    
    self.title = @"loadCustomResource";
    [_webView loadFileURL:[[NSBundle mainBundle] URLForResource:@"QiCustomResource" withExtension:@"html"] allowingReadAccessToURL:[[NSBundle mainBundle] bundleURL]];
}

//! 加载网络内容
- (void)loadWebContent {
    
    self.title = @"WKContentRuleList";
    // [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.so.com"]]];
    [_webView loadRequest: [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.jianshu.com/u/3db23baa08c7"]]];
}

//! 加载ContentRuleList测试内容
- (void)loadContentRuleHtml {
    
    self.title = @"WKContentRuleList";
    [_webView loadFileURL:[[NSBundle mainBundle] URLForResource:@"QiContentRule" withExtension:@"html"] allowingReadAccessToURL:[[NSBundle mainBundle] bundleURL]];
}

//! 配置阻塞某些资源的加载
- (void)configBlockLoadSomeResource {
    
        NSArray *jsonArr =
      @[
    // block资源
      @{
          @"trigger": @{
                  @"url-filter": @".*",
                  // @"resource-type": @[@"image", @"style-sheet", @"font", @"script", @"document", @"media", @"popup"],
                  @"resource-type": @[@"image"],
                  // @"unless-domain": @[@"www.jianshu.com"],
                  @"if-domain": @[@"www.jianshu.com"],
          },
          @"action": @{
                  //block：Stops loading of the resource. If the resource was cached, the cache is ignored.
                  // 停止加载资源。 如果已缓存资源，则忽略缓存。
                   @"type": @"block"
          }
      }
      ];
    [self compileContentRuleWithJsonArray:jsonArr];
}

- (void)configBlockURL {
    
    NSArray *jsonArr =
        @[
            @{
                @"trigger": @{
                        // 配置特定的URL 也可以通过正则匹配符合其他条件的URL
                        @"url-filter": @"(https://upload.jianshu.io/users/upload_avatars/2628633/c6a17aeb-04be-4862-9b2d-01db2a3dd16c.png)",
    
                },
                 @"action": @{
                         @"type": @"block"
                 }
             },
            // 下边字典 笔者又测试了一次make-https 把http 转为https 这部分内容不是block的内容
            @{
                  @"trigger": @{
                          @"url-filter": @".*"
                  },
                  @"action": @{
                          @"type": @"make-https"
                  }
            },
        ];
    [self compileContentRuleWithJsonArray:jsonArr];
}

- (void)configMakeHttps {
    
     NSArray *jsonArr =
      @[@{
            @"trigger": @{
                    @"url-filter": @".*"
            },
            @"action": @{
                    @"type": @"make-https"
            }
      },
      ];
   
    [self compileContentRuleWithJsonArray:jsonArr];
}

- (void)compileContentRuleWithJsonArray:(NSArray *)jsonArr {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[WKContentRuleListStore defaultStore] compileContentRuleListForIdentifier:@"ContentBlockingRules"
                                                        encodedContentRuleList:jsonStr
                                                             completionHandler:^(WKContentRuleList *ruleList, NSError *err) {
        if (ruleList) {
            [self.webView.configuration.userContentController addContentRuleList:ruleList];
            NSLog(@"编译的ruleList：%@", ruleList);
        } else {
            NSLog(@"编译的ruleList为空，错误信息：%@", err);
        }
    }];
}


- (void)configContentRuleList {
    
    NSArray *jsonArr =
  @[@{
        // url-filter：specifies a pattern to match the URL against.
        // 指定一个正则表达式或匹配URL
        // @"url-filter": @".*" 匹配加载过的所有URL
        // 匹配所有带有零次或多次出现的点的字符串。 使用此语法来匹配每个URL。
        
        // .* make-https 对于所有的url的请求进行https的处理
        @"trigger": @{
                @"url-filter": @".*"
                // @"url-filter": @"https://upload.jianshu.io/collections/images/1673367/8.png?imageMogr2/auto-orient/strip"
        },
        @"action": @{
                //  make-https：Changes a URL from http to https. URLs with a specified (nondefault) port and links using other protocols are unaffected.
                // make-https：将URL从http更改为https。 具有指定（非默认）端口的URL和使用其他协议的链接不受影响。
                // 如果对应的httpsURL可以正常加载，则会加载https的内容，否则仍然会加载失败。
                @"type": @"make-https"
        }
  },
  
  @{
        // 针对url中包含的字符串或具体的url选择是否阻塞加载
       @"trigger": @{
               // @"url-filter": @"(2628633)"
               // @"url-filter": @"jianshu",
     @"url-filter": @"(2628633)",
       },
       @"action": @{
               @"type": @"block"
       }
   },
  
// block资源
  @{
      @"trigger": @{
              @"url-filter": @".*",
              // @"resource-type": @[@"image", @"style-sheet", @"font", @"script", @"document", @"media", @"popup"],
              @"resource-type": @[@"image"],
              // @"unless-domain": @[@"www.jianshu.com"],
              @"if-domain": @[@"www.jianshu.com"],
      },
      @"action": @{
              //block：Stops loading of the resource. If the resource was cached, the cache is ignored.
              // 停止加载资源。 如果已缓存资源，则忽略缓存。
               @"type": @"block"
      }
  },
  
  
  ];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%s", __FUNCTION__);
    // Compiles a new rules list and adds it to the store.
    // 编译新的rules list 并且添加到WKContentRuleListStore中
    [[WKContentRuleListStore defaultStore] compileContentRuleListForIdentifier:@"ContentBlockingRules"
                                                        encodedContentRuleList:jsonStr
                                                             completionHandler:^(WKContentRuleList *ruleList, NSError *err) {
        if (ruleList) {
            [self.webView.configuration.userContentController addContentRuleList:ruleList];
            NSLog(@"编译的ruleList：%@", ruleList);
        } else {
            NSLog(@"编译的ruleList为空，错误信息：%@", err);
        }
    }];
    
    // 查询WKContentRuleList
    [[WKContentRuleListStore defaultStore] lookUpContentRuleListForIdentifier:@"ContentBlockingRules"
    completionHandler:^(WKContentRuleList *ruleList, NSError *error) {
        if (ruleList) {
            NSLog(@"查询ruleList：%@", ruleList);
        } else {
            NSLog(@"查询ruleList错误信息：%@", error);
        }
    }];
}

#pragma mark - Actions

- (void)leftItemClicked:(UIBarButtonItem *)sender {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // NSData *data = UIImagePNGRepresentation(image);
    // 使用png方式压缩的图片 显示可能异常 可能是因为图片太大了
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"qiLocalImage://"] MIMEType:@"image/jpeg" expectedContentLength:data.length textEncodingName:NULL];
    if (self.schemeHandler.imageDataBlock) {
        self.schemeHandler.imageDataBlock(data, response);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}



@end
