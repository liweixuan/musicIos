//
//  MyOrganizationEditViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyOrganizationEditViewController.h"
#import "MyOrganizationEditCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "OrganizationPhotoImageViewController.h"
#import "OrganizationUserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"
#import "AlbumViewController.h"
#import "SelectAddressView.h"
#import "InputTextFieldViewController.h"
#import "CreateAskViewController.h"
#import "TextViewViewController.h"
#import "MyOrganizationPhotoManagerViewController.h"

@interface MyOrganizationEditViewController ()<UITableViewDelegate,UITableViewDataSource,CameraDelegate,TZImagePickerControllerDelegate,SelectAddressDelegate,AlbumDelegate>
{
    Base_UITableView  * _tableview;
    NSDictionary      * _organizationDetail;
    NSArray           * _organizationPhoto;
    SelectAddressView * _selectAddressView;
    UIImageView       * _coverImageView;
    UIImageView       * _logoImageView;
    
    NSInteger          _uploadType; //0-LOGO 1-封面
    
    NSMutableDictionary * _organizationInfoParams;
    NSMutableArray      * _organizationInfoArr;
}


@end

@implementation MyOrganizationEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑团体";
    
    //初始化变量
    [self initVar];
    
    //初始化表视图
    [self createTableView];
    
    //创建导航按钮
    [self createNavBtn];
    
    //初始化数据
    [self initData];
    
    //创建地址选择视图
    [self createSelectAddressView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputResult:) name:@"INPUT_RESULT_VALUE" object:nil];
    
}
//初始化变量
-(void)initVar {
    
    _uploadType = 0;
    
    _organizationInfoArr = [NSMutableArray array];
    for(int i=0;i<10;i++){
        [_organizationInfoArr addObject:@{@"text":@"",@"content":@""}];
    }
    
    
    _organizationInfoParams = [NSMutableDictionary dictionary];
    
}

//初始化数据
-(void)initData {
    
    
    //初始化数据
    [self startLoading];
    
    NSLog(@"请求团体详情数据...");
    
    //构建restful参数
    NSArray  * params = @[@{@"key":@"o_id",@"value":@(self.organizationId)}];
    NSString * URL    = [G formatRestful:API_ORGANIZATION_INFO Params:params];
    
    //请求动态数据
    [NetWorkTools GET:URL params:nil successBlock:^(NSArray *array) {
        
        NSDictionary * dictData = (NSDictionary *)array;
        
        //保存数据
        _organizationDetail = [dictData objectForKey:@"detail"];
        _organizationPhoto  = [dictData objectForKey:@"photo"];
        
        [_organizationInfoArr removeAllObjects];
        
        
        //创建更新用数据
        [_organizationInfoArr addObject:@{@"text":@"团体名称",@"content":_organizationDetail[@"o_name"]}];
        NSString * pName = [BusinessEnum getEmptyString:_organizationDetail[@"o_province_name"]];
        NSString * cName = [BusinessEnum getEmptyString:_organizationDetail[@"o_city_name"]];
        NSString * dName = [BusinessEnum getEmptyString:_organizationDetail[@"o_district_name"]];
        NSString *  pcdName = [NSString stringWithFormat:@"%@%@%@",pName,cName,dName];
        [_organizationInfoArr addObject:@{@"text":@"所在地点",@"content":pcdName}];
        
        [_organizationInfoArr addObject:@{@"text":@"团体类型",@"content":_organizationDetail[@"o_type"]}];
        
        NSString * dateTime = [G formatData:[_organizationDetail[@"o_create_time"] integerValue] Format:@"YYYY-mm-dd"];
        [_organizationInfoArr addObject:@{@"text":@"创建时间",@"content":dateTime}];
        
        NSString * userNickName = [UserData getUsername];
        [_organizationInfoArr addObject:@{@"text":@"创始人",@"content":userNickName}];
        [_organizationInfoArr addObject:@{@"text":@"座右铭",@"content":_organizationDetail[@"o_motto"]}];
        [_organizationInfoArr addObject:@{@"text":@"申请条件",@"content":_organizationDetail[@"o_ask"]}];
        [_organizationInfoArr addObject:@{@"text":@"信息描述",@"content":_organizationDetail[@"o_desc"]}];
        
        //更新表视图
        [_tableview reloadData];
        
        //删除加载动画
        [self endLoading];
        
        
    } errorBlock:^(NSString *error) {
        
        //向控制器发送错误
        NSLog(@"网路请求错误...");
        
    }];
    
    
}

//创建导航按钮
-(void)createNavBtn {

    R_NAV_TITLE_BTN(@"R",@"保存", saveOrganizationInfo)
}

-(void)createSelectAddressView {
    _selectAddressView = [[SelectAddressView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectAddressView.delegate = self;
    _selectAddressView.hidden = YES;
    [self.navigationController.view addSubview:_selectAddressView];
}

-(void)closeSelectLocation {
    _selectAddressView.hidden = YES;
}

//初始化表视图
-(void)createTableView {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(12,0,60,0));
    }];
    
    _tableview.marginBottom = 10;
    
    
    [UIButton ButtonInitWith:^(UIButton *btn) {
        btn
        .L_Frame(CGRectMake(CARD_MARGIN_LEFT,D_HEIGHT_NO_NAV - BOTTOM_BUTTON_HEIGHT-8 ,D_WIDTH - CARD_MARGIN_LEFT * 2, BOTTOM_BUTTON_HEIGHT))
        .L_BgColor([UIColor redColor])
        .L_Title(@"解散团体",UIControlStateNormal)
        .L_TargetAction(self,@selector(deleteOrganization),UIControlEventTouchUpInside)
        .L_shadowOffset(CGSizeMake(3,3))
        .L_shadowOpacity(0.2)
        .L_ShadowColor([UIColor grayColor])
        .L_radius_NO_masksToBounds(20)
        .L_AddView(self.view);
    } buttonType:UIButtonTypeCustom];
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrganizationEditCell * cell = [[MyOrganizationEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //LOGO+名称+封面
    if(indexPath.row == 0){

        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT + CONTENT_PADDING_LEFT,80/2 - NORMAL_CELL_HIEGHT/2, [cell.contentView width], NORMAL_CELL_HIEGHT))
            .L_Text(@"团体Logo")
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        
        UIImageView * rightIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,80/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
        
        NSString * logoUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_logo"]];
        
        //创建LOGO
        _logoImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake([rightIcon left] - 70,80/2 - 60/2,60,60))
            .L_ImageUrlName(logoUrl,IMAGE_DEFAULT)
            .L_Event(YES)
            .L_Click(self,@selector(uploadLogoImageClick))
            .L_ImageMode(UIViewContentModeScaleAspectFit)
            .L_radius(30)
            .L_AddView(cell.contentView);
        }];

        //团体名称
    }else if(indexPath.row == 1){
        

        NSDictionary * cellDict = _organizationInfoArr[0];
        cell.dictData   = cellDict;
        
        //封面
    }else if(indexPath.row == 2){
        
        NSString * coverUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_organizationDetail[@"o_cover"]];
        
        _coverImageView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,10,D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2, 230))
            .L_ImageUrlName(coverUrl,RECTANGLE_IMAGE_DEFAULT)
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
 
        //更改按钮
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake(D_WIDTH/2 - 120/2,[_coverImageView top] + [_coverImageView height] - 60, 120,35))
            .L_TargetAction(self,@selector(uploadCoverImageClick),UIControlEventTouchUpInside)
            .L_BgColor(HEX_COLOR(@"#000000"))
            .L_Title(@"更换封面",UIControlStateNormal)
            .L_Font(CONTENT_FONT_SIZE)
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_Alpha(0.6)
            .L_AddView(cell.contentView);
        } buttonType:UIButtonTypeCustom];
    
    //所在地点
    }else if(indexPath.row == 3){
        
        NSDictionary * cellDict = _organizationInfoArr[1];
        cell.dictData   = cellDict;
        
        //成员数量
    }else if(indexPath.row == 4){
        
        NSString * userCount = [NSString stringWithFormat:@"%@",_organizationDetail[@"o_user_count"]];
        NSDictionary * cellDict = @{@"text":@"成员数量",@"content":userCount};
        cell.dictData   = cellDict;
        
        //团体类型
    }else if(indexPath.row == 5){
        
        NSDictionary * cellDict = _organizationInfoArr[2];
        cell.dictData   = cellDict;
        
        
        
        //创立时间
    }else if(indexPath.row == 6){
        
        NSDictionary * cellDict = _organizationInfoArr[3];
        cell.isHideRightIcon = YES;
        cell.dictData   = cellDict;
        

        
        //创始人
    }else if(indexPath.row == 7){
        
        NSDictionary * cellDict = _organizationInfoArr[4];
        cell.isHideRightIcon = YES;
        cell.dictData   = cellDict;
        
        
        //座右铭
    }else if(indexPath.row == 8){
        
        NSDictionary * cellDict = _organizationInfoArr[5];
        cell.dictData   = cellDict;
        
        //申请条件
    }else if(indexPath.row == 9){
        
        NSDictionary * askDict = _organizationInfoArr[6];
        

        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"shenqingtiaojian")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon top],100,ATTR_FONT_SIZE))
            .L_Text(askDict[@"text"])
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        NSArray *askArr = [askDict[@"content"] componentsSeparatedByString:@"|"];
        if(askArr.count > 0){
            
            CGFloat askItemY = [icon bottom] + CONTENT_PADDING_TOP;
            
            //条件内容
            for(int i =0;i<askArr.count;i++){
                
                UILabel * indexLabel = [UILabel LabelinitWith:^(UILabel *la) {
                    la
                    .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT*2,askItemY,16,16))
                    .L_Text([NSString stringWithFormat:@"%d",(i+1)])
                    .L_BgColor(HEX_COLOR(BG_GARY))
                    .L_Font(12)
                    .L_textAlignment(NSTextAlignmentCenter)
                    .L_TextColor(HEX_COLOR(@"#FFFFFF"))
                    .L_radius(8)
                    .L_AddView(cell.contentView);
                }];
                
                
                UILabel * label = [UILabel LabelinitWith:^(UILabel *la) {
                    
                    la
                    .L_Frame(CGRectMake([indexLabel right]+ICON_MARGIN_CONTENT, [indexLabel top]+1, [cell.contentView width],16))
                    .L_Text(askArr[i])
                    .L_Font(CONTENT_FONT_SIZE)
                    .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
                    .L_AddView(cell.contentView);
                    
                }];
                
                askItemY = [label bottom] + 10;
                
            }
            
        }
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
        
        
        
        //信息描述
    }else if(indexPath.row == 10){
        
        NSDictionary * descDict = _organizationInfoArr[7];
        
        UIImageView * icon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,CONTENT_PADDING_TOP,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"miaoshu")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon top],100,ATTR_FONT_SIZE))
            .L_Text(descDict[@"text"])
            .L_TextColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Font(ATTR_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //计算字符串长度
        CGSize size = [G labelAutoCalculateRectWith:descDict[@"content"] FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2 - INLINE_CELL_PADDING_LEFT, 1000)];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([icon right] + INLINE_CELL_ICON_LEFT,[icon bottom]+CONTENT_PADDING_TOP,D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2-INLINE_CELL_PADDING_LEFT,size.height))
            .L_Text(descDict[@"content"])
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_numberOfLines(0)
            //.L_lineHeight(CONTENT_LINE_HEIGHT)
            .L_AddView(cell.contentView);
        }];
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT-SMALL_ICON_SIZE/2,NORMAL_CELL_HIEGHT/2 - SMALL_ICON_SIZE /2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
        
        //相册
    }else if(indexPath.row == 11){
        
        NSDictionary * cellDict = @{@"text":@"团体相册",@"content":@""};
        cell.dictData   = cellDict;
        
        
    }
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return 80;//370
        
    }else if(indexPath.row == 2){
        
        return 250;
    }else if(indexPath.row == 9){
        
        NSString * nowAsk = _organizationInfoArr[6][@"content"];
        NSArray *askArr = [nowAsk componentsSeparatedByString:@"|"];
        CGFloat rowH = askArr.count * 16 + askArr.count * 10 + CONTENT_PADDING_TOP*3 + ATTR_FONT_SIZE;
        
        return rowH;
    }else if(indexPath.row == 10){
        
        //计算字符串长度
        NSString * nowDesc = _organizationInfoArr[7][@"content"];
        CGSize size = [G labelAutoCalculateRectWith:nowDesc FontSize:CONTENT_FONT_SIZE MaxSize:CGSizeMake(D_WIDTH - CARD_MARGIN_LEFT * 2 - INLINE_CELL_ICON_LEFT * 2-INLINE_CELL_PADDING_LEFT, 1000)];
        return size.height + CONTENT_PADDING_TOP * 2 + ATTR_FONT_SIZE + 15;
        
    }
    
    return NORMAL_CELL_HIEGHT;
}

//LOGO点击
-(void)uploadLogoImageClick {
    _uploadType = 0;
    [self uploadImageAction];
}

//更改封面按钮点击
-(void)uploadCoverImageClick {
    _uploadType = 1;
    [self uploadImageAction];
}

//点击代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InputTextFieldViewController * inputTextFieldVC = [[InputTextFieldViewController alloc] init];
    
    //修改LOGO
    if(indexPath.row == 0){
        
        _uploadType = 0;
        
        [self uploadImageAction];
     
    }else if(indexPath.row == 1){
        
        inputTextFieldVC.VCTitle  = @"团体名称";
        inputTextFieldVC.inputTag = 1;
        NSMutableDictionary * newDict = [_organizationInfoArr[0] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 3){
        
        _selectAddressView.hidden = NO;
    
    //管理成员
    }else if(indexPath.row == 4){
        
        OrganizationUserViewController * organizationUserVC = [[OrganizationUserViewController alloc] init];
        organizationUserVC.organizationId = self.organizationId;
        organizationUserVC.isShowManager  = YES;
        organizationUserVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:organizationUserVC animated:YES];
    
    //团体类型
    }else if(indexPath.row == 5){
        
        inputTextFieldVC.VCTitle  = @"团体类型";
        inputTextFieldVC.inputTag = 5;
        NSMutableDictionary * newDict = [_organizationInfoArr[2] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
    
    //座右铭
    }else if(indexPath.row == 8){
        
        inputTextFieldVC.VCTitle  = @"座右铭";
        inputTextFieldVC.inputTag = 8;
        NSMutableDictionary * newDict = [_organizationInfoArr[5] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
    
    //申请条件
    }else if(indexPath.row == 9){
        
        CreateAskViewController * createAskVC = [[CreateAskViewController alloc] init];
        createAskVC.VCTitle  = @"添加要求";
        createAskVC.inputTag = 9;
        NSMutableDictionary * newDict = [_organizationInfoArr[6] mutableCopy];
        createAskVC.nowTags  = newDict[@"content"];
        createAskVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:createAskVC animated:YES];
        
    }else if(indexPath.row == 10){
        
        TextViewViewController * textViewVC =  [[TextViewViewController alloc] init];
        textViewVC.VCTitle  = @"团体描述";
        textViewVC.inputTag = 10;
        NSMutableDictionary * newDict = [_organizationInfoArr[7] mutableCopy];
        textViewVC.defaultStr  = newDict[@"content"];
        textViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:textViewVC animated:YES];

        
    }else if(indexPath.row == 11){
        
        PUSH_VC(MyOrganizationPhotoManagerViewController, YES, @{});
 
    }
    
}

#pragma mark - 事件部分
-(void)deleteOrganization {
    NSLog(@"解散团体操作");
}

-(void)saveOrganizationInfo {
    NSLog(@"保存团体信息");
    
    if([_organizationInfoParams allKeys].count <= 0){
        SHOW_HINT(@"您并未做任何修改");
        return;
    }
    
    [_organizationInfoParams setObject:@(self.organizationId) forKey:@"o_id"];
    
    [self startActionLoading:@"正在更新团体信息..."];
    [NetWorkTools POST:API_ORGANIZATION_UPDATE params:_organizationInfoParams successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        SHOW_HINT(@"团体信息修改成功");
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
}

-(void)photoItemViewClick:(UITapGestureRecognizer *)tap {
    NSInteger tagValue = tap.view.tag;
    
    NSDictionary * dictData = _organizationPhoto[tagValue];
    
    //获取相册中的图片数据
    NSArray * params = @[@{@"key":@"op_oid",@"value":dictData[@"op_oid"]},@{@"key":@"op_fid",@"value":dictData[@"op_id"]}];
    NSString * url   = [G formatRestful:API_ORGANIZATION_PHOTOS Params:params];
    
    [self startActionLoading:@"正在打开相册..."];
    [NetWorkTools GET:url params:nil successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        
        if(array.count > 0){
            
            OrganizationPhotoImageViewController *photoVC = [[OrganizationPhotoImageViewController alloc] init];
            photoVC.imageType = 1;
            photoVC.imageArr  = array;
            photoVC.imageIdx  = 0;
            
            photoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:photoVC animated:YES completion:nil];
            
        }else{
            
            SHOW_HINT(@"该相册中暂无图片");
            
        }
    } errorBlock:^(NSString *error) {
        [self endActionLoading];
        SHOW_HINT(error);
    }];
    
}

-(void)albumSelectImage:(UIImage *)image {

    [self uploadCoverAction:image ImageDir:@"organizationLogoImage"];
    
}

//重新上传
-(void)uploadImageAction {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if(_uploadType == 0){
            
            AlbumViewController * albumVc = [[AlbumViewController alloc] init];
            albumVc.delegate = self;
            [self presentViewController:albumVc animated:YES completion:nil];
            
        }else{
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
        
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CameraViewController * albumVC = [[CameraViewController alloc] init];
        [self presentViewController:albumVC animated:YES completion:nil];
        
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//相册图片选择代理
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    

    [self uploadCoverAction:photos[0] ImageDir:@"organizationCoverImage"];

    
}

-(void)cameraTakePhoto:(UIImage *)photo {
    
    [self uploadCoverAction:photo ImageDir:@"organizationLogoImage"];
    
}

//上传封面
-(void)uploadCoverAction:(UIImage * )image ImageDir:(NSString *)dir {
    
    [self startActionLoading:@"正在上传图片..."];
    [NetWorkTools uploadImage:@{@"image":image,@"imageDir":dir} Result:^(BOOL results, NSString *fileName) {
        
        [self endActionLoading];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!results){
                SHOW_HINT(@"图片上传失败");
                return;
            }
            
            if(_uploadType == 0){
                
                _logoImageView.image = image;
                
                [_organizationInfoParams setObject:fileName forKey:@"o_logo"];
                
            }else{
                
                _coverImageView.image = image;
                
                [_organizationInfoParams setObject:fileName forKey:@"o_cover"];
                
            }

            
        });
      
        
    }];
    
}


//数据录入反回通知
-(void)inputResult:(NSNotification *)noti {
    
    NSDictionary * dictData = noti.userInfo;
    
    //获取当条CELL
    NSInteger indexPathRow  = [dictData[@"inputTag"] integerValue];
    
    
    
    //团体名称
    if(indexPathRow == 1){
        
        NSMutableDictionary * newDict = [_organizationInfoArr[0] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_organizationInfoArr replaceObjectAtIndex:(0) withObject:newDict];
        [_organizationInfoParams setObject:dictData[@"inputValue"] forKey:@"o_name"];
        
    }else if(indexPathRow == 5){
        
        NSMutableDictionary * newDict = [_organizationInfoArr[2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_organizationInfoArr replaceObjectAtIndex:(2) withObject:newDict];
        [_organizationInfoParams setObject:dictData[@"inputValue"] forKey:@"o_type"];
        
    }else if(indexPathRow == 8){
        
        NSMutableDictionary * newDict = [_organizationInfoArr[5] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_organizationInfoArr replaceObjectAtIndex:(5) withObject:newDict];
        [_organizationInfoParams setObject:dictData[@"inputValue"] forKey:@"o_motto"];

        
    }else if(indexPathRow == 9){
        
        NSMutableDictionary * newDict = [_organizationInfoArr[6] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_organizationInfoArr replaceObjectAtIndex:(6) withObject:newDict];
        [_organizationInfoParams setObject:dictData[@"inputValue"] forKey:@"o_ask"];
     
    }else if(indexPathRow == 10){
        
        NSMutableDictionary * newDict = [_organizationInfoArr[7] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_organizationInfoArr replaceObjectAtIndex:(7) withObject:newDict];
        [_organizationInfoParams setObject:dictData[@"inputValue"] forKey:@"o_desc"];
        
    }
    
    //更新数据源
    [_tableview reloadData];
    
    
}

//省市区选择代理
-(void)selectLocation:(NSDictionary *)locationDict {
    
    
    NSString * pName = [BusinessEnum getEmptyString:locationDict[@"pName"]];
    NSString * cName = [BusinessEnum getEmptyString:locationDict[@"cName"]];
    NSString * dName = [BusinessEnum getEmptyString:locationDict[@"dName"]];
    NSString * locationStr = [NSString stringWithFormat:@"%@%@%@",pName,cName,dName];
    
    //更改数据源
    NSMutableDictionary * newDict = [_organizationInfoArr[1] mutableCopy];
    [newDict setValue:locationStr forKey:@"content"];
    [_organizationInfoArr replaceObjectAtIndex:1 withObject:newDict];
    
    [_organizationInfoParams setObject:locationDict[@"pid"] forKey:@"u_province"];
    [_organizationInfoParams setObject:locationDict[@"cid"] forKey:@"u_city"];
    [_organizationInfoParams setObject:locationDict[@"did"] forKey:@"u_district"];
    
    [_tableview reloadData];
    
    _selectAddressView.hidden = YES;
}

@end
