//
//  LocalData.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData

+(NSArray *)getMusicCategory {
    
    //临时分类数据，模拟从数据库查询
    NSArray * categoryArr = @[
                              @{@"icon":@"c_zonghe",@"c_id":@(21),@"c_name":@"综合"},
                              @{@"icon":@"c_minyaojita",@"c_id":@(9) ,@"c_name":@"民谣吉他"},
                              @{@"icon":@"c_gangqin",@"c_id":@(10),@"c_name":@"钢琴"},
                              @{@"icon":@"c_xiaotiqin",@"c_id":@(11),@"c_name":@"小提琴"},
                              @{@"icon":@"c_erhu",@"c_id":@(12),@"c_name":@"二胡"},
                              @{@"icon":@"c_datiqin",@"c_id":@(16),@"c_name":@"大提琴"},
                              @{@"icon":@"c_gudianjita",@"c_id":@(19),@"c_name":@"古典吉他"},
                              @{@"icon":@"c_dianjita",@"c_id":@(20),@"c_name":@"电声吉他"},
                              @{@"icon":@"c_xiaohao",@"c_id":@(22),@"c_name":@"小号"},
                              @{@"icon":@"c_dianbeisi",@"c_id":@(23),@"c_name":@"电声贝斯"},
                              @{@"icon":@"c_changdi",@"c_id":@(24),@"c_name":@"长笛"},
                              @{@"icon":@"c_sakesi",@"c_id":@(25),@"c_name":@"萨克斯管"},
                              @{@"icon":@"c_danhuangguan",@"c_id":@(26),@"c_name":@"单簧管"},
                              @{@"icon":@"c_kouqin",@"c_id":@(27),@"c_name":@"口琴"},
                              @{@"icon":@"c_youkelili",@"c_id":@(28),@"c_name":@"尤克里里"},
                              @{@"icon":@"c_jiazigu",@"c_id":@(29),@"c_name":@"架子鼓"}
    ];
    
    return categoryArr;
    
}

+(NSMutableArray *)getStandardMusicCategory {
    
    //临时分类数据，模拟从数据库查询
    NSArray * categoryArr = @[
                              @{@"icon":@"c_minyaojita",@"c_id":@(9) ,@"c_name":@"民谣吉他"},
                              @{@"icon":@"c_gangqin",@"c_id":@(10),@"c_name":@"钢琴"},
                              @{@"icon":@"c_xiaotiqin",@"c_id":@(11),@"c_name":@"小提琴"},
                              @{@"icon":@"c_erhu",@"c_id":@(12),@"c_name":@"二胡"},
                              @{@"icon":@"c_datiqin",@"c_id":@(16),@"c_name":@"大提琴"},
                              @{@"icon":@"c_gudianjita",@"c_id":@(19),@"c_name":@"古典吉他"},
                              @{@"icon":@"c_dianjita",@"c_id":@(20),@"c_name":@"电声吉他"},
                              @{@"icon":@"c_xiaohao",@"c_id":@(22),@"c_name":@"小号"},
                              @{@"icon":@"c_dianbeisi",@"c_id":@(23),@"c_name":@"电声贝斯"},
                              @{@"icon":@"c_changdi",@"c_id":@(24),@"c_name":@"长笛"},
                              @{@"icon":@"c_sakesi",@"c_id":@(25),@"c_name":@"萨克斯管"},
                              @{@"icon":@"c_danhuangguan",@"c_id":@(26),@"c_name":@"单簧管"},
                              @{@"icon":@"c_kouqin",@"c_id":@(27),@"c_name":@"口琴"},
                              @{@"icon":@"c_youkelili",@"c_id":@(28),@"c_name":@"尤克里里"},
                              @{@"icon":@"c_jiazigu",@"c_id":@(29),@"c_name":@"架子鼓"}
                              ];

    return [categoryArr mutableCopy];
    
}

+(NSMutableArray *)getLocationInfoResult:(loctaionResults)rs{
    
    [NetWorkTools GET:API_COMMENT_ALL_LOCATION params:nil successBlock:^(NSArray *array) {

        rs(YES,array);
        
    } errorBlock:^(NSString *error) {
        
        rs(NO,@[]);
        
    }];
    
    return nil;
    
}

@end
