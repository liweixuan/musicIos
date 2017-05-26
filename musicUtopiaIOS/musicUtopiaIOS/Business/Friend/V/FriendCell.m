#import "FriendCell.h"

@interface FriendCell()
{
    UIView      * _cellBox;
    UIImageView * _headerImageView;
    UILabel     * _nicknameView;
    UIImageView * _rightIconView;
}
@end

@implementation FriendCell

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
        

        _headerImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(HEADER_DEFAULT)
            .L_radius(5)
            .L_AddView(_cellBox);
        }];
        
        //标题
        _nicknameView = [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Font(TITLE_FONT_SIZE)
            .L_TextColor(HEX_COLOR(TITLE_FONT_COLOR))
            .L_AddView(_cellBox);
        }];
        
        //右侧箭头
        _rightIconView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_ImageName(@"fanhui")
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
    
    _headerImageView.frame = CGRectMake(CONTENT_PADDING_LEFT,10,40,40);
    
    _nicknameView.frame = CGRectMake([_headerImageView right]+CONTENT_PADDING_LEFT, 0, 100, [_cellBox height]);
    
    _rightIconView.frame = CGRectMake([_cellBox width] - CONTENT_PADDING_LEFT - SMALL_ICON_SIZE,[_cellBox height]/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
    
    
    
}

-(void)setDictData:(NSDictionary *)dictData {
    
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,dictData[@"u_header_url"]];
    _headerImageView.L_ImageUrlName(imageUrl,HEADER_DEFAULT);
    
    _nicknameView.L_Text(dictData[@"u_nickname"]);
    
    
    
}
@end
