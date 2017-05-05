//
//  ImageMessageModel.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMessageModel : NSObject
@property(nonatomic,strong)RCMessage * rcMessage;      //融云消息对象

@property(nonatomic,strong)NSString  * tempMessageUrl;       //临时测试用-图片地址
@property(nonatomic,strong)UIImage   * tempMessageImage;     //临时测试用-图片数据源
@property(nonatomic,assign)NSInteger   tempMessageDirection; //临时测试用-图片消息方向

-(instancetype)   initWithDict    :(NSDictionary *)dict;
+(instancetype)ImageMessageWithDict:(NSDictionary *)dict;
@end
