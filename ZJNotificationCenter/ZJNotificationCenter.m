//
//  ZJNotificationCenter.m
//  test-notification
//
//  Created by zhanjiang on 2020/4/10.
//  Copyright © 2020 zhanjiang. All rights reserved.
//

#import "ZJNotificationCenter.h"

/****************    Notifications    ****************/

@interface ZJObserverModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id object;
@property (nonatomic, assign) SEL selector;
@end

@implementation ZJObserverModel
- (NSString *)description {
    return [NSString stringWithFormat:@"name:%@ object:%p selector:%@", self.name, self.object, NSStringFromSelector(self.selector)];
}
@end

/****************    Notification Center    ****************/

@interface ZJNotificationCenter ()
@property (nonatomic, strong) NSMutableDictionary *observersDictionary;
@property (nonatomic, strong) NSMutableDictionary *nameTable;
@property (nonatomic, strong) NSHashTable *nilNameTable;
@end

@implementation ZJNotificationCenter

+ (ZJNotificationCenter *)defaultCenter {
    static id defaultCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCenter = [[self alloc] init];
    });
    return defaultCenter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _observersDictionary = [NSMutableDictionary dictionary];
        _nameTable = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - addObserver

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(ZJNotificationName)aName object:(id)anObject {
    if (!observer || !aSelector || (aName && ![aName isKindOfClass:[NSString class]])) {
        NSLog(@"----addObserver参数不合法");
        return;
    }
    
    if (!aName) {
        if (!self.nilNameTable) {
            self.nilNameTable = [NSHashTable weakObjectsHashTable];
        }
        [self.nilNameTable addObject:observer];
        NSLog(@"----addObserver监听通知名称为空nilNameTable:%@", self.nilNameTable);
    } else {
        NSHashTable *observers = [self.nameTable objectForKey:aName];
        if (!observers) {
            observers = [NSHashTable weakObjectsHashTable];
        }
        [observers addObject:observer];
        // 通知名到观察者的映射关系
        [self.nameTable setObject:observers forKey:aName];
        NSLog(@"----addObserver nameTable:%@", self.nameTable);
    }
    
    NSString *observerKey = [self keyWithObserver:observer];
    NSMutableArray *models = [self.observersDictionary objectForKey:observerKey];
    if (!models) {
        models = [NSMutableArray array];
    }
    ZJObserverModel *model = [ZJObserverModel new];
    model.selector = aSelector;
    model.name = aName;
    model.object = anObject;
    [models addObject:model];
    // 观察者到model的映射关系
    [self.observersDictionary setObject:models forKey:observerKey];
    NSLog(@"----addObserver observersDictionary:%@", self.observersDictionary);
}

#pragma mark - postNotificationName

- (void)postNotificationName:(ZJNotificationName)aName object:(nullable id)anObject {
    [self postNotificationName:aName object:anObject userInfo:nil];
}

- (void)postNotificationName:(ZJNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo {
    if (!aName && [aName isKindOfClass:[NSString class]]) {
        NSLog(@"----postNotificationName名称无效");
        return;
    }
    
    // 合并观察者数组
    NSHashTable *observers = [self.nilNameTable mutableCopy];
    [observers unionHashTable:[self.nameTable objectForKey:aName]];
    if (!observers.count) {
        // 通知中心未注册
        NSLog(@"----postNotificationName通知中心未注册");
        return;
    }
    
    NSLog(@"----postNotificationName 即将发送通知 observers:%@", observers);
    for (id observer in observers) {
        NSArray *models = [self.observersDictionary objectForKey:[self keyWithObserver:observer]];
        for (ZJObserverModel *model in models) {
            // 监听中如果name为nil，则不以name作为筛选；监听中如果object为nil，则不以object作为筛选
            BOOL canPerform = [self canPassWithObj1:model.name obj2:aName] && [self canPassWithObj1:model.object obj2:anObject];
            if (canPerform) {
                [observer performSelector:model.selector withObject:aUserInfo];
                NSLog(@"----postNotificationName发送通知observer:%@ model:%@", observer, model);
            }
        }
    }
}

#pragma mark - removeObserver

- (void)removeObserver:(id)observer {
    [self removeObserver:observer name:nil object:nil];
}

- (void)removeObserver:(id)observer name:(ZJNotificationName)aName object:(id)anObject {
    if (!observer) {
        NSLog(@"----removeObserver移除观察者为空");
        return;
    }
    
    NSLog(@"----removeObserver即将移除观察者observer:%@ 集合:%@", observer, self.observersDictionary);
    NSString *observerKey = [self keyWithObserver:observer];
    if (!aName && !anObject) {
        [self.observersDictionary removeObjectForKey:observerKey];
        NSLog(@"----removeObserver完成,name,object为空 集合:%@", self.observersDictionary);
        return;
    }
    
    NSMutableArray *models = [self.observersDictionary objectForKey:observerKey];
    for (ZJObserverModel *model in models.copy) {
        BOOL canRemove = [self canPassWithObj1:aName obj2:model.name] && [self canPassWithObj1:anObject obj2:model.object];
        if (canRemove) {
            [models removeObject:model];
            NSLog(@"----removeObserver,name:%@ aName:%@, object:%@ anObject:%@", model.name, aName, model.object, anObject);
        }
    }
    NSLog(@"----removeObserver完成 集合:%@", self.observersDictionary);
}

/** 如果obj1为空，或者两者相等则表示能通过筛序 */
- (BOOL)canPassWithObj1:(id)obj1 obj2:(id)obj2 {
    if (!obj1) {
        return YES;
    }
    return [obj1 isEqual:obj2];
}

- (NSString *)keyWithObserver:(id)observer {
    return [NSString stringWithFormat:@"%@", observer];
}

@end
