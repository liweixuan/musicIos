//
//  DynamicImagePreviewViewController.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIViewController.h"

@interface DynamicImagePreviewViewController : Base_UIViewController
@property(nonatomic,strong)NSString * imgUrl;
@property(nonatomic,strong)UIImage  * imageData;
@property(nonatomic,strong)NSArray  * imageArr;  //图片数组
@property(nonatomic,assign)NSInteger  imageIdx;  //当前点击的图片索引
@property(nonatomic,assign)NSInteger  imageType; //显示类型 1-URL类型 2-数据源类型
@end
