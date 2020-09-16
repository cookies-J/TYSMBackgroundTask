//
//  TYSMBackgroundTask.m
//  TYSMM
//
//  Created by jele lam on 16/9/2020.
//  Copyright © 2020 CookiesJ. All rights reserved.
//

#import "TYSMBackgroundTask.h"

@interface TYSMBackgroundTask () <UIApplicationDelegate>
@property (nonatomic, strong) NSMutableArray *backgroundTasks;
@property (nonatomic, copy) TYSMBackgroundTaskStartBlock startBlock;
@property (nonatomic, copy) TYSMBackgroundTaskEndBlock endBlock;
@end

@implementation TYSMBackgroundTask
- (instancetype)init {
    if (self = [super init]) {
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            self.startBlock == nil ? : self.startBlock([self.backgroundTasks.firstObject unsignedIntegerValue]);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            id obj = self.backgroundTasks.firstObject;
            [self removeBackgroundIdentifier:[obj unsignedIntegerValue]];
            [self.backgroundTasks removeObject:obj];
        }];
    }
    return self;
}

- (void)removeBackgroundIdentifier:(UIBackgroundTaskIdentifier)bgIdentifier {
    [[UIApplication sharedApplication] endBackgroundTask:bgIdentifier];
    bgIdentifier = UIBackgroundTaskInvalid;
    self.endBlock == nil ? : self.endBlock();

}

- (void)addBackgroundTask:(TYSMBackgroundTaskStartBlock)start endTask:(TYSMBackgroundTaskEndBlock)end {
    __weak typeof (self) weakself = self;
    UIBackgroundTaskIdentifier currBGTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        id obj = weakself.backgroundTasks.firstObject;
        [weakself removeBackgroundIdentifier:[obj unsignedIntegerValue]];
        [weakself.backgroundTasks removeObject:obj];
    }];

    if (currBGTaskId != UIBackgroundTaskInvalid) {
        [self.backgroundTasks addObject:@(currBGTaskId)];
        self.startBlock = start;
        self.endBlock = end;
    }
    
}

- (NSTimeInterval)backgroundTimeRemaining {
    NSTimeInterval currRemaining = [UIApplication sharedApplication].backgroundTimeRemaining;
    
    return currRemaining == DBL_MAX ? 0 : currRemaining;
    
}

@end
