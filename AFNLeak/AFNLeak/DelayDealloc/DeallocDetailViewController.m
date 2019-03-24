//
//  DetailViewController.m
//  AFNLeak
//
//  Created by  汪刚 on 2019/3/23.
//  Copyright © 2019年 wg689. All rights reserved.
//

#import "DeallocDetailViewController.h"
#import "AFURLSessionManager.h"
#import "AppDelegate.h"
#import "ClassA.h"
#import "ClassB.h"
#import "ClassB.h"
#import "HWWeakTimer.h"

//解循环引用

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object)                                                        \
autoreleasepool {}                                                           \
__weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)                                                        \
autoreleasepool {}                                                           \
__block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object)                                                        \
try {                                                                        \
} @finally {                                                                 \
}                                                                            \
{}                                                                           \
__weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)                                                        \
try {                                                                        \
} @finally {                                                                 \
}                                                                            \
{}                                                                           \
__block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object)                                                      \
autoreleasepool {}                                                           \
__typeof__(object) object = weak##_##object;
#else
#define strongify(object)                                                      \
autoreleasepool {}                                                           \
__typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object)                                                      \
try {                                                                        \
} @finally {                                                                 \
}                                                                            \
__typeof__(object) object = weak##_##object;
#else
#define strongify(object)                                                      \
try {                                                                        \
} @finally {                                                                 \
}                                                                            \
__typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface DeallocDetailViewController () {
    NSTimer *_timer;
}

@end

@implementation DeallocDetailViewController

// view did load 的会调用

// 测试延迟释放相关
- (void)testDelayDealloc {
    // relase会延迟释放
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       for (int i = 0; i < 10; i++) {
                           [self
                            requst:@"http://forspeed.onlinedown.net/down/YJPDFViewer2.0.zip"];
                       }
                   });
    
    //      方案一  weak 下 会 可以解决延迟释放
    //        __weak typeof(self) weakSelf = self;
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 *
    //        NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            for(int i = 0;i< 10;i++){
    //                [weakSelf
    //                requst:@"http://forspeed.onlinedown.net/down/YJPDFViewer2.0.zip"];
    //            }
    //        });
    //
    
    // 方案2 weak strong 可以解决延迟释放  为加 weak strong 会延迟释放
    //    @weakify(self)
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 *
    //    NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        @strongify(self)
    //        for(int i = 0;i< 10;i++){
    //            [self
    //            requst:@"http://forspeed.onlinedown.net/down/YJPDFViewer2.0.zip"];
    //        }
    //    });
    
    // 这种定时器会引起延时释放 , 如果非repeat 的话 直到 5 秒之后才会释放 ,
    // 如果是repeat 的话 控制器 会一致导致控制器不释放
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self
    //    selector:@selector(handleTimer:)
    //                                                              userInfo:nil
    //                                                              repeats:NO];
    
    // 这里的不会引起延迟释放  但是会导致 a 对象和b 对象不释放 , 当前的控制器对a b
    // 对象无引用, 但是a b 对象内部会形成引用环
    //    for(int i = 0;i <10;i ++){
    //        ClassA *a = [[ClassA alloc] init];
    //        ClassB *b = [[ClassB alloc] init];
    //        a.classb  = b;
    //        b.classa = a;
    //    }
    
    // 这里使用了weaktimer 之后 不管 是否repeat 控制器都可以及时的释放
    //    _timer = [HWWeakTimer scheduledTimerWithTimeInterval:5 target:self
    //    selector:@selector(handleTimer:)
    //                                                                  userInfo:nil
    //                                                                  repeats:YES];
}

// 测试内存泄漏相关
- (void)testLeaks {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(handleTimer:)
                                            userInfo:nil
                                             repeats:YES];
    
    //    // 对象导致内存泄漏
    //    for(int i = 0;i <10;i ++){
    //        ClassA *a = [[ClassA alloc] init];
    //        ClassB *b = [[ClassB alloc] init];
    //        a.classb  = b;
    //        b.classa = a;
    //    }
}

- (void)testAFNLeasks {
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       for (int i = 0; i < 10; i++) {
                           [self
                            requst:@"http://forspeed.onlinedown.net/down/YJPDFViewer2.0.zip"];
                       }
                   });
}

- (void)handleTimer:(id)sender {
    NSLog(@"%@ say: Hi!", [self class]);
    
    ClassB *b = [[ClassB alloc] init];
}
- (void)cleanTimer {
    [_timer invalidate];
    _timer = nil;
    NSLog(@"定时器%@", _timer);
}

- (void)requst:(NSString *)url {
    //默认配置
    NSURLSessionConfiguration *configuration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    // AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager =
    [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    __weak typeof(manager) weakmanager = manager;
    //    __weak typeof(self) weakSelf = self;
    //    AFURLSessionManager *manager = [AppDelegate sharedManager];
    
    //请求
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager
                                              downloadTaskWithRequest:request
                                              progress:nil
                                              destination:^NSURL *_Nonnull(NSURL *_Nonnull targetPath,
                                                                           NSURLResponse *_Nonnull response) {
                                                  //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
                                                  NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(
                                                                                                              NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                                  NSString *path = [cachesPath
                                                                    stringByAppendingPathComponent:response.suggestedFilename];
                                                  
                                                  return [NSURL fileURLWithPath:path];
                                              }
                                              completionHandler:^(NSURLResponse *_Nonnull response,
                                                                  NSURL *_Nullable filePath, NSError *_Nullable error) {
                                                  NSLog(@"错误信息%@", error);
                                                  //设置下载完成操作
                                                  // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
                                                  if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath path]]) {
                                                  }
                                                  [weakmanager invalidateSessionCancelingTasks:YES];
                                              }];
    [downloadTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //  测试延迟释放相关的代码
    [self testDelayDealloc];
    
    // 测试内存泄漏相关的代码
    //    [self testLeaks];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDate *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)dealloc
{
    
#ifdef DEBUG
    NSLog(@"debug 释放%@" ,[self class]);
#else
    NSLog(@"release 释放%@" ,[self class]);
#endif
    
    [self cleanTimer];
}


@end
