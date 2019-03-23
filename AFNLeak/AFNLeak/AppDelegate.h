//
//  AppDelegate.h
//  AFNLeak
//
//  Created by  汪刚 on 2019/3/23.
//  Copyright © 2019年 wg689. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFURLSessionManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AFURLSessionManager*)sharedManager ;

@end

