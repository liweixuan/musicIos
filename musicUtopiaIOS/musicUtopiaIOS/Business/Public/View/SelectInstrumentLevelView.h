//
//  SelectInstrumentLevelView.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "Base_UIView.h"

@protocol SelectInstrumentLevelDelegate <NSObject>

//选择
-(void)selectInstrumentLevel:(NSDictionary *)instrumentLevelDict;

//关闭
-(void)closeSelectInstrumentLevel;

@end

@interface SelectInstrumentLevelView : Base_UIView
@property(nonatomic,strong)id<SelectInstrumentLevelDelegate> delegate;
@end
