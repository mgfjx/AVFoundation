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
    
    UIButton *playBtn;
    UISlider *wetSlider;
    
    UILabel *wetDryValueLabel;
}

@property (nonatomic, strong) AVAudioEngine *engine;

@property (nonatomic, strong) AVAudioUnitReverb *reverb;
@property (nonatomic, strong) AVAudioUnitDelay *delay;
@property (nonatomic, strong) AVAudioPlayerNode *player;

@property (nonatomic, strong) AVAudioFile *audioFile;

@end

@implementation XXLAudioEngineController

#pragma mark - 懒加载
- (AVAudioEngine *)engine{
    if (!_engine) {
        _engine = [[AVAudioEngine alloc] init];
    }
    return _engine;
}

- (AVAudioPlayerNode *)player{
    if (!_player) {
        _player = [[AVAudioPlayerNode alloc] init];
        [self.engine attachNode:_player];
    }
    return _player;
}

- (AVAudioUnitReverb *)reverb{
    if (!_reverb) {
        _reverb = [[AVAudioUnitReverb alloc] init];
        [self.engine attachNode:_reverb];
    }
    return _reverb;
}

- (AVAudioFile *)audioFile{
    if (!_audioFile) {
        
        NSString *path = @"/Users/xiexiaolong1/Desktop/hxhx.mp3";
        NSURL *url = [NSURL fileURLWithPath:path];
        
        _audioFile = [[AVAudioFile alloc] initForReading:url error:nil];
        
        //ser player
        [self.player scheduleFile:_audioFile atTime:nil completionHandler:nil];
        self.player.volume = 1.0;
    }
    return _audioFile;
}

- (AVAudioUnitDelay *)delay{
    if (!_delay) {
        _delay = [[AVAudioUnitDelay alloc] init];
        [self.engine attachNode:_delay];
    }
    return _delay;
}

#pragma mark - overwrite
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareAudioEffect];
    [self initViews];
    
}

#pragma mark - initViews
- (void)initViews{
    
    //播放暂停按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(playAndPause:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButton;
    
    playBtn = btn;
    
    //wetDryMix label
    UILabel *wetLabel = [[UILabel alloc] init];
    wetLabel.frame = CGRectMake(8, CGRectGetMaxY(btn.frame) + 20, 70, 40);
    wetLabel.text = @"wetDryMix:";
    wetLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:wetLabel];
    
    //wetDryMix slider
    UISlider *slider = [[UISlider alloc] init];
    slider.frame = CGRectMake(CGRectGetMaxX(wetLabel.frame) + 8, CGRectGetMinY(wetLabel.frame), self.view.bounds.size.width - (CGRectGetMaxX(wetLabel.frame) + 8)*2, CGRectGetHeight(wetLabel.frame));
    UIImage *image = [UIImage imageNamed:@"sliderBtn"];
    [slider setThumbImage:image forState:UIControlStateNormal];
    slider.minimumValue = 1;
    slider.maximumValue = 100;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    wetSlider = slider;
    
    //wetDryMix valueLabel
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.frame = CGRectMake(CGRectGetMaxX(slider.frame) + 8, CGRectGetMinY(slider.frame), 60, 40);
    valueLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:valueLabel];
    
    wetDryValueLabel = valueLabel;
    
}

- (void)prepareAudioEffect{
    
    AVAudioEngine *engine     = self.engine;
    AVAudioPlayerNode *player = self.player;
    AVAudioUnitReverb *reverb = self.reverb;
    AVAudioFile *audioFile    = self.audioFile;
    AVAudioUnitDelay *delay   = self.delay;
    
    //set reverb unit
//    [reverb loadFactoryPreset:1];
    reverb.wetDryMix = wetSlider.value;
    
    //set delay unit
    delay.delayTime = 0.1;
    delay.wetDryMix = 100;
    
    [engine connect:player to:reverb format:audioFile.processingFormat];
    [engine connect:reverb to:engine.outputNode format:audioFile.processingFormat];
    
    BOOL isSuccess = [engine startAndReturnError:nil];
    
    if (isSuccess) {
        NSLog(@"audioEngin启动成功!");
    }
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

#pragma mark - playAndPause 播放和暂停音乐
- (void)playAndPause:(UIButton *)sender{
    
    if (!sender.selected) {
        [self.player play];
    }else{
        [self.player pause];
    }
    sender.selected = !sender.selected;
    
    
}

#pragma mark - sliderValueChanged 
- (void)sliderValueChanged:(UISlider *)slider{
    
    wetDryValueLabel.text = [NSString stringWithFormat:@"%.f",slider.value];
    
    [self prepareAudioEffect];
    
}

@end


















