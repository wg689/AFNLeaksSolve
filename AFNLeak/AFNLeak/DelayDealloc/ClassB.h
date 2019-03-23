//
//  ClassB.h
//  AFNLeak
//
//  Created by  汪刚 on 2019/3/23.
//  Copyright © 2019年 wg689. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClassA.h"
@class ClassA;
@interface ClassB : NSObject

@property(nonatomic,strong) ClassA  *classa;

@end
