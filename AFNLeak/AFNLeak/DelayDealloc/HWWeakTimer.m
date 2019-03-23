// The MIT License (MIT)
//
// Copyright (c) 2015  ( https://github.com/callmewhy )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "HWWeakTimer.h"

@interface HWWeakTimerParam : NSObject
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) NSRunLoopMode runLoopMode;
@end

@implementation HWWeakTimerParam
@end


@interface HWWeakTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;

@end

@implementation HWWeakTimerTarget

- (void)fire:(NSTimer *)timer {
    if(self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id userInfo = timer.userInfo;
        NSRunLoopMode runLoopMode = NSDefaultRunLoopMode;;
        if ([timer.userInfo isKindOfClass:[HWWeakTimerParam class]]) {
            userInfo = [(HWWeakTimerParam *)timer.userInfo userInfo];
            runLoopMode = [(HWWeakTimerParam *)timer.userInfo runLoopMode] ?: NSDefaultRunLoopMode;
        }
        
        [self.target performSelector:self.selector withObject:userInfo afterDelay:0.0f inModes:@[runLoopMode]];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
    }
}

@end

@implementation HWWeakTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:aTarget selector:aSelector userInfo:userInfo repeats:repeats inMode:NSDefaultRunLoopMode];
}
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(HWTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval block:block userInfo:userInfo repeats:repeats inMode:NSDefaultRunLoopMode];
}


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(HWTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats
                                     inMode:(NSRunLoopMode)mode {
    NSMutableArray *userInfoArray = [NSMutableArray arrayWithObject:[block copy]];
    if (userInfo != nil) {
        [userInfoArray addObject:userInfo];
    }
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(_timerBlockInvoke:)
                                       userInfo:[userInfoArray copy]
                                        repeats:repeats
                                         inMode:mode];
}


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats
                                     inMode:(NSRunLoopMode)mode {
    HWWeakTimerTarget* timerTarget = [[HWWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    
    HWWeakTimerParam *param = [[HWWeakTimerParam alloc] init];
    param.userInfo = userInfo;
    param.runLoopMode = mode;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:timerTarget
                                           selector:@selector(fire:)
                                           userInfo:param
                                            repeats:repeats];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];
    timerTarget.timer = timer;
    return timerTarget.timer;
}

+ (void)_timerBlockInvoke:(NSArray*)userInfo {
    HWTimerHandler block = userInfo[0];
    id info = nil;
    if (userInfo.count == 2) {
        info = userInfo[1];
    }
    // or `!block ?: block();` @sunnyxx
    if (block) {
        block(info);
    }
}

@end
