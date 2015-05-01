//
//  Jamal_KVO.h
//  JamalKVO
//
//  Created by jamalping on 15/4/20.
//  Copyright (c) 2015年 李小平. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^testBlock)(id newValue);

@protocol testDelegate <NSObject>

- (void)delegateAction:(NSString *)testValue;

@end

/**
 * @brief  KVO的封装，解决了如下问题
 1. 在observeValueForKeyPath:ofObject:change:context:方法里通过keyPath值来做调度，当Observe比较多的对象时，会使得代码变得杂乱和迷惑。
 2. 必须手动的来注册和删除一个观察者，如果能自动做就好了。
 */
@interface Jamal_KVO : NSObject


@property (nonatomic,assign)id <testDelegate>delegate;
- (void)asfdgh;
/**
 * @brief  生成一个观察者
 *
 * @param object   被观察者
 * @param keyPath  被观察的值
 * @param target   观察者
 * @param selector 观察者响应的回调方法
 *
 * @return self
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString*)keyPath
                            target:(id)target
                          selector:(SEL)selector;

@end
