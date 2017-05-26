#import "CreateOrganizationViewController.h"
#import "CardCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "CameraViewController.h"
#import "SelectAddressView.h"
#import "InputTextFieldViewController.h"
#import "CreateAskViewController.h"
#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface CreateOrganizationViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,SelectAddressDelegate,VideoDelegate>
{
    Base_UITableView  * _tableview;
    NSArray           * _tableData;
    UIImageView       * _coverView;
    UIImageView       * _logoPreview;
    SelectAddressView * _selectAddressView;
    UIImageView       * _videoCover;
    UIImageView       * _playerVideoIcon;
    UIImageView       * _addVideoIcon;
    
    NSInteger          _uploadType;  //上传的类型 0-封面 1-LOGO
    NSInteger          _videoType;   //视频的类型 0-上传 1-播放
    
    NSMutableArray   * _createOrganizationArr;  //创建团体数据源
    
    UIImage          * _coverImage;
    UIImage          * _videoImage;
    UIImage          * _logoImage;
    NSURL            * _videoUrl;
    
    NSDictionary     * _locationData;
    NSString         * _coverImageUrl;  //封面上传后的图片
    NSString         * _logoImageUrl;   //Logo上传后的图片
    NSString         * _videoEndUrl;    //视频上传后的图片
}
@end

@implementation CreateOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建团体";
    
    [self initVar];
    
    //创建导航按钮
    [self createNavigationRightBtn];
    
    //创建表视图
    [self createTableview];
    
    //创建地址选择视图
    [self createSelectAddressView];
    
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputResult:) name:@"INPUT_RESULT_VALUE" object:nil];

}

-(void)initVar {
    
    _uploadType = 0;
    _videoType  = 0;
    _createOrganizationArr = [NSMutableArray array];
    _coverImageUrl = @"";
    _logoImageUrl  = @"";
    _videoEndUrl   = @"";
    _coverImage    = [UIImage imageNamed:RECTANGLE_IMAGE_DEFAULT];
    _logoImage     = [UIImage imageNamed:IMAGE_DEFAULT];
    
    //初始化数据
    [_createOrganizationArr addObject:@{@"icon":@"o_mingcheng",@"text":@"团体名称",@"content":@"点击设置",@"isMust":@YES}];
    [_createOrganizationArr addObject:@{@"icon":@"o_diqu",@"text":@"所在地区",@"content":@"点击设置",@"isMust":@YES}];
    [_createOrganizationArr addObject:@{@"icon":@"o_xiangxi",@"text":@"详细地址",@"content":@"点击设置",@"isMust":@YES}];
    [_createOrganizationArr addObject:@{@"icon":@"o_leixing",@"text":@"团体类型",@"content":@"点击设置",@"isMust":@YES}];
    [_createOrganizationArr addObject:@{@"icon":@"o_miaoshu",@"text":@"描述信息",@"content":@"点击设置",@"isMust":@YES}];
    [_createOrganizationArr addObject:@{@"icon":@"o_shenqing",@"text":@"申请要求",@"content":@"点击设置",@"isMust":@YES}];
    [_createOrganizationArr addObject:@{@"icon":@"o_zuoyouming",@"text":@"座右铭"  ,@"content":@"点击设置",@"isMust":@YES}];
    
}


//创建表视图
-(void)createTableview {
    
    //创建列表视图
    _tableview  = [[Base_UITableView alloc] init];
    _tableview.backgroundColor = HEX_COLOR(VC_BG);
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    
    //创建上下拉刷新
    _tableview.isCreateHeaderRefresh = NO;
    _tableview.isCreateFooterRefresh = NO;
    
    //去除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    //设置布局
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(15,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
}

-(void)createNavigationRightBtn {
    R_NAV_TITLE_BTN(@"R",@"提交",createOrganizationClick);
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCell * cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //cell的宽度
    CGFloat cellW = D_WIDTH - CARD_MARGIN_LEFT * 2;
    
    //封面
    if(indexPath.row == 0){
        
        NSLog(@"111111");
        
        _coverView = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,0,D_WIDTH - CARD_MARGIN_LEFT * 2,257))
            .L_Image(_coverImage)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        //更改按钮
        [UIButton ButtonInitWith:^(UIButton *btn) {
            btn
            .L_Frame(CGRectMake(D_WIDTH/2 - 120/2,[_coverView height] - 80, 120,35))
            .L_TargetAction(self,@selector(uploadCoverView),UIControlEventTouchUpInside)
            .L_BgColor(HEX_COLOR(APP_MAIN_COLOR))
            .L_Title(@"上传封面",UIControlStateNormal)
            .L_Font(CONTENT_FONT_SIZE)
            .L_ShadowColor([UIColor grayColor])
            .L_shadowOffset(CGSizeMake(2,2))
            .L_shadowOpacity(0.2)
            .L_radius_NO_masksToBounds(5)
            .L_Alpha(0.8)
            .L_AddView(cell.contentView);
        } buttonType:UIButtonTypeCustom];
        
    //LOGO
    }else if(indexPath.row == 1){
        
       UIImageView * logoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(INLINE_CELL_PADDING_LEFT,80/2 - SMALL_ICON_SIZE/2,SMALL_ICON_SIZE,SMALL_ICON_SIZE))
            .L_ImageName(@"o_logo")
            .L_AddView(cell.contentView);
        }];
        
        UILabel * mustHint =  [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([logoIcon right]+ICON_MARGIN_CONTENT,80/2 - 15/2 + 2,10,15))
            .L_TextColor([UIColor redColor])
            .L_Text(@"*")
            .L_AddView(cell.contentView);
        }];
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake([mustHint right] + ICON_MARGIN_CONTENT,0, [cell.contentView width], 80))
            .L_Text(@"团体LOGO")
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //预览lOGO
        _logoPreview  = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cellW - CONTENT_PADDING_LEFT - CARD_MARGIN_LEFT - CONTENT_PADDING_LEFT - 40, 15,50,50))
            .L_Image(_logoImage)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cellW - 14, 80/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];

    //团体名称
    }else if(indexPath.row == 2){
        
        cell.dictData = _createOrganizationArr[0];

    //所在地区
    }else if(indexPath.row == 3){
        
        cell.dictData = _createOrganizationArr[1];
        
    }else if(indexPath.row == 4){
        
        cell.dictData = _createOrganizationArr[2];
        
    }else if(indexPath.row == 5){
        
         cell.dictData = _createOrganizationArr[3];
        
    }else if(indexPath.row == 6){
        
         cell.dictData = _createOrganizationArr[4];
        
    }else if(indexPath.row == 7){
        
         cell.dictData = _createOrganizationArr[5];
        
    }else if(indexPath.row == 8){
        
         cell.dictData = _createOrganizationArr[6];
    
    }else{
        
        
        _videoCover = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,2,D_WIDTH - CARD_MARGIN_LEFT * 2,250))
            .L_Image(_videoImage)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        
        _addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
           imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,250/2 - 60/2 - 20, 60, 60))
            .L_ImageName(@"addIcon")
            .L_radius(30)
            .L_AddView(cell.contentView);
        }];
        
        _playerVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,250/2 - 60/2 - 20, 60, 60))
            .L_ImageName(@"bofang")
            .L_radius(30)
            .L_AddView(cell.contentView);
        }];
        
        if(_videoType == 0){
            _addVideoIcon.hidden = NO;
            _playerVideoIcon.hidden = YES;
        }else{
            _addVideoIcon.hidden = YES;
            _playerVideoIcon.hidden = NO;
        }
        
        [UILabel LabelinitWith:^(UILabel *la) {
           la
            .L_Frame(CGRectMake(D_WIDTH/2 - 100/2,[_addVideoIcon bottom]+CONTENT_PADDING_TOP,100,TITLE_FONT_SIZE))
            .L_Font(TITLE_FONT_SIZE)
            .L_Text(@"团体宣传视频")
            .L_TextColor(HEX_COLOR(ATTR_FONT_COLOR))
            .L_AddView(cell.contentView);
        }];
        
    }
    
    
    
    //禁止点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return 260;
    }else if(indexPath.row == 1){
        return 80;
    }else if(indexPath.row == 9){
        return 250;
    }

    return NORMAL_CELL_HIEGHT;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InputTextFieldViewController * inputTextFieldVC = [[InputTextFieldViewController alloc] init];
    
    if(indexPath.row == 1){
        
        _uploadType = 1;
        [self uploadCoverView];
    
    }else if(indexPath.row == 2){
        
        inputTextFieldVC.VCTitle  = @"团体名称";
        inputTextFieldVC.inputTag = 2;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 3){
        
        NSLog(@"选择省市区");
        _selectAddressView.hidden = NO;
    
    }else if(indexPath.row == 4){
        
        inputTextFieldVC.VCTitle  = @"详细地址名称";
        inputTextFieldVC.inputTag = 4;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 5){
        
        inputTextFieldVC.VCTitle  = @"团体类型";
        inputTextFieldVC.inputTag = 5;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
        
    }else if(indexPath.row == 6){
        
        inputTextFieldVC.VCTitle  = @"描述信息";
        inputTextFieldVC.inputTag = 6;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];

    }else if(indexPath.row == 7){
        
        CreateAskViewController * createAskVC = [[CreateAskViewController alloc] init];
        createAskVC.VCTitle  = @"申请要求";
        createAskVC.inputTag = 7;
        [self.navigationController pushViewController:createAskVC animated:YES];
        
    }else if(indexPath.row == 8){
        
        inputTextFieldVC.VCTitle  = @"座右铭";
        inputTextFieldVC.inputTag = 8;
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
    
    }else if(indexPath.row == 9){

        NSLog(@"上传视频...");
        
        UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            VideoViewController * videoVC = [[VideoViewController alloc] init];
            videoVC.delegate = self;
            [self presentViewController:videoVC animated:YES completion:nil];
            
        }];
        
        [videoAlertController addAction:cancelAction];
        [videoAlertController addAction:deleteAction];
        
        [self presentViewController:videoAlertController animated:YES completion:nil];
        
        
        
    }
}

-(void)createSelectAddressView {
    _selectAddressView = [[SelectAddressView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectAddressView.delegate = self;
    _selectAddressView.hidden = YES;
    [self.navigationController.view addSubview:_selectAddressView];
}

//上传封面
-(void)uploadCoverView {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
 
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
    
    //上传
    if(_uploadType == 0){
        [self uploadCoverAction:photos[0] ImageDir:@"organizationCoverImage"];
    }else{
        [self uploadCoverAction:photos[0] ImageDir:@"organizationLogoImage"];
    }

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
                
                _coverImage = image;
                [_tableview reloadData];
                
            }else{
                
                _logoImage = image;
                [_tableview reloadData];
            }
            

        });
        
        if(_uploadType == 0){
            _coverImageUrl = fileName;
        }else{
            _logoImageUrl = fileName;
        }
        
    }];
    
}

//数据录入反回通知
-(void)inputResult:(NSNotification *)noti {
    NSLog(@"%@",noti.userInfo);
    
    NSDictionary * dictData = noti.userInfo;

    //获取当条CELL
    NSInteger indexPathRow  = [dictData[@"inputTag"] integerValue];

    //团体名称
    if(indexPathRow == 2){

        NSMutableDictionary * newDict = [_createOrganizationArr[indexPathRow - 2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_createOrganizationArr replaceObjectAtIndex:(indexPathRow - 2) withObject:newDict];

    }else if(indexPathRow == 4){

        NSMutableDictionary * newDict = [_createOrganizationArr[indexPathRow - 2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_createOrganizationArr replaceObjectAtIndex:(indexPathRow - 2) withObject:newDict];
        
        
    }else if(indexPathRow == 5){
        
        NSMutableDictionary * newDict = [_createOrganizationArr[indexPathRow - 2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_createOrganizationArr replaceObjectAtIndex:(indexPathRow - 2) withObject:newDict];
        
    }else if(indexPathRow == 6){
        
        NSMutableDictionary * newDict = [_createOrganizationArr[indexPathRow - 2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_createOrganizationArr replaceObjectAtIndex:(indexPathRow - 2) withObject:newDict];
        
    }else if(indexPathRow == 7){
        
        NSMutableDictionary * newDict = [_createOrganizationArr[indexPathRow - 2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_createOrganizationArr replaceObjectAtIndex:(indexPathRow - 2) withObject:newDict];
        
    }else if(indexPathRow == 8){
        
        NSMutableDictionary * newDict = [_createOrganizationArr[indexPathRow - 2] mutableCopy];
        [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
        [_createOrganizationArr replaceObjectAtIndex:(indexPathRow - 2) withObject:newDict];
        
    }
    
    //更新数据源
    [_tableview reloadData];
    
    
}

//省市区选择代理
-(void)selectLocation:(NSDictionary *)locationDict {
    
    _locationData = locationDict;

    NSString * locationStr = [NSString stringWithFormat:@"%@%@%@",locationDict[@"pName"],locationDict[@"cName"],locationDict[@"dName"]];
    
    //更改数据源
    NSMutableDictionary * newDict = [_createOrganizationArr[1] mutableCopy];
    [newDict setValue:locationStr forKey:@"content"];
    [_createOrganizationArr replaceObjectAtIndex:1 withObject:newDict];
    [_tableview reloadData];
    
    _selectAddressView.hidden = YES;
}

-(void)closeSelectLocation {
    _selectAddressView.hidden = YES;
}

//选择视频回调
-(void)videoSelectURL:(NSURL *)url thumbnailImage:(UIImage *)image {
 
    _videoType  = 1;
    
    _videoImage = image;

    _videoUrl   = url;
    
    //视频封面图
    [_tableview reloadData];

}




#pragma mark - 创建团体操作
-(void)createOrganizationClick {
    
    //数据验证
    if([_coverImageUrl isEqualToString:@""]){
        SHOW_HINT(@"请上传团体封面");
        return;
    }
    
    if([_logoImageUrl isEqualToString:@""]){
        SHOW_HINT(@"请上传团体Logo");
        return;
    }
    
    //是否有必填项未填写
    for(int i =0;i<_createOrganizationArr.count;i++){
        
        NSDictionary * dict = _createOrganizationArr[i];
        
        if([dict[@"isMust"] boolValue] && [dict[@"content"] isEqualToString:@"点击设置"]){
            NSString * textStr = [NSString stringWithFormat:@"%@不能为空",dict[@"text"]];
            SHOW_HINT(textStr);
            return;
        }
    }
    
    
    //判断是否有视频数据，视频上传操作
    if(_videoUrl != nil){
        
       
        
        NSString * dir = @"organizationVideo";
        
        //转化成MP4
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoUrl options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]){
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",[NSHomeDirectory() stringByAppendingString:@"/tmp"],[NSString stringWithFormat:@"%u",arc4random() % 99999]];
            exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
            exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.shouldOptimizeForNetworkUse= YES;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    {
                        SHOW_HINT(@"视频上传失败，请重新尝试");
                    }
                        
                        break;
                    case AVAssetExportSessionStatusCancelled:
                    {
                        SHOW_HINT(@"视频上传失败，请重新尝试");
                    }
                        
                        NSLog(@"Export canceled");
                        break;
                    case AVAssetExportSessionStatusCompleted:
                        NSLog(@"转换成功");
                    {
   
                        //上传视频
                        NSData * videoData = [NSData dataWithContentsOfFile:exportPath];
                        
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [self startActionLoading:@"正在上传视频..."];
                         });
                        [NetWorkTools uploadVideo:@{@"video":videoData,@"videoDir":dir} Result:^(BOOL results, NSString *fileName) {
                            
                             dispatch_sync(dispatch_get_main_queue(), ^{
                                 [self endActionLoading];
                             });
                            
                            if(!results){
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    SHOW_HINT(@"视频上传失败，请重新尝试");
                                });
                                return;
                            }
                            
                            _videoEndUrl = fileName;
                            
                            //创建团体
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self organizationAdd];
                            });
                            
                        }];
                        
                        
                    }
                        break;
                    default:
                        break;
                }
            }];
        }

        
    }else {
        
        [self organizationAdd];
        
    }
}

-(void)organizationAdd {
    


    //创建参数
    NSDictionary * params = @{
                              @"o_name"           : _createOrganizationArr[0][@"content"],
                              @"o_logo"           : _logoImageUrl,
                              @"o_cover"          : _coverImageUrl,
                              @"o_province"       : _locationData[@"pid"],
                              @"o_city"           : _locationData[@"cid"],
                              @"o_district"       : _locationData[@"did"],
                              @"o_type"           : _createOrganizationArr[3][@"content"],
                              @"o_create_userid"  : @(1),
                              @"o_address"        : _createOrganizationArr[2][@"content"],
                              @"o_motto"          : _createOrganizationArr[6][@"content"],
                              @"o_desc"           : _createOrganizationArr[4][@"content"],
                              @"o_ask"            : _createOrganizationArr[5][@"content"],
                              @"o_video_url"      : _videoEndUrl
                              };
    
    NSLog(@"%@",params);
    
    [self startActionLoading:@"正在创建团体..."];
    [NetWorkTools POST:API_ORGANIZATION_ADD params:params successBlock:^(NSArray *array) {
        [self endActionLoading];
        
        SHOW_HINT(@"恭喜您,团体创建成功");
        
        
    } errorBlock:^(NSString *error) {
        SHOW_HINT(error);
        [self endActionLoading];
    }];
    
}
@end
