#import "DynamicFrame.h"

@implementation DynamicFrame

-(instancetype)initWithDynamic:(DynamicModel *)model {
    
    self = [super init];
    
    //进行相关位置计算
    if(self){
        

        //数据源赋值
        self.dynamicModel = model;
        
        //获取卡片宽度
        CGFloat cardWidth = D_WIDTH - CARD_MARGIN_LEFT * 2;
        
        //头像位置
        self.headerUrlFrame = CGRectMake(CONTENT_PADDING_LEFT,CONTENT_PADDING_TOP,HEADER_SIZE,HEADER_SIZE);
        

        //性别图标位置
        self.sexIconFrame = CGRectMake(CGRectGetMaxX(self.headerUrlFrame) + CONTENT_MARGIN_LEFT,CGRectGetMinY(self.headerUrlFrame) + 12,SMALL_ICON_SIZE,SMALL_ICON_SIZE);
        
        //性别内容
        self.sexFrame = CGRectMake(CGRectGetMaxX(self.sexIconFrame)+ICON_MARGIN_CONTENT, CGRectGetMinY(self.sexIconFrame),30,ATTR_FONT_SIZE);
        
        //用户昵称
        CGSize nicknameSize = [G labelAutoCalculateRectWith:self.dynamicModel.nickname FontSize:TITLE_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH,1000)];
        self.nickNameFrame = CGRectMake(CGRectGetMaxX(self.sexFrame),CGRectGetMinY(self.sexIconFrame)-2,nicknameSize.width,TITLE_FONT_SIZE);
        
        //动态类型图标
        self.categoryIconFrame = CGRectMake(D_WIDTH-(CARD_MARGIN_LEFT*2)-20-MIDDLE_ICON_SIZE/2,CGRectGetMinY(self.headerUrlFrame), MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
        
        //位置图标
        self.locationIconFrame = CGRectMake(CGRectGetMinX(self.sexIconFrame), CGRectGetMaxY(self.sexIconFrame)+CONTENT_PADDING_TOP,SMALL_ICON_SIZE, SMALL_ICON_SIZE);
        
        //位置信息
        NSString * locationStr = @"";
        if([self.dynamicModel.location isEqualToString:@""]||self.dynamicModel.location == nil){
            locationStr = @"未获取到该用户位置信息";
        }else{
            locationStr = self.dynamicModel.location;
        }
        CGSize locationSize = [G labelAutoCalculateRectWith:locationStr FontSize:ATTR_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH,1000)];
        self.locationFrame = CGRectMake(CGRectGetMaxX(self.locationIconFrame)+ICON_MARGIN_CONTENT, CGRectGetMinY(self.locationIconFrame),locationSize.width,ATTR_FONT_SIZE);
        
        //内容
        CGSize contentSize = [G labelAutoCalculateRectWith:self.dynamicModel.content FontSize:SUBTITLE_FONT_SIZE MaxSize:CGSizeMake(cardWidth - CONTENT_PADDING_LEFT *2, 1000)];
        
        //判断如果没有内容，将content的高度设置为0
        if(contentSize.width<=0){ contentSize.height = 0.0; }
        self.contentFrame = CGRectMake(CONTENT_PADDING_LEFT,CGRectGetMaxY(self.headerUrlFrame) + CONTENT_MARGIN_TOP,cardWidth - CONTENT_PADDING_LEFT*2,contentSize.height);
        

        //判断是否为图片类型
        if(self.dynamicModel.dynamicType == 1){
            
            //获取图片数量
            NSInteger imageCount = self.dynamicModel.images.count;
            
            //图片容器的高度
            CGFloat imageBoxHeight = 0.0;
            
            //判断图片数量
            if(imageCount > 1){
                
                //判断有几行
                CGFloat r = (CGFloat)imageCount / 3;
                
                //行数
                int row = ceil(r);
                
                //获取图片显示的大小
                CGFloat imageItemSize = ((cardWidth - CONTENT_PADDING_LEFT*2 - 10) / 3);
                
                //保存每项图片视图的大小
                self.imagesSize = CGSizeMake(imageItemSize, imageItemSize);
                
                //计算图片容器的高度
                imageBoxHeight = row * imageItemSize + (row - 1) * 5;
                
                
            }else{
                
                //获取图片宽高
                self.imagesSize = CGSizeMake(cardWidth * 0.5, cardWidth * 0.5);
                
                imageBoxHeight  = cardWidth * 0.5;
                
                
            }
            
            //图片容器
            self.imagesBoxFrame = CGRectMake(CONTENT_PADDING_LEFT,CGRectGetMaxY(self.contentFrame)+CONTENT_MARGIN_TOP,cardWidth - CONTENT_PADDING_LEFT * 2,imageBoxHeight);
            
        //判断是否为视频类型
        }else if(self.dynamicModel.dynamicType == 2){
            
            if(self.dynamicModel.videoType == 0){
                self.videoBoxFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.contentFrame)+CONTENT_MARGIN_TOP, (cardWidth - CONTENT_PADDING_LEFT * 2)/2, (cardWidth - CONTENT_PADDING_LEFT * 2)*0.9);
            }else{
                self.videoBoxFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.contentFrame)+CONTENT_MARGIN_TOP, cardWidth - CONTENT_PADDING_LEFT * 2, (cardWidth - CONTENT_PADDING_LEFT * 2)*0.7);
            }
            
            //播放按钮
            self.videoPlayerFrame = CGRectMake(self.videoBoxFrame.size.width/2 - 60/2,self.videoBoxFrame.size.height/2 - 60/2,60,60);
            
            
        //判断是否为音频类型
        }else if(self.dynamicModel.dynamicType == 3){
            
            self.audioBoxFrame = CGRectMake(CONTENT_PADDING_LEFT, CGRectGetMaxY(self.contentFrame)+CONTENT_MARGIN_TOP, cardWidth - CONTENT_PADDING_LEFT * 2, 60);
            
        }

        CGFloat tagBoxY = 0.0;
        CGFloat tagBoxH = 0.0;
        if(self.dynamicModel.dynamicType == 0){
            tagBoxY = CGRectGetMaxY(self.contentFrame);
        }else if(self.dynamicModel.dynamicType == 1){
            tagBoxY = CGRectGetMaxY(self.imagesBoxFrame);
        }else if(self.dynamicModel.dynamicType == 2){
            tagBoxY = CGRectGetMaxY(self.videoBoxFrame);
        }else if(self.dynamicModel.dynamicType == 3){
            tagBoxY = CGRectGetMaxY(self.audioBoxFrame);
        }else{
            tagBoxY = CGRectGetMaxY(self.contentFrame);
        }
        
        if(self.dynamicModel.tag.length > 0){
            tagBoxH = 30;
        }
        
        //标签容器
        self.tagBoxFrame = CGRectMake(CONTENT_PADDING_LEFT,tagBoxY + 5,cardWidth - CONTENT_PADDING_LEFT * 2, tagBoxH);


        //操作区域容器
        self.actionBoxFrame = CGRectMake(CONTENT_PADDING_LEFT + 2, CGRectGetMaxY(self.tagBoxFrame) + 9,cardWidth - CONTENT_PADDING_LEFT * 2, 30);

        //评论容器
        self.commentBoxFrame = CGRectMake(0,0,self.actionBoxFrame.size.width/3,30);
        
        //评论图标
        self.commentIconFrame = CGRectMake(0, 30/2-MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
        
        //评论内容
        self.commentCountFrame = CGRectMake(CGRectGetMaxX(self.commentIconFrame) + ICON_MARGIN_CONTENT,0,100,30);
        
        //点赞容器
        self.zanBoxFrame = CGRectMake(self.actionBoxFrame.size.width/3,0,self.actionBoxFrame.size.width/3,30);
        
        //点赞图标
        self.zanIconFrame = CGRectMake(0, 30/2-MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
        
        //点赞内容
        self.zanCountFrame = CGRectMake(CGRectGetMaxX(self.zanIconFrame) + ICON_MARGIN_CONTENT,0,100,30);
        
        //关注容器
        self.concernBoxFrame = CGRectMake(self.actionBoxFrame.size.width/3*2,0,self.actionBoxFrame.size.width/3,30);
        
        //关注图标
        self.concernIconFrame = CGRectMake(0, 30/2-MIDDLE_ICON_SIZE/2, MIDDLE_ICON_SIZE, MIDDLE_ICON_SIZE);
        
        //关注文字
        self.concernTextFrame = CGRectMake(CGRectGetMaxX(self.concernIconFrame) + ICON_MARGIN_CONTENT,0,100,30);
 
        //行高度
        self.cellHeight = CGRectGetMaxY(self.tagBoxFrame) + CONTENT_MARGIN_TOP*3 + self.actionBoxFrame.size.height;
        
  
        
    }
    return self;
}

@end
