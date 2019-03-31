//
//  BView.m
//  HitTestViewDemo
//
//  Created by Slemon on 15/11/24.
//  Copyright © 2015年 Lemons. All rights reserved.
//

#import "BView.h"


@interface BView()<UIGestureRecognizerDelegate>



@end

@implementation BView

- (instancetype)init {
    if (self = [super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}


-(void) taped:(UITapGestureRecognizer*)tap {
    NSLog(@"手势被点击的的view%@",tap.view);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"被点击的view%@ %@",touch.view,touch.view.backgroundColor);
    return YES;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"进入B_View---hitTest withEvent ---");
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开B_View---hitTest withEvent ---hitTestView:%@",view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"B_view---pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"B_view---pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"B_touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"B_touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"B_touchesEnded");
}


@end
