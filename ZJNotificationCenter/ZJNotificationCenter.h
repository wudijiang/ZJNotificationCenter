//
//  ZJNotificationCenter.h
//  ZJNotificationCenter
//
//  Created by YZJ on 2020/4/10.
//  Copyright © 2020 YZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *ZJNotificationName NS_EXTENSIBLE_STRING_ENUM;

NS_ASSUME_NONNULL_BEGIN

@interface ZJNotificationCenter : NSObject

@property (class, readonly, strong) ZJNotificationCenter *defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable ZJNotificationName)aName object:(nullable id)anObject;

//- (void)postNotification:(ZJNotification *)notification;
- (void)postNotificationName:(ZJNotificationName)aName object:(nullable id)anObject;
- (void)postNotificationName:(ZJNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(nullable ZJNotificationName)aName object:(nullable id)anObject;

@end

NS_ASSUME_NONNULL_END

