//
//  ExpressionBoxView.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ExpressionBoxView.h"

@interface ExpressionBoxView()
{
    UIScrollView   * _expressSelectBox;
    NSMutableArray * _expressArr;
}
@end

@implementation ExpressionBoxView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        //初始化变量
        [self initVar];
        
        
 
        
    }
    return self;
}

-(void)initVar {
    
    _expressArr = [NSMutableArray array];
    
    for(int i = 0;i<90;i++){
        
        NSString     * imageName = [NSString stringWithFormat:@"smiley_%d",i];
        NSString     * imageText = [NSString stringWithFormat:@"[表情-%d]",i];
        NSDictionary * dict      = @{@"imageName":imageName,@"index":@(i),@"imageText":imageText};
        [_expressArr addObject:dict];
    }
    
    
}

-(void)createExpressView {
    
    
    //创建视图
    [self createView];
    
    
}

-(void)createView {
    
    if(_expressSelectBox != nil){
        NSLog(@"表情UI创建过了，不需要在创建，直接返回");
        return;
    }

    //创建表情容器视图
    _expressSelectBox = [UIScrollView ScrollViewInitWith:^(UIScrollView *view) {
        view
        .L_Frame(CGRectMake(0,5,self.frame.size.width,self.frame.size.height - 30))
        .L_pagingEnabled(YES)
        .L_AddView(self);
    }];
    
    NSLog(@"!!!!!!!%@",_expressSelectBox);

    CGFloat expressItemSize = [_expressSelectBox width]/9;
    
    //判断每行显示的数量
    NSInteger colCount = (int)([_expressSelectBox width] / expressItemSize);
    
    //总共多少行
    NSInteger rowCount = (int)([_expressSelectBox height] / expressItemSize);
    
    NSLog(@"####%ld",(long)colCount);
    NSLog(@"####%ld",(long)rowCount);
    
    //计算每页显示的数量
    NSInteger pageItemCount = colCount * rowCount - 2;
    
    //总数组
    NSMutableArray * expressMainArr = [NSMutableArray array];
    
    //根据每页显示的数量分割数组
    NSMutableArray * tempArr = [NSMutableArray array];
    for(int i=0;i<_expressArr.count;i++){

        if(i % pageItemCount == 0){
            
            [tempArr addObject:@{@"imageName":@"shanchuExpress",@"index":@(-1),@"imageText":@""}];
            [tempArr addObject:@{@"imageName":@"sendBtn",@"index":@(-2),@"imageText":@""}];
            
            tempArr = [NSMutableArray array];

            [expressMainArr addObject:tempArr];
            
            
        }
        
        [tempArr addObject:_expressArr[i]];

    }
    
    //设置总滚动容器的页数
    [_expressSelectBox setContentSize:CGSizeMake(expressMainArr.count * [_expressSelectBox width],[_expressSelectBox height])];

 
    for(int i = 0;i<expressMainArr.count;i++){
        
        UIView * expressBoxItem = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_Frame(CGRectMake(i * [_expressSelectBox width],0,[_expressSelectBox width],[_expressSelectBox height]))
            .L_BgColor([UIColor whiteColor])
            .L_AddView(_expressSelectBox);
            
        }];
        
        //每组表情的数组
        NSMutableArray * tempExpressArr = expressMainArr[i];
        
        //如果是最后一个新增两个按钮
        if( i == expressMainArr.count - 1){
            
            //判断数量差几个
            int addCount = (int)(pageItemCount - tempExpressArr.count);
            for(int k = 0;k<addCount;k++){
                [tempExpressArr addObject:@{}];
            }
            
            
            [tempExpressArr addObject:@{@"imageName":@"shanchuExpress",@"index":@(-1),@"imageText":@""}];
            [tempExpressArr addObject:@{@"imageName":@"sendBtn",@"index":@(-2),@"imageText":@""}];
            
        }
        
        for(int j=0;j<tempExpressArr.count;j++){
            
            NSDictionary * dictData = tempExpressArr[j];
 
            //当前列
            int nowCol = j % colCount;

            //当前行
            int nowRow = j / colCount;
 
            //创建表情项
            UIView * expressItem = [UIView ViewInitWith:^(UIView *view) {
                view
                .L_Frame(CGRectMake((nowCol * expressItemSize),(nowRow * expressItemSize),expressItemSize, expressItemSize))
                .L_AddView(expressBoxItem);
            }];
   
            if([dictData[@"imageName"] isEqualToString:@"sendBtn"]){
                
                [UIButton ButtonInitWith:^(UIButton *btn) {
                    btn
                    .L_Frame(CGRectMake(3, [expressItem height]/2 - 25/2, [expressItem width] - 6,25 ))
                    .L_Title(@"发送",UIControlStateNormal)
                    .L_Font(12)
                    .L_TitleColor([UIColor whiteColor],UIControlStateNormal)
                    .L_TargetAction(self,@selector(sendExpressSubmit),UIControlEventTouchUpInside)
                    .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
                    .L_AddView(expressItem);
                } buttonType:UIButtonTypeCustom];
                
            }else if([dictData[@"imageName"] isEqualToString:@"shanchuExpress"]){
                
                //删除图标
                [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                    imgv
                    .L_Frame(CGRectMake(5, 5, [expressItem width] - 10, [expressItem height] - 10))
                    .L_ImageName(dictData[@"imageName"])
                    .L_ImageMode(UIViewContentModeScaleAspectFit)
                    .L_Tag([dictData[@"index"] integerValue])
                    .L_Event(YES)
                    .L_Click(self,@selector(deleteExpressIconClick:))
                    .L_AddView(expressItem);
                }];
            
            }else{
                
                //表情图标
                [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                    imgv
                    .L_Frame(CGRectMake(5, 5, [expressItem width] - 10, [expressItem height] - 10))
                    .L_ImageName(dictData[@"imageName"])
                    .L_ImageMode(UIViewContentModeScaleAspectFit)
                    .L_Tag([dictData[@"index"] integerValue])
                    .L_Event(YES)
                    .L_Click(self,@selector(expressIconClick:))
                    .L_AddView(expressItem);
                }];
                
            }
            
        }
        
        
    }
        
    
}

//添加表情
-(void)expressIconClick:(UITapGestureRecognizer *)tap {
    
    NSInteger tagValue = tap.view.tag;
    
    NSDictionary * dictData = _expressArr[tagValue];
    
    //取出该图片的名称
    NSString * imageStr = dictData[@"imageName"];
    
    [self.delegate sendExpressMessage:imageStr];
   
    
}

//删除信息
-(void)deleteExpressIconClick:(UITapGestureRecognizer *)tap {
    
    [self.delegate deleteExpressMessage];
    
}

//发送
-(void)sendExpressSubmit {
    
    [self.delegate sendExpressSubmit];
}
@end
