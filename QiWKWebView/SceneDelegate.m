#import "SceneDelegate.h"
#import "ViewController.h"

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        self.window.frame = windowScene.coordinateSpace.bounds;
        ViewController *vc = [ViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
}

@end
