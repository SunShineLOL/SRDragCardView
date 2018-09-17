//
//  SRDragCardView.h
//  MyTestDemo
//
//  Created by Honey on 2018/8/8.
//  Copyright © 2018年 Honey. All rights reserved.
//

#define CARD_NUM 4
#define MIN_INFO_NUM 5
#define CARD_SCALE 0.95

#import <UIKit/UIKit.h>
#import "SRDragCardItemView.h"

@class SRDragCardView;
@protocol SRDragCardViewDelegate <NSObject>

///itemSize
@optional
- (CGSize)cardViewItemSize:(SRDragCardView *)cardView;

///item选中回调
- (void)cardItemDidSelected:(SRDragCardView *)cardView itemView:(SRDragCardItemView *)itemView index:(NSInteger)index;
///刷新数据是否需要动画效果
- (BOOL)reloadDataNeedAnimationCardView:(SRDragCardView *)cardView;

@end

@protocol SRDragCardViewDataSource <NSObject>
@required
///配置模型时回调 在该代理中setModel
- (void)cardView:(SRDragCardView *)cardView itemView:(SRDragCardItemView *)itemView index:(NSInteger)index;
///卡片视图项目数量
- (NSInteger)numberOfItemsInCardView:(SRDragCardView *)cardView;
///return 自定义的itemView Class
- (Class)specifiedCardItemViewClass;
@end

@interface SRDragCardView : UIView
@property (weak,   nonatomic) id <SRDragCardViewDelegate> delegate;
@property (weak,   nonatomic) id <SRDragCardViewDataSource> dataSource;

///显示的cardItemView数量 默认 3+1
@property (assign, nonatomic) NSInteger cardNum;
@property (assign, nonatomic) NSInteger minInfoNum;
///卡片视图距离父视图顶部的距离 默认0;
@property (assign, nonatomic) CGFloat itemTop;
///itemSize 通过 delegate 或者属性 CARD_SIZE(320.f,410.f) 的方式 设置 卡片大小
@property (assign, nonatomic) CGSize itemSize;
///itemView圆角 默认 8
@property (assign, nonatomic) CGFloat itemCornerRadius;


///需要加载数据的回调
@property (nonatomic,copy)void (^requestSourceData)(BOOL isAnimation);

//刷新卡片
- (void)reloadData;

-(void)requestSourceData:(BOOL)needLoad;
//重置卡片
- (void)refreshAllCards;

@end
