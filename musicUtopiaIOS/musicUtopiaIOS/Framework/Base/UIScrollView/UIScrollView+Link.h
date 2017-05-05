//
//  UIScrollView+Link.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Link)
-(UIScrollView *(^)(CGRect))L_Frame;
-(UIScrollView *(^)(UIColor *))L_BgColor;
-(UIScrollView *(^)(UIView *))L_AddView;
-(UIScrollView *(^)(BOOL))L_bounces;
-(UIScrollView *(^)(BOOL))L_pagingEnabled;
-(UIScrollView *(^)(BOOL))L_showsHorizontalScrollIndicator;
-(UIScrollView *(^)(BOOL))L_showsVerticalScrollIndicator;
-(UIScrollView *(^)(CGSize))L_contentSize;

+(instancetype)ScrollViewInitWith:(void(^)(UIScrollView * view)) initBlock;
@end
