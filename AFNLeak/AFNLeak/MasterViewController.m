//
//  MasterViewController.m
//  AFNLeak
//
//  Created by  汪刚 on 2019/3/23.
//  Copyright © 2019年 wg689. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AFURLSessionManager.h"
#import "DeallocDetailViewController.h"




@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

}
/*
 1) AFN泄漏 展示
 2) 如何查看内存泄漏(2种方式)
 2.0)
 2.1) 直接看对象的方式
 2.2) 防止干扰 控制器释放
 2.4) 泄漏1000次的内存对比

 
 3) 内存泄漏修改方式
 3.1)  取消法  验证
 3.2)  单例法   验证
 
 4) 两种解决方法的优缺点
 
 */









- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Segues



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        DetailViewController *con = [[DetailViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }else{
        DeallocDetailViewController *con  = [[DeallocDetailViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.textLabel.text = @"点击这里来测试AFN 泄漏相关的释放";
    } if(indexPath.row == 1){
        cell.textLabel.text = @"点击这里来测试控制器延迟释放";
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

- (void)dealloc
{
    NSLog(@"释放%@" ,[self class]);
}

@end
