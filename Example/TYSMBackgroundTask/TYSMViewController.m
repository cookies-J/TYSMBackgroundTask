//
//  TYSMViewController.m
//  TYSMBackgroundTask
//
//  Created by cooljele@gmail.com on 09/16/2020.
//  Copyright (c) 2020 cooljele@gmail.com. All rights reserved.
//

#import "TYSMViewController.h"
#import <TYSMBackgroundTask/TYSMBackgroundTask.h>

@interface TYSMViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) TYSMBackgroundTask *bgTask;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TYSMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bgTask = [[TYSMBackgroundTask alloc] init];
    __weak typeof(self) weakself = self;

    [self.bgTask addBackgroundTask:^(UIBackgroundTaskIdentifier identifier) {
        weakself.timer = [weakself createTimer:^(NSTimer *timer) {
            NSString *time = [NSString stringWithFormat:@"%.2lf", weakself.bgTask.backgroundTimeRemaining];
            NSLog(@"%@",time);
            weakself.timeLabel.text = time;
        }];
        [[NSRunLoop currentRunLoop] addTimer:weakself.timer forMode:NSRunLoopCommonModes];
    } endTask:^{
        NSLog(@"结束了");
        [weakself.timer invalidate];
        weakself.timer = nil;
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSTimer *)createTimer:(void (^)(NSTimer *timer))Block {
    return [NSTimer timerWithTimeInterval:0.01 repeats:YES block:Block];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
