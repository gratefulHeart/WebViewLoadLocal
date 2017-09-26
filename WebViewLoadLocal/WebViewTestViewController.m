//
//  WebViewTestViewController.m
//  CESHI
//
//  Created by gfy on 2017/9/22.
//  Copyright © 2017年 gfy. All rights reserved.
//

#import "WebViewTestViewController.h"

@interface WebViewTestViewController ()<UIWebViewDelegate>
{

    UIScrollView *scrollView;
    
}
@end

@implementation WebViewTestViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self bbbbbb];
}

-(void)bbbbbb
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
                [self createWebView];
                
            });
        });
    }
    else{
        [self createWebView];
    }
    
}
- (void)createWebView {

    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    webView.delegate = self;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/"];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"html"];
    NSString *htmlString2 = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString2 baseURL:[NSURL URLWithString:basePath]];    
    [self.view addSubview:webView];

}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%s",__func__);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s",__func__);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s",__func__);
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
