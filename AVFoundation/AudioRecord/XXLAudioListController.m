//
//  XXLAudioListController.m
//  AVFoundation
//
//  Created by 谢小龙 on 16/6/20.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import "XXLAudioListController.h"
#import <AVFoundation/AVFoundation.h>

@interface XXLAudioListController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>{
    
    NSArray *audiosArr;
    AVAudioPlayer *audioPlayer;
    
}

@end

@implementation XXLAudioListController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    audiosArr = [self loadAudios];
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return audiosArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = audiosArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *audioPath = audiosArr[indexPath.row];
    NSURL *audioURL = [[NSURL alloc] initWithString:[path stringByAppendingPathComponent:audioPath]];
    
    [self initAudioPlayerToPlay:audioURL];
    
}

- (NSArray *)loadAudios{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *allFiles = [manager subpathsAtPath:path];
    
    NSMutableArray *audios = [NSMutableArray array];
    
    for (NSString *item in allFiles) {
        if ([item.pathExtension isEqualToString:@"caf"]) {
            [audios addObject:item];
        }
    }
    
    return [audios copy];
}

- (void)initAudioPlayerToPlay:(NSURL *)url{
    
    if (audioPlayer != nil) {
        audioPlayer = nil;
        audioPlayer.delegate = nil;
    }
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    NSLog(@"音频播放结束");
    
}


@end









