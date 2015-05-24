//
//  FeildViewController.m
//  JamalKVO
//
//  Created by jamalping on 15/5/23.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import "FeildViewController.h"
#import <ReactiveCocoa.h>

@interface FeildViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telTextFeil;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFeild;

@end

@implementation FeildViewController


- (void)dealloc
{
    NSLog(@"dead");
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DisMiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    @weakify(self);
    
    [self.telTextFeil.rac_textSignal subscribeNext:^(NSString *text) {
//        if (!isNumber(text)) {
//            self_weak_.telTextFeil.text = [text substringToIndex:text.length-1];
//            return ;
//        }
        if (text.length>11) {
            self_weak_.telTextFeil.text = [text substringToIndex:11];
        }else{
            self_weak_.telTextFeil.text = text;
        }
        NSLog(@"%@--%@",self_weak_.telTextFeil.text,text);
    }];
    
    RAC(self.telTextFeil,text) = [self.telTextFeil.rac_textSignal map:^id(NSString *text) {
        return isNumber(text)?text:[text substringToIndex:text.length-1];
    }];
    
    [[self.telTextFeil.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length<=11;
    }] subscribeNext:^(NSString *x) {
        self_weak_.telTextFeil.text = x;
        NSLog(@"%@///%@,%@",self_weak_.telTextFeil.text,x,[x class]);
    }];
    
//    [self.pwdTextFeild.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//        self_weak_.pwdTextFeild.text = x;
//    }];
//    
//    [[[self.telTextFeil.rac_textSignal map:^id(NSString* value) {
//        return @([NSString stringWithFormat:@"%@",value].length);
//    }] filter:^BOOL(NSNumber *length) {
//        return ([length integerValue]<11);
//    }]subscribeNext:^(id x) {
//        NSLog(@"长度是%@",x);
//    }];
    
//    [[self.telTextFeil rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
//        self_weak_.telTextFeil.text = @"aa";
//    }];
    
//    创建有效信号
//    RACSignal *telValue = [self.telTextFeil.rac_textSignal map:^id(NSString *value) {
//        return @(isPhoneNumber(value));
//    }];
//    
//    RACSignal *pwdValue = [self.pwdTextFeild.rac_textSignal map:^id(NSString *value) {
//        return @([value isEqualToString:@"pwd"]);
//    }];
//    // 转换信号
//    [[telValue map:^id(NSNumber *vailAbleValue) {
//        return [vailAbleValue boolValue]?[UIColor blackColor]:[UIColor redColor];
//    }] subscribeNext:^(UIColor *color) {
//        self_weak_.telTextFeil.textColor = color;
//    }];
//    RAC(self.telTextFeil,textColor) = [telValue map:^id(NSNumber *value) {
//        return [value boolValue]?[UIColor blackColor]:[UIColor cyanColor];
//    }];
//    
//    RACSignal *aaaaaa = [RACSignal combineLatest:@[telValue,pwdValue] reduce:^id(NSNumber *vailableTel,NSNumber *vailablePwd){
//        return @([vailablePwd boolValue]&& [vailableTel boolValue]);
//    }];
//    [aaaaaa subscribeNext:^(NSNumber *x) {
//        self.view.backgroundColor = [x boolValue]?[UIColor greenColor]:[UIColor purpleColor];
//    }];
}


BOOL isNumber(NSString *number) {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


BOOL isPhoneNumber(NSString *number){
    if (number.length!=11 || ![number hasPrefix:@"1"])
        return NO;
    
    NSCharacterSet *cs=[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if([number rangeOfCharacterFromSet:cs].location == NSNotFound)
        return YES;
    
    return NO;
}

@end
