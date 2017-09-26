# UIWebView和WKWebView加载本地文件（html ,js,css,image files）
* 参考链接：

  * 1、https://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8

  * 2、https://github.com/ShingoFukuyama/WKWebViewTips/blob/master/README.md

  * 3、http://blog.csdn.net/xj_love/article/details/52062874

## 一、UIWebView加载本地资源   (资源文件可以放到工程目录下也可以放到沙盒里面)
```objectivec
      [webView loadHTMLString:#<html代码字符串># baseURL:[NSURL URLWithString:#<其他资源文件夹路径如js、css等>#]];
```

Demo

```objectivec
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    webView.delegate = self;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/"];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"html"];
    NSString *htmlString2 = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString2 baseURL:[NSURL URLWithString:basePath]];
```

## 二、WKWebView加载本地资源   (资源文件可以放到工程目录下也可以放到沙盒里面)
### 1、iOS8

iOS8 使用WKWebView加载带有js css和资源文件的html需要使用loadRequest
iOS8下使用

loadHTMLString：baseURL：

会出现加载报错的情况

This is what I learned about WKWebView, Apple's new WebKit API debuted on iOS 8.

As of this writing, the latest iOS version is iOS 8.1.3.

file:/// doesn't work without tmp directory

所以需要做一下处理： 把文件拷贝到tmp下面
```objectivec

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

```
Demo

```objectivec

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/"];
    NSString *htmlPath =  [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/123.html"];
    NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:basePath]];
    NSString *htmlString = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"www/QueHTML/123.html"]] encoding:NSUTF8StringEncoding error:nil];//获取文件路径，现在html的文件路径已经改了。
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    webView.navigationDelegate = self;
    [self.view  addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat:@"www/QueHTML/123.html"]]]]];
    
```
### 2、iOS9~iOS11

iOS9~iOS11 使用这个API

loadFileURL：#<HTML文件路径URL># allowingReadAccessToURL：#<资源文件夹路径URL>#

Demo

```objectivec

NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/"];
    NSString *htmlPath =  [NSString stringWithFormat:@"%@/%@",path,@"QueHTML/123.html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];//获取文件路径，现在html的文件路径已经改了。

    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0 * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webView.navigationDelegate = self;
    [self.view  addSubview:webView];

    [webView loadFileURL:fileURL allowingReadAccessToURL:[NSURL fileURLWithPath:basePath isDirectory:YES]];
    
 ```
    
