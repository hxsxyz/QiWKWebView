#import "SceneDelegate.h"
#import "QiWKWebViewController.h"

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    UIWindowScene *windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
    QiWKWebViewController *wkWebVC = [QiWKWebViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wkWebVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
