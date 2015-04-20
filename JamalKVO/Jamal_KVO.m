//
//  Jamal_KVO.m
//  JamalKVO
//
//  Created by jamalping on 15/4/20.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import "Jamal_KVO.h"

@interface Jamal_KVO ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, strong) id observedObject;
@property (nonatomic, copy) NSString* keyPath;

@end

@implementation Jamal_KVO

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString*)keyPath
                            target:(id)target
                          selector:(SEL)selector {
    return [[Jamal_KVO alloc] initWithObject:object keyPath:keyPath target:target selector:selector];
}

- (id)initWithObject:(id)object
             keyPath:(NSString*)keyPath
              target:(id)target
            selector:(SEL)selector {
    self = [super init];
    if (self) {
        self.observedObject = object;
        self.keyPath = keyPath;
        self.target = target;
        self.selector = selector;
        [object addObserver:self forKeyPath:keyPath options:0 context:(__bridge void *)(self)];
    }
    return self; 
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    if (context == CFBridgingRetain(self)) {
        id strongTarget = self.target;
        if ([strongTarget respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:self.selector];
#pragma clang diagnostic pop
        } 
    } 
}

- (void)dealloc
{
    id strongObservedObject = self.observedObject;
    if (strongObservedObject) {
        [strongObservedObject removeObserver:self forKeyPath:self.keyPath];
    }
}

@end
