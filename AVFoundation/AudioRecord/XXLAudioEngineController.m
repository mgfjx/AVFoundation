//
//  XXLAudioEngineController.m
//  AVFoundation
//
//  Created by 谢小龙 on 16/6/21.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import "XXLAudioEngineController.h"
#import <AVFoundation/AVFoundation.h>
#import "XXLAudioEngineCell.h"

@interface XXLAudioEngineController ()<UITableViewDelegate,UITableViewDataSource,XXLAudioEngineCellDelegate>{
    
    CGFloat wetDryMixValue;
    NSInteger factoryPresetValue;
    CGFloat delayTimeValue;
    
    UIButton *playBtn;
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
    
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    
     
}

#pragma mark - 准备音效
- (void)prepareAudioEffect{
    
    AVAudioEngine *engine     = self.engine;
    AVAudioPlayerNode *player = self.player;
    AVAudioUnitReverb *reverb = self.reverb;
    AVAudioFile *audioFile    = self.audioFile;
    AVAudioUnitDelay *delay   = self.delay;
    
    //set reverb unit
    [reverb loadFactoryPreset:factoryPresetValue];
    reverb.wetDryMix = wetDryMixValue;
    
    //set delay unit
    delay.delayTime = delayTimeValue;
    delay.wetDryMix = 50;
    
    [engine connect:player to:reverb format:audioFile.processingFormat];
    [engine connect:reverb to:delay format:audioFile.processingFormat];
    [engine connect:delay to:engine.outputNode format:audioFile.processingFormat];
    
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

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXLAudioEngineCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [[XXLAudioEngineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier category:AudioEngineCellStyleReverb];
    }
    
    if (indexPath.row == 1) {
        cell = [[XXLAudioEngineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier category:AudioEngineCellStyleDelay];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}

#pragma mark - XXLAudioEngineCellDelegate
- (void)onWetDryMixValueChange:(float)value{
    
    wetDryMixValue = value;
    [self prepareAudioEffect];
    
}

- (void)onFactoryPresetValueChange:(NSInteger)value{
    
    factoryPresetValue = value;
    [self prepareAudioEffect];
    
}

- (void)onDelayTimeValueChange:(float)value{
    
    delayTimeValue = value;
    [self prepareAudioEffect];
    
}

@end


















