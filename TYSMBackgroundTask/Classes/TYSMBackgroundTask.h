//
//  TYSMBackgroundTask.h
//  TYSMM
//
//  Created by jele lam on 16/9/2020.
//  Copyright © 2020 CookiesJ. All rights reserved.
//

/*
 * 一个用于处理后台常规任务的类
 */

#import <Foundation/Foundation.h>

typedef void(^TYSMBackgroundTaskStartBlock)(UIBackgroundTaskIdentifier identifier);
typedef void(^TYSMBackgroundTaskEndBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TYSMBackgroundTask : NSObject

/// 查询可在后台运行的剩余时间，不推荐频繁查询。
/// 先执行 - (void)addBackgroundTask:(TYSMBackgroundTaskStartBlock)start endTask:(TYSMBackgroundTaskEndBlock)end
@property (nonatomic, assign, readonly) NSTimeInterval backgroundTimeRemaining;

/// 顾名思义
/// @param start 开始背景任务
/// @param end 停止背景任务，用于前台或者时间到
- (void)addBackgroundTask:(TYSMBackgroundTaskStartBlock)start
                  endTask:(TYSMBackgroundTaskEndBlock)end;
@end

NS_ASSUME_NONNULL_END
