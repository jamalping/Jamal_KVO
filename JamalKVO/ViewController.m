//
//  ViewController.m
//  JamalKVO
//
//  Created by jamalping on 15/4/20.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import "ViewController.h"
#import "Jamal_KVO.h"
#import <ReactiveCocoa.h>

@interface PerSon : NSObject

@property (nonatomic,strong)NSString *behaviour;

@end

@implementation PerSon

@end

@interface ViewController ()

@property (nonatomic,retain)Jamal_KVO *observer;
@property (nonatomic,retain)UITextField *field;
@property (nonatomic,retain)NSString *test;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.field.rac_textSignal subscribeCompleted:<#^(void)completedBlock#>]
    [RACObserve(self, test) subscribeNext:^(NSString* x){
//        request(x);//发送一个请求
        NSLog(@"qqqqqqqqqqqqqqqqqqq%@",x);
    }];
    PerSon *person = [[PerSon alloc] init];
    person.behaviour = @"play";
    _test = @"test";
    self.observer = [Jamal_KVO observerWithObject:person keyPath:@"behaviour" target:self selector:@selector(observerAction)];
    [self performSelector:@selector(change:) withObject:person afterDelay:3];
}

- (void)change:(PerSon *)person {
//    NSLog(@"person.behaviour--%@",person.behaviour);
    person.behaviour = @"fighting";
    self.test = @"sfgf";
//    NSLog(@"person.behaviour--%@",person.behaviour);
}

- (void)observerAction{
//    NSLog(@"kvo 回调响应");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
