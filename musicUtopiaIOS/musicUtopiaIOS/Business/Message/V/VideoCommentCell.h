//
//  VideoCommentCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoCommentCell;
@protocol VideoCommentCellDelegate <NSObject>
-(void)commentUserHeaderClick:(VideoCommentCell *)cell;  //头像点击时
-(void)commentZanClick  :(VideoCommentCell *)cell;  //赞点击时
-(void)commentReplyClick:(VideoCommentCell *)cell;  //回复点击时
@end

@class VideoCommentFrame;
@interface VideoCommentCell : UITableViewCell
@property(nonatomic,strong)id<VideoCommentCellDelegate> delegate;
@property(nonatomic,strong)VideoCommentFrame * videoCommentFrame;
@end
