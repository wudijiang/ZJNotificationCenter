//
//  ViewController2.m
//  ZJNotificationCenter
//
//  Created by YZJ on 2020/4/11.
//  Copyright © 2020 YZJ. All rights reserved.
//

#import "ViewController2.h"
#import "ZJNotificationCenter.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"发通知2" forState:UIControlStateNormal];
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
    [[ZJNotificationCenter defaultCenter] postNotificationName:@"name1" object:nil];
}

- (void)dealloc {
    [[ZJNotificationCenter defaultCenter] removeObserver:self];
}


- (void)postNotification {
    [[ZJNotificationCenter defaultCenter] postNotificationName:@"name2" object:nil];
}

@end
