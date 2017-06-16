//
//  DynamicCommentCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DynamicCommentCell;
@protocol DynamicCommentCellDelegate <NSObject>
-(void)commentUserHeaderClick:(DynamicCommentCell *)cell;  //头像点击时
-(void)commentZanClick  :(DynamicCommentCell *)cell;  //赞点击时
-(void)commentReplyClick:(DynamicCommentCell *)cell;  //回复点击时
@end

@class DynamicCommentFrame;
@interface DynamicCommentCell : UITableViewCell
@property(nonatomic,strong)id<DynamicCommentCellDelegate> delegate;
@property(nonatomic,strong)DynamicCommentFrame * dynamicCommentFrame;
@end
