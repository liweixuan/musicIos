//
//  UIScrollView+Link.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UIScrollView+Link.h"

@implementation UIScrollView (Link)

+(instancetype)ScrollViewInitWith:(void (^)(UIScrollView *))initBlock{
    UIScrollView *v = [[UIScrollView alloc]init];
    if (initBlock) {
        initBlock(v);
    }
    return v;
    
}

-(UIScrollView *(^)(CGRect))L_Frame{
    return ^UIScrollView *(CGRect rect){
        self.frame = rect;
        return self;
    };
    
}

-(UIScrollView *(^)(UIColor *))L_BgColor{
    return ^UIScrollView *(UIColor *color){
        self.backgroundColor =color ;
        return self;
    };
    
}

-(UIScrollView *(^)(UIView *))L_AddView{
    return ^UIScrollView *(UIView *view){
        [view addSubview:self];
        return self;
    };
}

-(UIScrollView *(^)(BOOL))L_bounces {
    return ^UIScrollView *(BOOL bounces){
        self.bounces = bounces;
        return self;
    };
}

-(UIScrollView *(^)(BOOL))L_pagingEnabled {
    return ^UIScrollView *(BOOL page){
        self.pagingEnabled = page;
        return self;
    };
}

-(UIScrollView *(^)(BOOL))L_showsHorizontalScrollIndicator {
    return ^UIScrollView *(BOOL isH){
        self.showsHorizontalScrollIndicator = isH;
        return self;
    };
}

-(UIScrollView *(^)(BOOL))L_showsVerticalScrollIndicator {
    return ^UIScrollView *(BOOL isV){
        self.showsVerticalScrollIndicator = isV;
        return self;
    };
}

-(UIScrollView *(^)(CGSize))L_contentSize {
    return ^UIScrollView *(CGSize size){
        self.contentSize = size;
        return self;
    };

}

@end
