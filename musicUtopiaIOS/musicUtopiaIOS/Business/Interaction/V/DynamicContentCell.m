//
//  DynamicContentCell.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DynamicContentCell.h"
#import "TagLabel.h"
#import "DynamicImagePreviewViewController.h"

@interface DynamicContentCell()
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
    UIImageView * _videoPlayerIconView;
    UIView      * _audioBoxView;
    UIView      * _tagBoxView;
    UIView      * _actionBoxView;
    UIView      * _zanBoxView;
    UIView      * _commentBoxView;
    UIView      * _concernBoxView;
    UIImageView * _commentIconView;
    UILabel     * _commentCountView;
    UIButton * _zanIconView;
    UILabel     * _zanCountView;
    UIButton * _concernIconView;
    UILabel     * _concernTextView;
    TagLabel    * _ageLabel;
    
    UIImageView * _deleteDynamicBtn;
    
    NSArray     * _imageArr; //图片数组
}

@end

@implementation DynamicContentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //设置CELL背景
        self.contentView.backgroundColor = HEX_COLOR(VC_BG);
        
        _imageArr = [NSArray array];
        
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
        
        _ageLabel = [[TagLabel alloc] init];
        _ageLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
        _ageLabel.layer.masksToBounds = YES;
        _ageLabel.layer.cornerRadius  = 5;
        _ageLabel.insets = UIEdgeInsetsMake(2,5,2,5);
        [_cellBox addSubview:_ageLabel];
        
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_Font(TITLE_FONT_SIZE)
            .L_AddView(_cellBox);
        }];
        
        _categoryIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_AddView(_cellBox);
        }];
        
        //_categoryIconView.hidden = YES;
        
        _locationIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"weizhi")
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
            .L_Font(SUBTITLE_FONT_SIZE)
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
            .L_Click(self,@selector(zanClick))
            .L_AddView(_actionBoxView);
        }];
        
        _commentBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Click(self,@selector(commentClick))
            .L_AddView(_actionBoxView);
        }];
        
        _concernBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_Click(self,@selector(concernClick))
            .L_AddView(_actionBoxView);
        }];
        
        _commentIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"pinglun")
            .L_AddView(_commentBoxView);
        }];
        
        _commentCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_commentBoxView);
        }];
        
        _zanIconView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BtnImageName(@"dianzan",UIControlStateNormal)
            .L_BtnImageName(@"selected_dianzan",UIControlStateSelected)
            .L_TargetAction(self,@selector(zanClick),UIControlEventTouchUpInside)
            .L_AddView(_zanBoxView);
        } buttonType:UIButtonTypeCustom];

        
        _zanCountView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(_zanBoxView);
        }];
        
        _concernIconView = [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_BtnImageName(@"guanzhu",UIControlStateNormal)
            .L_BtnImageName(@"selected_guanzhu",UIControlStateSelected)
            .L_TargetAction(self,@selector(concernClick),UIControlEventTouchUpInside)
            .L_AddView(_concernBoxView);
        } buttonType:UIButtonTypeCustom];
        
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
        
        _videoPlayerIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"bofang")
            .L_Event(YES)
            .L_Click(self,@selector(videoPlayerClick))
            .L_radius(30);
        }];
        
        _audioBoxView = [UIView ViewInitWith:^(UIView *view) {
            view
            .L_AddView(_cellBox);
        }];
        
        _deleteDynamicBtn = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"shanchu")
            .L_Event(YES)
            .L_Click(self,@selector(deleteDynamicClick))
            .L_AddView(_cellBox);
        }];
        _deleteDynamicBtn.hidden = YES;
        
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    [super setFrame:frame];
}


//设置位置
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //行容器大小
    _cellBox.frame = CGRectMake(CARD_MARGIN_LEFT,CARD_MARGIN_TOP,[self.contentView width] - CARD_MARGIN_LEFT * 2,[self.contentView height] - CARD_MARGIN_TOP);
    
    _deleteDynamicBtn.frame = CGRectMake([_cellBox width] - BIG_ICON_SIZE - 12, [_cellBox height] - BIG_ICON_SIZE - 15, BIG_ICON_SIZE, BIG_ICON_SIZE);
}

//设置位置+数据
-(void)setDynamicFrame:(DynamicFrame *)dynamicFrame {
    
    //数据对象
    DynamicModel * dataModel = (DynamicModel *)dynamicFrame.dynamicModel;
    
    //头像
    _headerUrlView.frame = dynamicFrame.headerUrlFrame;
    NSString * headerImageStr = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dynamicFrame.dynamicModel.headerUrl];
    [_headerUrlView sd_setImageWithURL:[NSURL URLWithString:headerImageStr] placeholderImage:[UIImage imageNamed:HEADER_DEFAULT]];
    _headerUrlView.L_radius(5);
    
    //性别图标
    _sexIconView.frame = dynamicFrame.sexIconFrame;
    _sexIconView.L_ImageName(dataModel.sexIcon);
    
    //性别
    _sexView.frame     = dynamicFrame.sexFrame;
    _sexView.L_Text(dataModel.sex);
    
    _ageLabel.frame = dynamicFrame.ageFrame;
    _ageLabel.text = [NSString stringWithFormat:@"%ld",(long)dynamicFrame.dynamicModel.userAge];
    
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
    NSString * locationStr = @"";
    if([dynamicFrame.dynamicModel.location isEqualToString:@""]||dynamicFrame.dynamicModel.location == nil){
        locationStr = @"未获取到该用户位置信息";
    }else{
        locationStr = dynamicFrame.dynamicModel.location;
    }
    _locationView.L_Text(locationStr);
    
    //内容
    _contentView.frame = dynamicFrame.contentFrame;
    _contentView.L_Text(dataModel.content);
    _contentView.L_lineHeight(CONTENT_LINE_HEIGHT);
    
    //图片容器
    _imageBoxView.frame = dynamicFrame.imagesBoxFrame;
    
    //在容器中创建图片视图
    if(dynamicFrame.dynamicModel.dynamicType == 1 && dynamicFrame.dynamicModel.images.count > 0){
        
        _imageArr = dynamicFrame.dynamicModel.images;
        
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
                marginTop = row * 5;
            }
            
            
            CGFloat iy  = row * dynamicFrame.imagesSize.height + marginTop;
            
            //图片数据
            NSDictionary * imageData = dynamicFrame.dynamicModel.images[i];
            
            //图片
            NSString * imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,imageData[@"di_img_url"]];
            
            //创建图片视图项
            [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
                
                imgv
                .L_Frame(CGRectMake(ix,iy,dynamicFrame.imagesSize.width,dynamicFrame.imagesSize.height))
                .L_BgColor(HEX_COLOR(@"#F5F5F5"))
                .L_Event(YES)
                .L_ImageMode(UIViewContentModeScaleAspectFill)
                .L_ImageUrlName(imageUrl,IMAGE_DEFAULT)
                .L_Click(self,@selector(imageClick:))
                .L_borderWidth(1)
                .L_borderColor(HEX_COLOR(@"#EEEEEE"))
                .L_radius(5)
                .L_tag(i)
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
        NSString * videoImageUrl = @"";
        
        if(dynamicFrame.dynamicModel.videoType == 0){
            videoDefaultImage = MOBILE_VIDEO_DEFAULT;
            videoImageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dynamicFrame.dynamicModel.videoImage];
        }else{
            videoDefaultImage = VIDEO_DEFAULT;
            videoImageUrl = dynamicFrame.dynamicModel.videoImage;
        }
        

        //创建视频标题图
        UIImageView * imagev = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(0,0,[_videoBoxView width],[_videoBoxView height]))
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_radius(5)
            .L_AddView(_videoBoxView);
        }];
        
        //加载完成后，添加播放按钮
        [imagev sd_setImageWithURL:[NSURL URLWithString:videoImageUrl] placeholderImage:[UIImage imageNamed:videoDefaultImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //播放按钮
            _videoPlayerIconView.frame = dynamicFrame.videoPlayerFrame;
            [_videoBoxView addSubview:_videoPlayerIconView];
            
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
            TagLabel * tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(nowX,5,s.width + TAG_SIZE,TAG_SIZE)];
            tagLabel.backgroundColor = HEX_COLOR(APP_MAIN_COLOR);
            tagLabel.text = tags[i];
            tagLabel.textColor = [UIColor whiteColor];
            tagLabel.font = [UIFont systemFontOfSize:ATTR_FONT_SIZE];
            tagLabel.layer.masksToBounds = YES;
            tagLabel.layer.cornerRadius = TAG_SIZE/2;
            tagLabel.insets = UIEdgeInsetsMake(0,TAG_SIZE/2, 0,TAG_SIZE/2);
            [_tagBoxView addSubview:tagLabel];
            
            //X轴位置变化
            nowX += s.width + TAG_SIZE + 10;
        }
    }
    
    
    
    //操作区域容器
    _actionBoxView.frame = dynamicFrame.actionBoxFrame;
    [_actionBoxView setY:_actionBoxView.frame.origin.y - 5];
    
    //评论容器
    _commentBoxView.frame = dynamicFrame.commentBoxFrame;
    
    //评论图标
    _commentIconView.frame = dynamicFrame.commentIconFrame;
    
    //评论内容
    _commentCountView.frame = dynamicFrame.commentCountFrame;
    _commentCountView.L_Text([NSString stringWithFormat:@"评论(%ld)",(long)dynamicFrame.dynamicModel.commentCount]);
    
    //点赞图标
    _zanIconView.frame = dynamicFrame.zanIconFrame;
    if(dynamicFrame.dynamicModel.isZan){
        _zanIconView.selected = YES;
    }else{
        _zanIconView.selected = NO;
    }
    
    //点赞内容
    _zanCountView.frame = dynamicFrame.zanCountFrame;
    _zanCountView.L_Text([NSString stringWithFormat:@"点赞(%ld)",(long)dynamicFrame.dynamicModel.zanCount]);
    
    //点赞容器
    _zanBoxView.frame = dynamicFrame.zanBoxFrame;
    
    //关注容器
    _concernBoxView.frame = dynamicFrame.concernBoxFrame;
    
    //关注图标
    _concernIconView.frame = dynamicFrame.zanIconFrame;
    if(dynamicFrame.dynamicModel.isGuanZhu){
        _concernIconView.selected = YES;
    }else{
        _concernIconView.selected = NO;
    }
    
    //关注内容
    _concernTextView.frame = dynamicFrame.zanCountFrame;
    _concernTextView.L_Text([NSString stringWithFormat:@"关注"]);
    
    
    
    
}

-(void)setIsDeleteBtn:(BOOL)isDeleteBtn {

    if(isDeleteBtn){
        
        _zanBoxView.hidden     = YES;
        _concernBoxView.hidden = YES;
        
        //显示删除按钮
        _deleteDynamicBtn.hidden = NO;
    }
}

//图片点击
-(void)imageClick:(UITapGestureRecognizer *)tap {
    NSLog(@"click_image......");
    UIImageView * imageView =  (UIImageView *)tap.view;
    
    NSInteger tagv = tap.view.tag;
    
    DynamicImagePreviewViewController *photoVC = [[DynamicImagePreviewViewController alloc] init];
    photoVC.imageType = 2;
    photoVC.imageData = imageView.image;
    photoVC.imageArr  = _imageArr;
    photoVC.imageIdx  = tagv;
    
    photoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[self viewController] presentViewController:photoVC animated:YES completion:nil];
}

//评论点击
-(void)commentClick {
   
}

//赞点击
-(void)zanClick {
    if(!_zanIconView.isSelected){
        [self.delegate zanClick:self NowView:_zanCountView];
    }
}

//关注
-(void)concernClick  {
    
    if(!_concernIconView.isSelected){
        [self.delegate concernClick:self];
    }
}

//头像点击
-(void)userHeaderClick {
    [self.delegate userHeaderClick:self];
}

- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}

//删除按钮点击
-(void)deleteDynamicClick {
    [self.delegate deleteBtnClick:self];
}

//播放按钮
-(void)videoPlayerClick {
    NSLog(@"播放");
    [self.delegate videoPlayerBtnClick:self];
}
@end
