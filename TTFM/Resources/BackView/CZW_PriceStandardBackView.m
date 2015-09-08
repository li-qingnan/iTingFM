//
//  CZW_PriceStandardBackView.m
//  CZW_Product
//
//  Created by ochenkai on 14-10-26.
//  Copyright (c) 2014年 张强. All rights reserved.
//

#import "CZW_PriceStandardBackView.h"


@implementation CZW_PriceStandardBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backImageView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
        _backImageView.layer.shadowOffset = CGSizeMake(1, 3);
        _backImageView.layer.shadowOpacity = 4;
        _backImageView.layer.shadowRadius =3;
        _backImageView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        _backImageView.layer.borderWidth = 0.3;
        _backImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backImageView];
    }
    return self;
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
