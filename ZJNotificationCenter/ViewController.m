//
//  ViewController.m
//  ZJNotificationCenter
//
//  Created by YZJ on 2020/4/10.
//  Copyright © 2020 YZJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJNotificationCenter.h"
#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"发通知" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(postNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    ZJNotificationCenter *center = [ZJNotificationCenter defaultCenter];
    
    // 参错错误
    [center addObserver:self selector:nil name:nil object:nil];
    [center addObserver:nil selector:@selector(name00:) name:nil object:nil];
    [center addObserver:nil selector:nil name:nil object:nil];
    
    // name空
    [center addObserver:self selector:@selector(name00:) name:nil object:nil];
    [center addObserver:self selector:@selector(name01:) name:nil object:self.view];
    
    // name不空
    [center addObserver:self selector:@selector(name10:) name:@"name1" object:nil];
    [center addObserver:self selector:@selector(name11:) name:@"name1" object:self.view];
    [center addObserver:self selector:@selector(name12:) name:@"name1" object:self];
    [center addObserver:self selector:@selector(name20:) name:@"name2" object:nil];
    [center addObserver:self selector:@selector(name21:) name:@"name2" object:self.view];
}

- (void)name00:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)name01:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)name10:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)name11:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)name12:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)name20:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)name21:(NSNotification *)noti {
    NSLog(@"--%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[ZJNotificationCenter defaultCenter] postNotificationName:@"name1" object:self];
    
    ViewController2 *vc = [ViewController2 new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testRemoveObserver {
//    [[ZJNotificationCenter defaultCenter] removeObserver:self];
//    [[ZJNotificationCenter defaultCenter] removeObserver:self name:@"name1" object:self];
//    [[ZJNotificationCenter defaultCenter] removeObserver:self name:@"name1" object:nil];
    [[ZJNotificationCenter defaultCenter] removeObserver:self name:nil object:self.view];
    
}

- (void)postNotification {
    [[ZJNotificationCenter defaultCenter] postNotificationName:@"name1" object:nil];
}

@end
