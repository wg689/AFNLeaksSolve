//
//  UIView+FindView.m
//  HitTestViewDemo
//
//  Created by  汪刚 on 2019/3/31.
//  Copyright © 2019年 Lemons. All rights reserved.
//

#import "UIView+FindView.h"
#import <objc/runtime.h>

@implementation UIView (FindView)

static const char NameKey;

- (void)setName:(NSString *)name {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 30)];
    
    label.font = [UIFont systemFontOfSize:18];
    label.text = name;
    label.textColor = [UIColor blackColor];
    
    [self addSubview:label];
    
    objc_setAssociatedObject(self, &NameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, &NameKey);
}

+ (void)load {
    //替换UIView的hitTest方法的实现
    Class cls = [self class];
    
    SEL orignalSelector = @selector(hitTest:withEvent:);
    SEL swizzingSelector = @selector(my_hitTest:withEvent:);
    //注意不要写成class_getClassMethod,在这里卡了半天.
    Method orignalMethod = class_getInstanceMethod(cls, orignalSelector);
    Method swizzingMethod = class_getInstanceMethod(cls, swizzingSelector);
    //添加原方法, 但是方法的实现是要替换的后的方法,如果成功只需要把要交换方法的实现替换为原方法的实现就行了, 如果失败说明类内已有原方法,此时直接交换两个方法的实现即可.
    BOOL success = class_addMethod(cls, orignalSelector, method_getImplementation(swizzingMethod), method_getTypeEncoding(swizzingMethod));
    
    
    if (!success) {
        //这里的方法实现的获取不能使用class_getImplementation, 因为这里的原方法是已经交换过后的.
        method_exchangeImplementations(orignalMethod, swizzingMethod);
    } else {
        class_replaceMethod(cls, swizzingSelector, method_getImplementation(orignalMethod), method_getTypeEncoding(orignalMethod));
    }
}

- (UIView *)my_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
//    NSString *name = objc_getAssociatedObject(self, &NameKey);
    NSString *selfClass = NSStringFromClass([self class]);
    

    if ([self isMemberOfClass:[UIView class]]) {
        NSLog(@"------%@------", selfClass);
    }
    return [self my_hitTest:point withEvent:event];//此处不会引发循环调用,因为方法已经在runtime中调用过了.
}



@end
