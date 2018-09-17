//
//  SRCardHeader.h
//  MyTestDemo
//
//  Created by Honey on 2018/8/8.
//  Copyright © 2018年 Honey. All rights reserved.
//

#ifndef SRCardHeader_h
#define SRCardHeader_h

#define iPhone5AndEarlyDevice (([[UIScreen mainScreen] bounds].size.height*[[UIScreen mainScreen] bounds].size.width <= 320*568)?YES:NO)
#define Iphone6 (([[UIScreen mainScreen] bounds].size.height*[[UIScreen mainScreen] bounds].size.width <= 375*667)?YES:NO)

static inline float lengthFit(float iphone6PlusLength)
{
    if (iPhone5AndEarlyDevice) {
        return iphone6PlusLength *320.0f/414.0f;
    }
    if (Iphone6) {
        return iphone6PlusLength *375.0f/414.0f;
    }
    return iphone6PlusLength;
}

#define PAN_DISTANCE 120
//#define CARD_WIDTH [[UIScreen mainScreen] bounds].size.width - 60 //lengthFit(315)
//#define CARD_HEIGHT ([[UIScreen mainScreen] bounds].size.width - 60) * 492.f / 315.f //lengthFit(465)
#define CARD_SIZE(w,h) CGSizeMake([[UIScreen mainScreen] bounds].size.width / 375.0f * w, [[UIScreen mainScreen] bounds].size.width / 375.0f * w * h / w)


//设置是否调试模式
#if DEBUG
#define MYLog(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MYLog(xx, ...) ((void)0)
#endif

#endif /* SRCardHeader_h */
