//
//  MessageCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell()
{
    UIView      * _cellBox;
    UIImageView * _headerView;
    UILabel     * _nicknameView;
    UILabel     * _messageContentView;
    UILabel     * _timeView;
    UILabel     * _messageCountView;
}
@end

@implementation MessageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //设置CELL背景
        self.contentView.backgroundColor = HEX_COLOR(VC_BG);
        
        _cellBox = [UIView ViewInitWith:^(UIView *view) {
            
            view
            .L_BgColor([UIColor whiteColor])
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_AddView(self.contentView);
            
        }];
        
        _headerView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_AddView(_cellBox);
        }];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _messageContentView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(CONTENT_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        _timeView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(ATTR_FONT_SIZE)
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_textAlignment(NSTextAlignmentRight)
            .L_AddView(_cellBox);
        }];
        
        _messageCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(12)
            .L_TextColor([UIColor whiteColor])
            .L_BgColor([UIColor redColor])
            .L_textAlignment(NSTextAlignmentCenter)
            .L_AddView(_cellBox);
        }];
        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,INLINE_CARD_MARGIN,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - INLINE_CARD_MARGIN * 2);
    
    //头像
    _headerView.frame = CGRectMake(CONTENT_PADDING_LEFT,8,48,48);
    _headerView.L_radius(5);
    
    //昵称
    _nicknameView.frame = CGRectMake([_headerView right]+8, [_headerView top]+7,200,SUBTITLE_FONT_SIZE);
    
    //消息内容
    _messageContentView.frame = CGRectMake([_headerView right]+8, [_nicknameView bottom]+8,[_cellBox width] - [_headerView width] - CONTENT_PADDING_LEFT - 20 - 30,CONTENT_FONT_SIZE);

    
    //发送时间
    _timeView.frame = CGRectMake([_cellBox width] - 60 - CONTENT_PADDING_LEFT,[_nicknameView top]-2,60,ATTR_FONT_SIZE);
    
    //消息数提示
    _messageCountView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - 20,[_timeView bottom]+8,16,16);
    _messageCountView.L_radius(8);
    
    
    //重写滑动删除按钮样式
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            CGRect cRect = subView.frame;
            cRect.origin.y    = 4;
            cRect.size.height = self.contentView.frame.size.height - 8;
            subView.frame = cRect;
            subView.backgroundColor = [UIColor clearColor];
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            confirmView.L_ShadowColor([UIColor grayColor]);
            confirmView.L_shadowOffset(CGSizeMake(2,2));
            confirmView.L_shadowOpacity(0.2);
            confirmView.L_raius_location(UIRectCornerTopLeft|UIRectCornerBottomLeft,5);

            // 改背景颜色
            confirmView.backgroundColor= [UIColor redColor];
            for(UIView *sub in confirmView.subviews){
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                    UILabel *deleteLabel=(UILabel *)sub;
                    
                    // 改删除按钮的字体
                    deleteLabel.font=[UIFont boldSystemFontOfSize:15];
                    
                    // 改删除按钮的文字
                    deleteLabel.text=@"删除";
                }
            }
            break;
        }
    }
    
}


-(void)setConversaction:(RCConversation *)conversaction {
    
    //判断是否为系统消息
    if([conversaction.targetId isEqualToString:@"ADD_FRIEND_SYSTEM_USER"]){
        _headerView.L_ImageName(@"xitongxiaoxi");
        _nicknameView.L_Text(@"好友请求");
        
    }else if([conversaction.targetId isEqualToString:@"JOIN_ORGANIZATION_SYSTEM_USER"]){
        
        _headerView.L_ImageName(@"xitongxiaoxi");
        _nicknameView.L_Text(@"团体申请");
    
    }else{
        
        //判断是个人信息还是群组信息
        if(conversaction.conversationType == ConversationType_PRIVATE){
            
            [MemberInfoData getMemberInfo:conversaction.targetId MemberEnd:^(NSDictionary *memberInfo) {
                
                NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,memberInfo[@"m_headerUrl"]];
                _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
                
                //昵称
                _nicknameView.L_Text(memberInfo[@"m_nickName"]);
                
            }];
            
            
        }else if(conversaction.conversationType == ConversationType_GROUP){
            
            [GroupInfoData getGroupInfo:conversaction.targetId GroupEnd:^(NSDictionary *groupInfo) {
                
                NSLog(@"#######%@",groupInfo);
                
                NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,groupInfo[@"g_headerUrl"]];
                _headerView.L_ImageUrlName(headerUrl,HEADER_DEFAULT);
                
                //昵称
                _nicknameView.L_Text(groupInfo[@"g_name"]);
                
            }];
            
        }
        
    }
    
    //发送时间
    NSString * timeStr = [G formatData:(conversaction.sentTime/1000) Format:@"MM-dd"];
    _timeView.L_Text(timeStr);

    NSString * uMessageCountStr = @"";
    if(conversaction.unreadMessageCount > 0){
        uMessageCountStr = [NSString stringWithFormat:@"%d",conversaction.unreadMessageCount];
        _messageCountView.L_Text(uMessageCountStr);
        _messageCountView.hidden = NO;
    }else{
        _messageCountView.hidden = YES;
    }
    
    
    //判断消息类型
    RCMessageContent * rccontent = conversaction.lastestMessage;
    
    NSLog(@"^^^^%@",rccontent);

    //消息内容
    NSString * messageContent = @"";
    
    //文本消息
    if([rccontent isKindOfClass:[RCTextMessage class]]){
        
        RCTextMessage * textMessage = (RCTextMessage *)rccontent;
        messageContent = textMessage.content;
        
    //图片消息
    }else if([rccontent isKindOfClass:[RCImageMessage class]]){
        
        messageContent = @"[图片]";
    
    //语音消息
    }else if([rccontent isKindOfClass:[RCVoiceMessage class]]) {
        
        messageContent = @"[语音]";
        
    //通知类消息
    }else if([rccontent isKindOfClass:[RCInformationNotificationMessage class]]){

        RCInformationNotificationMessage * infoMessage = (RCInformationNotificationMessage *)rccontent;
        messageContent = infoMessage.message;
        
    }
   
    //设置内容
    _messageContentView.L_Text(messageContent);
    
    
    //设置系统通知类消息内容
    if([conversaction.targetId isEqualToString:@"ADD_FRIEND_SYSTEM_USER"]){
        
        RCTextMessage * textMessage = (RCTextMessage *)rccontent;
        NSString * jsonStr          = textMessage.content;
        NSDictionary * dictData     = [G dictionaryWithJsonString:jsonStr];
        
        if([dictData[@"operation"] isEqualToString:@"ADD_FRIEND_ACTION"]){
            [MemberInfoData getMemberInfo:dictData[@"sourceUserId"] MemberEnd:^(NSDictionary *memberInfo) {
                _messageContentView.L_Text([NSString stringWithFormat:@"[%@]请求成为您的好友",memberInfo[@"m_nickName"]]);
            }];
        }else if([dictData[@"operation"] isEqualToString:@"REFUSE_FRIEND_ACTION"]){
            [MemberInfoData getMemberInfo:dictData[@"sourceUserId"] MemberEnd:^(NSDictionary *memberInfo) {
                _messageContentView.L_Text([NSString stringWithFormat:@"您拒绝了[%@]的好友请求",memberInfo[@"m_nickName"]]);
            }];
        }else if([dictData[@"operation"] isEqualToString:@"REFUSE_FRIEND_ACTION"]){
            [MemberInfoData getMemberInfo:dictData[@"sourceUserId"] MemberEnd:^(NSDictionary *memberInfo) {
                _messageContentView.L_Text([NSString stringWithFormat:@"您同意了[%@]的好友请求",memberInfo[@"m_nickName"]]);
            }];
        }else if([dictData[@"operation"] isEqualToString:@"AGREE_FRIEND_ACTION"]){
            [MemberInfoData getMemberInfo:dictData[@"sourceUserId"] MemberEnd:^(NSDictionary *memberInfo) {
                _messageContentView.L_Text([NSString stringWithFormat:@"%@同意了您的好友请求",memberInfo[@"m_nickName"]]);
            }];
        }
    }else if([conversaction.targetId isEqualToString:@"JOIN_ORGANIZATION_SYSTEM_USER"]){
        
        RCTextMessage * textMessage = (RCTextMessage *)rccontent;
        NSString * jsonStr          = textMessage.content;
        NSDictionary * dictData     = [G dictionaryWithJsonString:jsonStr];
        
        if([dictData[@"operation"] isEqualToString:@"JOIN_ORGANIZATION_ACTION"]){
            [MemberInfoData getMemberInfo:dictData[@"sourceUserId"] MemberEnd:^(NSDictionary *memberInfo) {
                _messageContentView.L_Text([NSString stringWithFormat:@"[%@]申请加入团体[%@]",memberInfo[@"m_nickName"],dictData[@"extra"]]);
            }];
        }
        
        
    }
    
}


@end
