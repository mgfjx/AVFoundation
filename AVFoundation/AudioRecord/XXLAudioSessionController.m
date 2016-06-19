//
//  XXLAudioSessionController.m
//  AVFoundation
//
//  Created by xiexiaolong on 16/6/19.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import "XXLAudioSessionController.h"
#import <AVFoundation/AVFoundation.h>

@interface XXLAudioSessionController (){
    AVAudioSession *audioSession;
    AVAudioRecorder *audioRecorder;
}

@end

@implementation XXLAudioSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"setCategoryError:%@",error.userInfo);
    }
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"setActive:%@",error.userInfo);
    }
    
    [self prepareRecord];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"record" forState:UIControlStateNormal];
    [btn setTitle:@"stop" forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)btnClicked:(UIButton *)sender{
    
    if (audioRecorder.recording) {
        sender.selected = NO;
        
        [audioRecorder stop];
    }else{
        sender.selected = YES;
        [audioRecorder record];
    }
    
}

- (NSString *)saveAudioPath{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSDate *date = [NSDate date];
    
    NSString *audioName = [NSString stringWithFormat:@"%f.caf", date.timeIntervalSince1970];
    
    
    return [path stringByAppendingPathComponent:audioName];
}

- (void)prepareRecord{
    
    NSString *audioPath = [self saveAudioPath];
    
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    
    NSDictionary *recordSetting = @{
                                    AVSampleRateKey:@44100,
                                    AVEncoderAudioQualityKey:@(AVAudioQualityHigh)};
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:recordSetting error:&error];
    
    if (error) {
        NSLog(@"settings:%@",error.userInfo);
        return;
    }
    
    [audioRecorder prepareToRecord];
}

@end
