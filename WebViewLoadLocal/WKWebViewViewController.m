//
//  WKWebViewViewController.m
//  CESHI
//
//  Created by gfy on 2017/9/22.
//  Copyright © 2017年 gfy. All rights reserved.
//

#import "WKWebViewViewController.h"
@import WebKit;
@interface WKWebViewViewController ()<WKNavigationDelegate>

@end

@implementation WKWebViewViewController
- (void)dealloc {

    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self aaaaaaa];
    
}
-(void)aaaaaaa
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *matPath1 = [[array1 objectAtIndex:0] stringByAppendingPathComponent:@"QueHTML"];;
    if (![fileManager fileExistsAtPath:matPath1]) {
        NSString *matString = [[NSBundle mainBundle] pathForResource:@"QueHTML" ofType:@"bundle"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [fileManager removeItemAtPath:matPath1 error:nil];
            
            [fileManager copyItemAtPath:matString toPath:matPath1 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"呵呵  创建完了");
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
                    [self testios8];
                }
                else{
                    [self testios9];
                }
            });
        });
    }
    else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <9.0) {
            [self testios8];
        }
        else{
            [self testios9];
        }
    }
}


- (void)testios8 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/"];
    NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:basePath]];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height -64 )];
//    webView.layer.cornerRadius = 1.0f;
//    webView.layer.borderColor = [UIColor redColor].CGColor;
//    webView.layer.borderWidth = 2.0f;
    webView.navigationDelegate = self;
    [self.view  addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"www/QueHTML/123.html"]]]]];
}

- (void)testios9 {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/"];
    NSString *htmlPath =  [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/123.html"];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    webView.navigationDelegate = self;
    [self.view  addSubview:webView];
    NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadFileURL:fileURL allowingReadAccessToURL:[NSURL fileURLWithPath:basePath isDirectory:YES]];
    
}

//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

#pragma mark WKNavigationDelegate
/*! @abstract Decides whether to allow or cancel a navigation.
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    
//}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//    
//}

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

    NSLog(@"%s",__func__);
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s",__func__);
    
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
 NSLog(@"%s",__func__);
    
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {

    NSLog(@"%s",__func__);
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    NSLog(@"%s",__func__);
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

    NSLog(@"%s",__func__);
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//
//    
//}

/*! @abstract Invoked when the web view's web content process is terminated.
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {

    NSLog(@"哈哈哈=== %@",webView.URL);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
