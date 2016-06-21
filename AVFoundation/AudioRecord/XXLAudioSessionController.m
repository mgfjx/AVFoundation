//
//  XXLAudioSessionController.m
//  AVFoundation
//
//  Created by xiexiaolong on 16/6/19.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import "XXLAudioSessionController.h"
#import <AVFoundation/AVFoundation.h>
#import "XXLAudioListController.h"
#import "XXLAudioEngineController.h"

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
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"record" forState:UIControlStateNormal];
    [btn setTitle:@"stop" forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(loadAudioList:)];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self createAudioEffectBtn];
}

- (void)btnClicked:(UIButton *)sender{
    
    if (audioRecorder.recording) {
        sender.selected = NO;
        
        [audioRecorder stop];
    }else{
        sender.selected = YES;
        [self prepareRecord];
        [audioRecorder record];
    }
    
}

#pragma mark - 音效
- (void)createAudioEffectBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 74, 100, 40);
    [btn setTitle:@"AudioEffect" forState:UIControlStateNormal];
    [btn setTitle:@"AudioEffect" forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(audioEffect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)audioEffect:(UIButton *)sender{
    
    XXLAudioEngineController *vc = [[XXLAudioEngineController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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


- (void)loadAudioList:(UIBarButtonItem *)item{
    
    XXLAudioListController *vc = [[XXLAudioListController alloc] init];
    [self.navigationController pushViewController:vc  animated:YES];
    
}

@end
