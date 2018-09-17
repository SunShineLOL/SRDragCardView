//
//  MYCardItemView.m
//  SRDragCardView
//
//  Created by Honey on 2018/9/14.
//  Copyright © 2018年 CZN. All rights reserved.
//

#import "MYCardItemView.h"

@interface MYCardItemView()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *image;
@end

@implementation MYCardItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
#pragma mark ->bindViewModel
- (void)bindViewModel:(id)value{
    self.titleLabel.text = [NSString stringWithFormat:@"当前页数:%@",value];
    self.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",value]];
}
#pragma mark ->createView
- (void)createView{
    [self addSubview:self.image];
    [self addSubview:self.titleLabel];
    //AutoLayout
    //...
    self.titleLabel.frame = CGRectMake(10.f, self.frame.size.height - 20.f, 160.f, 20.f);
    self.image.frame = self.bounds;
    self.titleLabel.center = self.image.center;
}
#pragma mark ->懒加载
- (UILabel *)titleLabel{
    if (nil == _titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.layer.cornerRadius = 4.f;
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor grayColor];
    }
    return _titleLabel;
}
- (UIImageView *)image{
    if (nil == _image) {
        _image = [UIImageView new];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.layer.cornerRadius = self.cornerRadius;
        _image.layer.masksToBounds = YES;
    }
    return _image;
}
@end
