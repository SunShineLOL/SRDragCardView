//
//  SRDragCardItemView.h
//
//  Created by Honey on 2018/8/8.
//  Copyright © 2018年 Honey. All rights reserved.
//

#define ROTATION_ANGLE M_PI/8
#define CLICK_ANIMATION_TIME 0.5
#define RESET_ANIMATION_TIME 0.3

#import <UIKit/UIKit.h>
#import "SRCardHeader.h"


@class SRDragCardItemView;
@protocol SRDragCardItemDelegate <NSObject>

-(void)cardItemDidSelected:(SRDragCardItemView *)cardView;

-(void)swipCard:(SRDragCardItemView *)cardView Direction:(BOOL) isRight;

-(void)moveCards:(CGFloat)distance;

-(void)moveBackCards;

-(void)adjustOtherCards;

-(void)leftAnimateView:(UIView *)animateView cardItemView:(SRDragCardItemView *)cardItemViews duration:(NSTimeInterval)duration finishPoint:(CGPoint)finishPoint;

-(void)rightAnimateView:(UIView *)animateView cardItemView:(SRDragCardItemView *)cardItemViews duration:(NSTimeInterval)duration finishPoint:(CGPoint)finishPoint;

@end

@interface SRDragCardItemView : UIView
//readwrite
@property (weak,   nonatomic) id <SRDragCardItemDelegate> delegate;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) CGAffineTransform originalTransform;
@property (assign, nonatomic) CGPoint originalPoint;
@property (assign, nonatomic) CGPoint originalCenter;
@property (assign, nonatomic) BOOL canPan;
@property (strong, nonatomic) NSDictionary *infoDict;
@property (assign, nonatomic) BOOL isLastPage;
///圆角 默认 8
@property (assign, nonatomic) CGFloat cornerRadius;
@end
