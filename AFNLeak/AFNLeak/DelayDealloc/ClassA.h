//
//  ClassA.h
//  AFNLeak
//
//  Created by  汪刚 on 2019/3/23.
//  Copyright © 2019年 wg689. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassB.h"
@class ClassB;
@interface ClassA : NSObject
@property(nonatomic,strong) ClassB  *classb;
@end
