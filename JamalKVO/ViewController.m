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

static NSString *Notification_test = @"Notification_test";

@interface PerSon : NSObject

@property (nonatomic,strong)NSString *behaviour;

@end

@implementation PerSon

@end

@interface ViewController () <testDelegate>

@property (nonatomic,retain)Jamal_KVO *observer;
@property (nonatomic,retain)UITextField *field;
@property (nonatomic,retain)NSString *test;
@property (nonatomic,retain)RACSignal *customSingnal;
@property (nonatomic,retain)NSString *aaa;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     * @brief
     *
     * @param self 响应者
     * @param test 要监听的值
     *
     * @return racSignal
     */
    RACSignal *racSignal = RACObserve(self, test);
    /**
     * @brief  RAC 监听KVO的值的变化
     *
     * @param x     变化后的值
     * @param block 值变化后需要做的操作
     *
     * @return RACDisposable
     */
    [racSignal subscribeNext:^(id x) {
        NSLog(@"value of changed = %@",x);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"normal" forState:UIControlStateNormal];
    [button setTitle:@"selected" forState:UIControlStateSelected];
    [self.view addSubview:button];
    // 为按钮添加一个点击事件，block的参数返回一个按钮实例，block的回调为一个点击事件的响应 返回值固定为 RACSignal
    button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIButton *button = (UIButton *)input;
        button.selected = !button.selected;
        NSLog(@"button click %@",input);
        return [RACSignal empty];
    }];
    
    /**
     * @brief  注册一个通知
     *
     * @param x     通知对象
     * @param block 发送通知后的回调
     *
     * @return 无返回值
     */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:Notification_test object:self] subscribeNext:^(id x) {
        NSNotification *notification = (NSNotification *)x;
        [notification userInfo];
        @weakify(self)
        NSLog(@"zhe notification's x = %@\n%@",x,[notification object]);
    }];
    // Delegate
    PerSon *person = [[PerSon alloc] init];
    person.behaviour = @"play";
    _test = @"test";
    self.observer = [Jamal_KVO observerWithObject:person keyPath:@"behaviour" target:self selector:@selector(observerAction)];
    /**
     * @brief  代理的回调方法
     *
     * @param delegateAction: 代理方法
     * @param block:          参数为代理的参数
     *
     * @return 无返回值
     */
    [[self rac_signalForSelector:@selector(delegateAction:)] subscribeNext:^(id x) {
        NSLog(@"delegateAction方法被调用 %@", x);
    }];
    self.observer.delegate = self;
    [self performSelector:@selector(change:) withObject:person afterDelay:1];
//    ////////////////////    ////////////////////    //////////////////
//    self.aaa = @"bbb";
    // 创建自定义信号
    _customSingnal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"这是自定义的信号、、、");
//        @weakify(self)
        if (self.aaa) {
            [subscriber sendNext:self.aaa];
        }else{
            [subscriber sendError:nil];
        }
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    [_customSingnal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)change:(PerSon *)person {
//    person.behaviour = @"fighting";
//    [self.observer asfdgh];
//    self.test = @"sfgf";
    self.aaa = @"aaa";
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_test object:self];
}

- (void)observerAction{
//    NSLog(@"kvo 回调响应");
}

- (void)delegateAction:(NSString *)testValue {
//    NSLog(@"delegateAction");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
