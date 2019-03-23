
### 1) AFN泄漏展示代码
push 一个控制器, 这个 控制器中有一个网络请求. 
```
- (void)requst:(NSString*)url{
//默认配置
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    //AFN3.0+基于封住URLSession的句柄
AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
__weak typeof(manager) weakmanager = manager;
//    __weak typeof(self) weakSelf = self
// AFURLSessionManager *manager = [AppDelegate sharedManager];

//请求
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//下载Task操作
NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];



return [NSURL fileURLWithPath:path];
} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
NSLog(@"错误信息%@",error);
//设置下载完成操作
// filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath path]]) {
NSString *zipPath = [filePath path];// 将NSURL转成NSString
}
//        [weakmanager invalidateSessionCancelingTasks:YES];
}];
[downloadTask resume];
}

```

### 2) 如何查看内存泄漏(2种方式)


>防止干扰 控制器释放, 确保控制器100% 释放 , 重写AFN 所在的控制器的dealloc方法 

#####  2.1) 直接看对象的方式

###### 2.1.1)点击xcode
![image.png](https://upload-images.jianshu.io/upload_images/1194882-02bf6b7f07296a83.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######  2.2.2)  看到1000个对象未释放 
![image.png](https://upload-images.jianshu.io/upload_images/1194882-4ab8cefa732a4fea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


***通过上述发现AFN 的对象未释放 1000次,就有1000 个manager 相关的对象都没有释放***


##### 2.2) instrument 查看 

> 并不是所有的未释放对象都可以instrument 查看 

![image.png](https://upload-images.jianshu.io/upload_images/1194882-ce64c9b25728db47.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 2.3) 泄漏1000次的内存对比

![image.png](https://upload-images.jianshu.io/upload_images/1194882-e04e32add841d6d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/1194882-152fdbc04b024642.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1000次 ,相比一次泄漏 内存5.9M , 如果相关的代码更复杂  ,1000次所耗用 的内存只会更多 

###  3) 内存泄漏修改方式
![image.png](https://upload-images.jianshu.io/upload_images/1194882-590879c614879a20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

修改之后
![image.png](https://upload-images.jianshu.io/upload_images/1194882-a60e5611cdb22160.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/1194882-f997d924b0d2ceca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 4) 两种解决方法的优缺点
##### 4.1) 取消法的优缺点
- 优点: 一次泄漏也没有 , 对象释放最彻底
- 缺点:  改动很麻烦, 每个都需要修改, 如果对AFN 有封装的话, 修改还是比较方便, AFN 没有封装的话, 改动会有很多缺点

##### 4.2) 单例法的优缺点
- 优点: 简单易行 改动方便 
- 缺点 : 在某些情况下 一个manager 由于线程的原因 导致这个manager 出问题, 对象逻辑出问题, 所有后续的网络都没法 复现 , app出现过少量ios12的用户网络失败之后 ,再也无法联网, 通过判断多次失败的方式, 重新构建一个manager , AFN的源码 例子 也是以单例的方式, 


### 5) demo 的链接 
配合视频 看的清楚一些 否则不知道怎么去验证
