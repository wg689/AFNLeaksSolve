//
//  ViewController.m
//  HitTestViewDemo
//
//  Created by Slemon on 15/11/24.
//  Copyright © 2015年 Lemons. All rights reserved.
//

#import "ViewController.h"
#import "CView.h"
#import "AView.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet CView *CView;
@property (weak, nonatomic) IBOutlet AView *viewA;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
-(void) taped:(UITapGestureRecognizer*)tap {
    NSLog(@"手势被点击的的view%@",tap.view);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"被点击的view%@ %@",touch.view,touch.view.backgroundColor);
    return YES;
}

- (IBAction)uibuttonClicked:(id)sender {
    NSLog(@"btn 被点击");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
