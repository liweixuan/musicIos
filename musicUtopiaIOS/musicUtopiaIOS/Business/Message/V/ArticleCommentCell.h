//
//  ArticleCommentCell.h
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleCommentCell;
@protocol ArticleCommentCellDelegate <NSObject>
-(void)commentUserHeaderClick:(ArticleCommentCell *)cell;  //头像点击时
-(void)commentZanClick  :(ArticleCommentCell *)cell;  //赞点击时
-(void)commentReplyClick:(ArticleCommentCell *)cell;  //回复点击时
@end

@class ArticleCommentFrame;
@interface ArticleCommentCell : UITableViewCell
@property(nonatomic,strong)id<ArticleCommentCellDelegate> delegate;
@property(nonatomic,strong)ArticleCommentFrame * articleCommentFrame;
@end
