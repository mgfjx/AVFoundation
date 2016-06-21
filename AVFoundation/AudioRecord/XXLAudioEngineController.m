//
//  XXLAudioEngineController.m
//  AVFoundation
//
//  Created by 谢小龙 on 16/6/21.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import "XXLAudioEngineController.h"
#import <AVFoundation/AVFoundation.h>

@interface XXLAudioEngineController (){
    
    
    
}

@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioUnitReverb *reverb;

@end

@implementation XXLAudioEngineController

#pragma mark - 懒加载
- (AVAudioEngine *)engine{
    if (!_engine) {
        _engine = [[AVAudioEngine alloc] init];
    }
    return _engine;
}

- (AVAudioUnitReverb *)reverb{
    if (!_reverb) {
        _reverb = [[AVAudioUnitReverb alloc] init];
    }
    return _reverb;
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self addAudioFileEffect];
    
}

- (void)initViews{
    
    
    
}

- (void)addAudioFileEffect{
    
    AVAudioEngine *engine = self.engine;
    
    NSString *path = @"/Users/xiexiaolong1/Desktop/hxhx.mp3";
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:url error:nil];
    
    AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
    
    [engine attachNode:playerNode];
    
    [playerNode scheduleFile:audioFile atTime:nil completionHandler:nil];
    
    playerNode.volume = 1.0;
    
    AVAudioUnitReverb *reverb = [[AVAudioUnitReverb alloc] init];
    [reverb loadFactoryPreset:0];
    reverb.wetDryMix = 80;
    
    [engine attachNode:reverb];
    
    AVAudioUnitDelay *delay = [[AVAudioUnitDelay alloc] init];
    delay.delayTime = 0.1;
    delay.wetDryMix = 80;
    
    [engine attachNode:delay];
    
    [engine connect:playerNode to:reverb format:audioFile.processingFormat];
    [engine connect:reverb to:engine.outputNode format:audioFile.processingFormat];
    
    [engine startAndReturnError:nil];
    
    [playerNode play];
}

- (void)loadAudioUnit:(AVAudioUnit *)unit{
    
    AVAudioEngine *engine = self.engine;
    
    //音频输入口
    AVAudioInputNode *input = engine.inputNode;
    //音频输出口
    AVAudioOutputNode *output = engine.outputNode;
    
    //把混响附着到音频引擎
    [engine attachNode:unit];
    
    //使用音频引擎连接各个节点
    
    //        1.输入口连接效果器可对比咱们的图来看
    
    //        Format:格式是咱们输入口在主线的一个格式
    [engine connect:input to:unit format:[input inputFormatForBus:0]];
    
    //        2.效果器连接输出口
    [engine connect:unit to:output format:[input inputFormatForBus:0]];
    
    BOOL isSuccess = [engine startAndReturnError:nil];
    
    if (isSuccess) {
        NSLog(@"audioEngin启动成功!");
    }
    
}

@end
