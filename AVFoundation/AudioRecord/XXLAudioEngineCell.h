//
//  XXLAudioEngineCell.h
//  AVFoundation
//
//  Created by 谢小龙 on 16/6/22.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AudioEngineCellStyle){
    
    AudioEngineCellStyleReverb = 0,
    AudioEngineCellStyleDelay,
    
};

@protocol XXLAudioEngineCellDelegate <NSObject>

- (void)onWetDryMixValueChange:(float)value;
- (void)onFactoryPresetValueChange:(NSInteger)value;

@end

@interface XXLAudioEngineCell : UITableViewCell

@property (nonatomic, weak) id<XXLAudioEngineCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier category:(AudioEngineCellStyle)audioEngineCellStyle;

@end
