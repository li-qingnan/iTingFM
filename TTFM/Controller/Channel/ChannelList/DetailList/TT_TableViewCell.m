//
//  TT_TableViewCell.m
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_TableViewCell.h"

@interface TT_TableViewCell()

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *label;

@end

@implementation TT_TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    //self.backgroundColor = [UIColor clearColor];
        
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews
{
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 123, 136)];
    [self.contentView addSubview:self.image];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(165, 30, 150, 50)];
    self.label.numberOfLines = 0;
    //self.label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.label];
}

- (void)setDetail:(TT_Detail *)detail
{
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:detail.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@"lv.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cacheType = SDImageCacheTypeDisk;
        self.image.image = image;
    }];
    
    self.label.text = detail.title;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
