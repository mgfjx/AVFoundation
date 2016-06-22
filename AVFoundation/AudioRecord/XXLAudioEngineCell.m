//
//  XXLAudioEngineCell.m
//  AVFoundation
//
//  Created by 谢小龙 on 16/6/22.
//  Copyright © 2016年 xiexiaolong. All rights reserved.
//

#import "XXLAudioEngineCell.h"

#define Label_Font [UIFont systemFontOfSize:13]

@interface XXLAudioEngineCell (){
    
    UISlider *wetSlider;
    
    UILabel *wetDryMixLabel;
    UILabel *wetDryValueLabel;
    UIStepper *factorySteper;
    
    AudioEngineCellStyle category;
    NSArray *factoryPresetArr;
}

@end

@implementation XXLAudioEngineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier category:(AudioEngineCellStyle)audioEngineCellStyle{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        category = audioEngineCellStyle;
        switch (audioEngineCellStyle) {
                case AudioEngineCellStyleReverb: {
                    [self initReverb];
                    break;
                }
                case AudioEngineCellStyleDelay: {
                    [self initDelay];
                    break;
                }
        }
        
    }
    return self;
}

- (void)initReverb{
    
    //wetDryMix label
    UILabel *wetLabel = [[UILabel alloc] init];
    wetLabel.text = @"wetDryMix:";
    wetLabel.font = Label_Font;
    [self addSubview:wetLabel];
    
    wetDryMixLabel = wetLabel;
    
    
    //wetDryMix slider
    UISlider *slider = [[UISlider alloc] init];
    UIImage *image = [UIImage imageNamed:@"sliderBtn"];
    [slider setThumbImage:image forState:UIControlStateNormal];
    slider.minimumValue = 1;
    slider.maximumValue = 100;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    
    wetSlider = slider;
    
    //wetDryMix valueLabel
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"1";
    valueLabel.font = Label_Font;
    [self addSubview:valueLabel];
    
    wetDryValueLabel = valueLabel;
    
    //factoryPreset
    factoryPresetArr = @[@"小房间",@"中等房间",@"大房间",@"中等大厦",@"大型大厦",@"光面墙壁",@"中等会议室",@"大型会议室",@"教堂",@"大房间2",@"中等大厦2",@"中等大厦2",@"大型大厦2"];
    
    UIStepper *steper = [[UIStepper alloc] init];
    steper.minimumValue = 0;
    steper.stepValue = 1;
    steper.maximumValue = 12;
    [steper addTarget:self action:@selector(setFactoryPreset:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:steper];
    
    
    factorySteper = steper;
    
}

- (void)initDelay{
    
    //wetDryMix label
    UILabel *wetLabel = [[UILabel alloc] init];
    wetLabel.text = @"wetDryMix:";
    wetLabel.font = Label_Font;
    [self addSubview:wetLabel];
    
    wetDryMixLabel = wetLabel;
    
    
    //wetDryMix slider
    UISlider *slider = [[UISlider alloc] init];
    UIImage *image = [UIImage imageNamed:@"sliderBtn"];
    [slider setThumbImage:image forState:UIControlStateNormal];
    slider.minimumValue = 1;
    slider.maximumValue = 100;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    
    wetSlider = slider;
    
    //wetDryMix valueLabel
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"1";
    valueLabel.font = Label_Font;
    [self addSubview:valueLabel];
    
    wetDryValueLabel = valueLabel;
    
    //factoryPreset
    factoryPresetArr = @[@"小房间",@"中等房间",@"大房间",@"中等大厦",@"大型大厦",@"光面墙壁",@"中等会议室",@"大型会议室",@"教堂",@"大房间2",@"中等大厦2",@"中等大厦2",@"大型大厦2"];
    
    
}

#pragma mark - sliderValueChanged
- (void)sliderValueChanged:(UISlider *)slider{
    
    wetDryValueLabel.text = [NSString stringWithFormat:@"%.f",slider.value];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onWetDryMixValueChange:)]) {
        [self.delegate onWetDryMixValueChange:slider.value];
    }
    
}

#pragma mark - layout subviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (category) {
            case AudioEngineCellStyleReverb: {
                [self layoutReverbCategory];
                break;
            }
            case AudioEngineCellStyleDelay: {
                [self layoutDelayCategory];
                break;
            }
    }
    
}

- (void)layoutReverbCategory{
    
    wetDryMixLabel.frame = CGRectMake(8, 8, 70, 40);
    wetSlider.frame = CGRectMake(CGRectGetMaxX(wetDryMixLabel.frame) + 8, CGRectGetMinY(wetDryMixLabel.frame), self.bounds.size.width - CGRectGetMaxX(wetDryMixLabel.frame) - 8 - 25, CGRectGetHeight(wetDryMixLabel.frame));
    wetDryValueLabel.frame = CGRectMake(CGRectGetMaxX(wetSlider.frame) + 8, CGRectGetMinY(wetSlider.frame), 25, 40);
    factorySteper.frame = CGRectMake(CGRectGetMinX(wetDryMixLabel.frame), CGRectGetMaxY(wetDryValueLabel.frame), 40, 40);
}

- (void)layoutDelayCategory{
    
    
    
}

#pragma mark - setFactoryPreset
- (void)setFactoryPreset:(UIStepper *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onFactoryPresetValueChange:)]) {
        [self.delegate onFactoryPresetValueChange:(NSInteger)sender.value];
    }
    
}




@end
