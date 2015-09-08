//
//  JingRoundView.h
//  JingFM-RoundEffect
//
//  Created by 李一楠 on 14-7-5.
//  Copyright (c) 2014年 Liyinan. All rights reserved.
//
#import <UIKit/UIKit.h>

////////////
//delegate//
////////////
@protocol JingRoundViewDelegate <NSObject>

-(void) playStatuUpdate:(BOOL)playState;

@end


//////////////
//@interface//
//////////////
@interface JingRoundView : UIView

@property (assign, nonatomic) id<JingRoundViewDelegate> delegate;

@property (strong, nonatomic) UIImage *roundImage;
@property (assign, nonatomic) BOOL isPlay;
@property (assign, nonatomic) float rotationDuration;


-(void) play;
-(void) pause;

@end
