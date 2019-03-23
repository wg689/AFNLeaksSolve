//
//  DetailViewController.h
//  AFNLeak
//
//  Created by  汪刚 on 2019/3/23.
//  Copyright © 2019年 wg689. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

