//
//  TT_ChannelCell.m
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_ChannelCell.h"

@interface TT_ChannelCell()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *label;


@end

@implementation TT_ChannelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
    [self.contentView addSubview:self.imageView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 90, 20)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.label.font = [UIFont systemFontOfSize:17.0];
    self.label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.label];
}

- (void)setChannel:(TT_Channel *)channel
{
    //NSURL *url = [NSURL URLWithString:channel.coverPath];
    //[self.imageView setImageWithURL:url placeholderImage:nil];
    
    [self.imageView setImage:[UIImage imageNamed:channel.coverPath]];
    self.label.text = channel.title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
