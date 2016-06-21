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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setAudioEffect];
    
}

- (void)setAudioEffect{
    
    AVAudioUnitReverb *reverb = self.reverb;
    
    //设置混响效果器为教堂的效果
    [reverb loadFactoryPreset:AVAudioUnitReverbPresetCathedral];
    
    //设置混响的干湿比是从0-100的值干湿比影响到咱们混响与原声的一个混合比例
    reverb.wetDryMix = 100;
    
    
    AVAudioUnitDelay *delay = [[AVAudioUnitDelay alloc] init];
    delay.delayTime = 0.5;
    delay.wetDryMix = 10;
    
    
    AudioComponentDescription acd;
    //componentType类型是相对应的，什么样的功能设置什么样的类型，componentSubType是根据componentType设置的。
    acd.componentType = kAudioUnitType_FormatConverter;
    acd.componentSubType = kAudioUnitSubType_Delay;
    //如果没有一个明确指定的值，那么它必须被设置为0
    acd.componentFlags = 0;
    //如果没有一个明确指定的值，那么它必须被设置为0
    acd.componentFlagsMask = 0;
    //厂商的身份验证
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
     /*
    AVAudioUnitGenerator *generator = [[AVAudioUnitGenerator alloc] initWithAudioComponentDescription:acd];
    generator.bypass = YES;
    */
    
//    AVAudioUnitTimeEffect *timeEffect = [[AVAudioUnitTimeEffect alloc] initWithAudioComponentDescription:acd];
    
     
    [self loadAudioUnit:reverb];
    
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
