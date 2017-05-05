#import "DynamicCell.h"
#import "TagLabel.h"

@interface DynamicCell()
{
    UIView      * _cellBox;
    UIImageView * _headerUrlView;
    UIImageView * _sexIconView;
    UILabel     * _sexView;
    UILabel     * _nicknameView;
    UIImageView * _categoryIconView;
    UIImageView * _locationIconView;
    UILabel     * _locationView;
    UILabel     * _contentView;
    UIView      * _imageBoxView;
    UIView      * _videoBoxView;
    UIView      * _audioBoxView;
    UIView      * _tagBoxView;
    UIView      * _actionBoxView;
    UIView      * _zanBoxView;
    UIView      * _commentBoxView;
    UIView      * _concernBoxView;
    UIImageView * _commentIconView;
    UILabel     * _commentCountView;
    UIImageView * _zanIconView;
    UILabel     * _zanCountView;
    UIImageView * _concernIconView;
    UILabel     * _concernTextView;
}
@end

@implementation DynamicCell

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
        
        _headerUrlView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(HEADER_DEFAULT)
            .L_Event(YES)
            .L_Click(self,@selector(userHeaderClick))
            .L_AddView(_cellBox);
        }];
        
        _sexIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        _sexView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _categoryIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_AddView(_cellBox);
        }];
        
        _locationIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(_cellBox);
        }];
        
        _locationView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _contentView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_numberOfLines(0)
            .L_AddView(_cellBox);
        }];
        
        _imageBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _tagBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _actionBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _zanBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_actionBoxView);
        }];
        
        _commentBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Click(self,@selector(commentClick))
            .L_AddView(_actionBoxView);
        }];
        
        _concernBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_actionBoxView);
        }];
        
        _commentIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(_commentBoxView);
        }];
        
        _commentCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_commentBoxView);
        }];
        
        _zanIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(_zanBoxView);
        }];
        
        _zanCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_zanBoxView);
        }];
        
        _concernIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(ICON_DEFAULT)
            .L_AddView(_concernBoxView);
        }];
        
        _concernTextView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_concernBoxView);
        }];

        _videoBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _audioBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        

        
    }
    return self;
}

//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];

    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,CARD_MARGIN_TOP,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - CARD_MARGIN_TOP * 2);
}

//设置位置+数据
-(void)setDynamicFrame:(DynamicFrame *)dynamicFrame {
    
    //数据对象
    DynamicModel * dataModel = (DynamicModel *)dynamicFrame.dynamicModel;

    //头像
    _headerUrlView.frame = dynamicFrame.headerUrlFrame;
    _headerUrlView.L_Round();
    
    //性别图标
    _sexIconView.frame = dynamicFrame.sexIconFrame;
    _sexIconView.L_ImageName(dataModel.sexIcon);
    
    //性别
    _sexView.frame     = dynamicFrame.sexFrame;
    _sexView.L_Text(dataModel.sex);
    
    //昵称
    _nicknameView.frame = dynamicFrame.nickNameFrame;
    _nicknameView.L_Text(dataModel.nickname);
    
    //乐器分类图标
    _categoryIconView.frame = dynamicFrame.categoryIconFrame;
    _categoryIconView.L_ImageName(dataModel.cIcon);
    
    //地理位置图标
    _locationIconView.frame = dynamicFrame.locationIconFrame;
    
    //地理位置信息
    _locationView.frame = dynamicFrame.locationFrame;
    _locationView.L_Text(dataModel.location);
    
    //内容
    _contentView.frame = dynamicFrame.contentFrame;
    _contentView.L_Text(dataModel.content);
    _contentView.L_lineHeight(CONTENT_LINE_HEIGHT);
    
    //图片容器
    _imageBoxView.frame = dynamicFrame.imagesBoxFrame;
    
    //在容器中创建图片视图
    if(dynamicFrame.dynamicModel.dynamicType == 1 && dynamicFrame.dynamicModel.images.count > 0){
        
        for(int i = 0;i<dynamicFrame.dynamicModel.images.count;i++){
            
            CGFloat col = i % 3;
            
            CGFloat marginRight = 0.0;

            if(col > 0){
                marginRight = 5;
            }
 
            //x位置
            CGFloat ix = col * (dynamicFrame.imagesSize.width + marginRight);
            
            //上间距
            CGFloat marginTop = 0.0;
            
            //y位置
            CGFloat row = i / 3;
            
            if(row > 0){
                marginTop = 5;
            }
            
            
            CGFloat iy  = row * dynamicFrame.imagesSize.height + marginTop;
            
            //图片数据
            NSDictionary * imageData = dynamicFrame.dynamicModel.images[i];

            //创建图片视图项
            [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
               
                imgv
                .L_Frame(CGRectMake(ix,iy,dynamicFrame.imagesSize.width,dynamicFrame.imagesSize.height))
                .L_BgColor([UIColor grayColor])
                .L_ImageUrlName(imageData[@"di_img_url"],IMAGE_DEFAULT)
                .L_Click(self,@selector(imageClick))
                .L_AddView(_imageBoxView);
                
            }];
            

        }
        
    }
    
    //视频类型动态
    if(dynamicFrame.dynamicModel.dynamicType == 2){
        
        //视频容器
        _videoBoxView.frame = dynamicFrame.videoBoxFrame;
        
        //根据视频类别加载占位图
        NSString * videoDefaultImage = @"";
        
        if(dynamicFrame.dynamicModel.videoType == 0){
            videoDefaultImage = MOBILE_VIDEO_DEFAULT;
        }else{
            videoDefaultImage = VIDEO_DEFAULT;
        }
        
        //创建视频占位图
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(0,0,[_videoBoxView width],[_videoBoxView height]))
            .L_ImageName(videoDefaultImage)
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_videoBoxView);
        }];
        
        
    }
    
    //音频动态类型
    if(dynamicFrame.dynamicModel.dynamicType == 3){
        
        _audioBoxView.frame = dynamicFrame.audioBoxFrame;
        _audioBoxView.backgroundColor = [UIColor grayColor];
        
        //创建音频占位图
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(0,0,[_audioBoxView width],[_audioBoxView height]))
            .L_ImageName(AUDIO_DEFAULT)
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_AddView(_audioBoxView);
        }];
        
    }

    //tag容器
    _tagBoxView.frame = dynamicFrame.tagBoxFrame;
    
    //创建tag显示视图
    if(dynamicFrame.dynamicModel.tag.length > 0){
        NSArray *tags = [dynamicFrame.dynamicModel.tag componentsSeparatedByString:@"|"];
        
        CGFloat nowX = 0.0;
        
        for(int i =0;i<tags.count;i++){
            
            //内容大小
            CGSize s = [G labelAutoCalculateRectWith:tags[i] FontSize:ATTR_FONT_SIZE MaxSize:CGSizeMake(1000, 1000)];
            
            //创建UILabel
            TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(nowX,5,s.width + 30,30)];
            tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
            tagLabel.text = tags[i];
            tagLabel.textColor = [UIColor whiteColor];
            tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
            tagLabel.layer.masksToBounds = YES;
            tagLabel.layer.cornerRadius = 15;
            tagLabel.insets = UIEdgeInsetsMake(0,15, 0,15);
            [_tagBoxView addSubview:tagLabel];
            
            //X轴位置变化
            nowX += s.width + 30 + 10;
        }
    }
    
    
    
    //操作区域容器
    _actionBoxView.frame = dynamicFrame.actionBoxFrame;

    //评论容器
    _commentBoxView.frame = dynamicFrame.commentBoxFrame;
    
    //评论图标
    _commentIconView.frame = dynamicFrame.commentIconFrame;
    
    //评论内容
    _commentCountView.frame = dynamicFrame.commentCountFrame;
    _commentCountView.L_Text([NSString stringWithFormat:@"评论(%ld)",(long)dynamicFrame.dynamicModel.commentCount]);
    
    //点赞图标
    _zanIconView.frame = dynamicFrame.zanIconFrame;
    
    //点赞内容
    _zanCountView.frame = dynamicFrame.zanCountFrame;
    _zanCountView.L_Text([NSString stringWithFormat:@"点赞(%ld)",(long)dynamicFrame.dynamicModel.zanCount]);
    
    //点赞容器
    _zanBoxView.frame = dynamicFrame.zanBoxFrame;
    
    //关注容器
    _concernBoxView.frame = dynamicFrame.concernBoxFrame;
    
    //点赞图标
    _concernIconView.frame = dynamicFrame.zanIconFrame;
    
    //点赞内容
    _concernTextView.frame = dynamicFrame.zanCountFrame;
    _concernTextView.L_Text([NSString stringWithFormat:@"关注"]);
}

//图片点击
-(void)imageClick {
    NSLog(@"click_image......");
}

//评论点击
-(void)commentClick {
   [self.delegate commentClick:self];
}

//头像点击
-(void)userHeaderClick {
    [self.delegate userHeaderClick:self];
}

@end
