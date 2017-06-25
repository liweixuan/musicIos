//
//  MyEditViewController.m
//  musicUtopiaIOS
//
//  Created by Apple on 2017/4/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyEditViewController.h"
#import "MyEditCell.h"
#import "AlbumViewController.h"
#import "CameraViewController.h"
#import "SelectAddressView.h"
#import "SelectSexView.h"
#import "MusicCategoryPopView.h"
#import "InputTextFieldViewController.h"
#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JWPlayer.h"
#import "VideoPlayerViewController.h"

@interface MyEditViewController ()<UITableViewDelegate,UITableViewDataSource,AlbumDelegate,CameraDelegate,SelectAddressDelegate,SelectSexDelegate,MusicCategoryPopViewDelegate,VideoDelegate>
{
    Base_UITableView          * _tableview;
    NSMutableDictionary       * _tableData;
    UIImageView               * _headerPreview;
    SelectAddressView         * _selectAddressView;
    SelectSexView             * _selectSexView;
    NSMutableArray            * _userInfoArr;
    NSMutableDictionary       * _updateInfoParams;
    UIView                    * _selectViewBox;     //选择视图
    
    UIImageView       * _videoCover;
    UIImage           * _videoImage;
    UIImageView       * _playerVideoIcon;
    UIImageView       * _addVideoIcon;
    NSInteger          _videoType;   //视频的类型 0-上传 1-播放
    NSURL             * _videoUrl;
    NSString          * _videoEndUrl;    //视频上传后的图片
}
@end

@implementation MyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑用户信息";
    
    
    [self initVar];
    
    //初始化数据
    [self initData];
    
    //创建保存按钮
    [self createNav];
    
    //创建表视图
    [self createTableview];
    
    //创建地址选择视图
    [self createSelectAddressView];
    
    //创建性别选择视图
    [self createSelectSexView];

    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputResult:) name:@"INPUT_RESULT_VALUE" object:nil];
    
    
}


-(void)initVar {

    _tableData        = [NSMutableDictionary dictionary];
    _userInfoArr      = [NSMutableArray array];
    _updateInfoParams = [NSMutableDictionary dictionary];
    
}

-(void)createNav {
    R_NAV_TITLE_BTN(@"R",@"保存",saveUserInfo)

    
}

-(void)createSelectAddressView {
    _selectAddressView = [[SelectAddressView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectAddressView.delegate = self;
    _selectAddressView.hidden = YES;
    [self.navigationController.view addSubview:_selectAddressView];
}

-(void)createSelectSexView {
    _selectSexView = [[SelectSexView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
    _selectSexView.hidden = YES;
    _selectSexView.delegate = self;
    [self.navigationController.view addSubview:_selectSexView];
}


-(void)closeSelectSex {
    _selectSexView.hidden = YES;
}

-(void)closeSelectLocation {
    _selectAddressView.hidden = YES;
}

-(void)initData {
    
    //获取用户信息
    _tableData = [self.userDict mutableCopy];
    
    NSString *nickName = [BusinessEnum getEmptyString:_tableData[@"u_nickname"]];
    [_userInfoArr addObject:@{@"text":@"用户昵称",@"content":nickName}];
    
    NSString * realName = [BusinessEnum getEmptyString:_tableData[@"u_realname"]];
    [_userInfoArr addObject:@{@"text":@"真实姓名",@"content":realName}];
    
    NSString * sexName = [BusinessEnum getSex:[_tableData[@"u_sex"] integerValue]];
    [_userInfoArr addObject:@{@"text":@"用户性别",@"content":sexName}];
    
    NSString * userAge = [NSString stringWithFormat:@"%@",_tableData[@"u_age"]];
    [_userInfoArr addObject:@{@"text":@"用户年龄",@"content":userAge}];
    
    NSString * pName = [BusinessEnum getEmptyString:_tableData[@"u_province_name"]];
    NSString * cName = [BusinessEnum getEmptyString:_tableData[@"u_city_name"]];
    NSString * dName = [BusinessEnum getEmptyString:_tableData[@"u_district_name"]];
    NSString *  pcdName = [NSString stringWithFormat:@"%@%@%@",pName,cName,dName];
    [_userInfoArr addObject:@{@"text":@"所在省市",@"content":pcdName}];
    
    NSString * addressName = [BusinessEnum getEmptyString:_tableData[@"u_address"]];
    [_userInfoArr addObject:@{@"text":@"详细地址",@"content":addressName}];
    
    NSString * signName = [BusinessEnum getEmptyString:_tableData[@"u_sign"]];
    [_userInfoArr addObject:@{@"text":@"个性签名",@"content":signName}];
    
    NSString * qinAge = [NSString stringWithFormat:@"%@",_tableData[@"u_qin_age"]];
    [_userInfoArr addObject:@{@"text":@"乐器琴龄",@"content":qinAge}];
    
    NSArray * goodInstrumentArr = [_tableData[@"u_good_instrument"] componentsSeparatedByString:@"|"];
    [_userInfoArr addObject:@{@"text":@"擅长乐器",@"content":goodInstrumentArr[1]}];

 
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
        make.edges.equalTo(self.view ).with.insets(UIEdgeInsetsMake(10,0,0,0));
    }];
    
    _tableview.marginBottom = 10;
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyEditCell * cell = [[MyEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //cell的宽度
    CGFloat cellW = D_WIDTH - CARD_MARGIN_LEFT * 2;
    
    //头像
    if(indexPath.row == 0){
        
        NSString * headerUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_tableData[@"u_header_url"]];
 
        
        [UILabel LabelinitWith:^(UILabel *la) {
            la
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT*2+1,0, [cell.contentView width], 80))
            .L_Text(@"用户头像")
            .L_TextColor(HEX_COLOR(CONTENT_FONT_COLOR))
            .L_Font(CONTENT_FONT_SIZE)
            .L_AddView(cell.contentView);
        }];
        
        //预览lOGO
        _headerPreview  = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cellW - CONTENT_PADDING_LEFT - CARD_MARGIN_LEFT - CONTENT_PADDING_LEFT - 40, 15,50,50))
            .L_ImageUrlName(headerUrl,HEADER_DEFAULT)
            .L_Event(YES)
            .L_Click(self,@selector(uploadHeader))
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        
        [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(cellW - 14, 80/2 - SMALL_ICON_SIZE/2, SMALL_ICON_SIZE, SMALL_ICON_SIZE))
            .L_ImageName(@"fanhui")
            .L_AddView(cell.contentView);
        }];
 
    //昵称    
    }else if(indexPath.row == 1){
        
        NSDictionary * cellDict = _userInfoArr[0];
        cell.dictData   = cellDict;
        
    //真实姓名
    }else if(indexPath.row == 2){
        
        NSDictionary * cellDict = _userInfoArr[1];
        cell.dictData   = cellDict;
    
    //性别
    }else if(indexPath.row == 3){
        
        NSDictionary * cellDict = _userInfoArr[2];
        cell.dictData   = cellDict;
    
    //年龄
    }else if(indexPath.row == 4){
        
        NSDictionary * cellDict = _userInfoArr[3];
        cell.dictData   = cellDict;

    
    //所在省市区
    }else if(indexPath.row == 5){
        
        NSDictionary * cellDict = _userInfoArr[4];
        cell.dictData   = cellDict;
    
    //详细地址
    }else if(indexPath.row == 6){
        
        NSDictionary * cellDict = _userInfoArr[5];
        cell.dictData   = cellDict;
        
    //个性签名
    }else if(indexPath.row == 7){
        
        NSDictionary * cellDict = _userInfoArr[6];
        cell.dictData   = cellDict;
        
    //琴龄
    }else if(indexPath.row == 8){
        
        NSDictionary * cellDict = _userInfoArr[7];
        cell.dictData   = cellDict;
    
    //擅长的乐器
    }else if(indexPath.row == 9){
        
        NSDictionary * cellDict = _userInfoArr[8];
        cell.dictData   = cellDict;
    
    //听朋友音频
    }else if(indexPath.row == 10){
        
        _videoCover = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(CARD_MARGIN_LEFT,3,D_WIDTH - CARD_MARGIN_LEFT * 2,250))
            .L_Image(_videoImage)
            .L_ImageMode(UIViewContentModeScaleAspectFill)
            .L_radius(5)
            .L_AddView(cell.contentView);
        }];
        
        
        _addVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,250/2 - 60/2 - 20, 60, 60))
            .L_ImageName(@"addIcon")
            .L_Event(YES)
            .L_Click(self,@selector(addVideClick))
            .L_radius(30)
            .L_AddView(cell.contentView);
        }];
        
        _playerVideoIcon = [UIImageView ImageViewInitWith:^(UIImageView *imgv) {
            imgv
            .L_Frame(CGRectMake(D_WIDTH/2 - 60/2,250/2 - 60/2 - 15, 60, 60))
            .L_ImageName(@"bofang")
            .L_Event(YES)
            .L_Click(self,@selector(playerVideClick))
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
            .L_Text(@"我的交友视频")
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
        return 80;
    }else if(indexPath.row == 10){
        return 250;
    }
    return NORMAL_CELL_HIEGHT;
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InputTextFieldViewController * inputTextFieldVC = [[InputTextFieldViewController alloc] init];
    
    //头像
    if(indexPath.row == 0){
        
        [self uploadHeader];
        
    }else if(indexPath.row == 1) {
        
        inputTextFieldVC.VCTitle  = @"用户昵称";
        inputTextFieldVC.inputTag = 1;
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];

        
    }else if(indexPath.row == 2){
        
        inputTextFieldVC.VCTitle  = @"真实姓名";
        inputTextFieldVC.inputTag = 2;
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];

    //选择性别
    }else if(indexPath.row == 3){
        
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        _selectSexView.defaultSex = newDict[@"content"];
        _selectSexView.hidden = NO;
        
    }else if(indexPath.row == 4){
        
        inputTextFieldVC.VCTitle  = @"用户年龄";
        inputTextFieldVC.inputTag = 4;
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        int remainSecond =[[newDict[@"content"] stringByTrimmingCharactersInSet:nonDigits] intValue];
        inputTextFieldVC.defaultStr = [NSString stringWithFormat:@"%d",remainSecond];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 5){
        
        _selectAddressView.hidden = NO;
        
    }else if(indexPath.row == 6){
        
        inputTextFieldVC.VCTitle  = @"详细地址";
        inputTextFieldVC.inputTag = 6;
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 7){
        
        inputTextFieldVC.VCTitle  = @"个性签名";
        inputTextFieldVC.inputTag = 7;
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
    }else if(indexPath.row == 8){
        
        inputTextFieldVC.VCTitle  = @"乐器琴龄";
        inputTextFieldVC.inputTag = 8;
        NSMutableDictionary * newDict = [_userInfoArr[indexPath.row - 1] mutableCopy];
        inputTextFieldVC.defaultStr = newDict[@"content"];
        [self.navigationController pushViewController:inputTextFieldVC animated:YES];
        
        
    }else if(indexPath.row == 9){
        
        //弹出类别选择窗口
        MusicCategoryPopView * musicCategoryPopView =  [[MusicCategoryPopView alloc] initWithFrame:CGRectMake(0,0,D_WIDTH,D_HEIGHT)];
        musicCategoryPopView.delegate = self;
        [self.navigationController.view addSubview:musicCategoryPopView];
        
        
    }
    
    
}

-(void)addVideClick {
    
    UIAlertController *videoAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择视频" preferredStyle: UIAlertControllerStyleActionSheet];
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

-(void)playerVideClick {
    
    NSLog(@"%@",_videoEndUrl);
    
    VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc] init];
    NSString * videoUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER,_videoEndUrl];
    videoPlayerVC.videoUrl = videoUrl;
    videoPlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoPlayerVC animated:YES completion:nil];

    
}


- (void)videoSelectURL:(NSURL *)url thumbnailImage:(UIImage *)image {
    
    _videoType  = 1;
    
    _videoImage = image;
    
    _videoUrl   = url;
    
    [_tableview reloadData];

    NSString * dir = @"userMakeFriendVideo";
    
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
                        
                        [_updateInfoParams setObject:_videoEndUrl forKey:@"u_audio_url"];
                        
                        
                    }];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }];
    }
    
    
}

//获取类别
-(void)categorySelected:(NSString *)c_name Cid:(NSInteger)c_id {
    
 
    //更改数据源
    NSMutableDictionary * newDict = [_userInfoArr[8] mutableCopy];
    [newDict setValue:c_name forKey:@"content"];
    [_userInfoArr replaceObjectAtIndex:8 withObject:newDict];
    
    NSString * goodInstrument = [NSString stringWithFormat:@"%ld|%@",(long)c_id,c_name];
    [_updateInfoParams setObject:goodInstrument forKey:@"u_good_instrument"];
    
    [_tableview reloadData];

}


//省市区选择代理
-(void)selectLocation:(NSDictionary *)locationDict {
 
    
    NSString * pName = [BusinessEnum getEmptyString:locationDict[@"pName"]];
    NSString * cName = [BusinessEnum getEmptyString:locationDict[@"cName"]];
    NSString * dName = [BusinessEnum getEmptyString:locationDict[@"dName"]];
    NSString * locationStr = [NSString stringWithFormat:@"%@%@%@",pName,cName,dName];
    
    //更改数据源
    NSMutableDictionary * newDict = [_userInfoArr[4] mutableCopy];
    [newDict setValue:locationStr forKey:@"content"];
    [_userInfoArr replaceObjectAtIndex:4 withObject:newDict];
    
    [_updateInfoParams setObject:locationDict[@"pid"] forKey:@"u_province"];
    [_updateInfoParams setObject:locationDict[@"cid"] forKey:@"u_city"];
    [_updateInfoParams setObject:locationDict[@"did"] forKey:@"u_district"];

    [_tableview reloadData];
    
    _selectAddressView.hidden = YES;
}

//性别选择代理
-(void)selectSex:(NSDictionary *)sexDict {
 
    //更改数据源
    NSMutableDictionary * newDict = [_userInfoArr[2] mutableCopy];
    [newDict setValue:sexDict[@"sexStr"] forKey:@"content"];
    [_userInfoArr replaceObjectAtIndex:2 withObject:newDict];
    
    [_updateInfoParams setObject:sexDict[@"sex"] forKey:@"u_sex"];
    
    [_tableview reloadData];
    
    _selectSexView.hidden = YES;
    
}

-(void)uploadHeader {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        AlbumViewController * albumVC = [[AlbumViewController alloc] init];
        albumVC.delegate = self;
        [self presentViewController:albumVC animated:YES completion:nil];
        
        
        
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CameraViewController * albumVC = [[CameraViewController alloc] init];
        albumVC.delegate = self;
        [self presentViewController:albumVC animated:YES completion:nil];
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)albumSelectImage:(UIImage *)image {
    
    [self startActionLoading:@"正在上传头像..."];
    [NetWorkTools uploadImage:@{@"image":image,@"imageDir":@"headerImage"} Result:^(BOOL results, NSString *fileName) {
        
        [self endActionLoading];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!results){
                SHOW_HINT(@"头像上传失败");
                return;
            }
            
            
            _headerPreview.image = image;
            
     
            [_updateInfoParams setObject:fileName forKey:@"u_header_url"];

            
        });
        
        
        
       
    }];
 
    
}

-(void)cameraTakePhoto:(UIImage *)photo {
    
    _headerPreview.image = photo;
}


//数据录入反回通知
-(void)inputResult:(NSNotification *)noti {

    NSDictionary * dictData = noti.userInfo;
    
    //获取当条CELL
    NSInteger indexPathRow  = [dictData[@"inputTag"] integerValue];
    
    NSMutableDictionary * newDict = [_userInfoArr[indexPathRow - 1] mutableCopy];
    [newDict setValue:dictData[@"inputValue"] forKey:@"content"];
    [_userInfoArr replaceObjectAtIndex:(indexPathRow - 1) withObject:newDict];
    
    //团体名称
    if(indexPathRow == 1){
        
        [_updateInfoParams setObject:dictData[@"inputValue"] forKey:@"u_nickname"];
        
    }else if(indexPathRow == 2){
        
        [_updateInfoParams setObject:dictData[@"inputValue"] forKey:@"u_realname"];
        
    }else if(indexPathRow == 4){
        
        [_updateInfoParams setObject:[NSString stringWithFormat:@"%@",dictData[@"inputValue"]] forKey:@"u_age"];
        
    }else if(indexPathRow == 6){

        [_updateInfoParams setObject:dictData[@"inputValue"] forKey:@"u_address"];
        
    }else if(indexPathRow == 7){
        
        [_updateInfoParams setObject:dictData[@"inputValue"] forKey:@"u_sign"];

        
    }else if(indexPathRow == 8){
        
        [_updateInfoParams setObject:dictData[@"inputValue"] forKey:@"u_qin_age"];

    }

    
    //更新数据源
    [_tableview reloadData];
    
    
}

//保存用户信息
-(void)saveUserInfo {
 
    if([_updateInfoParams allKeys].count <= 0){
        
        SHOW_HINT(@"您未修改任何资料");
        return;
        
    }
    
    //更新用户信息
    [_updateInfoParams setObject:@([UserData getUserId]) forKey:@"u_id"];
    
    
    
    NSLog(@"%@",_updateInfoParams);
    
    [self startActionLoading:@"正在更新用户资料..."];
    [NetWorkTools POST:API_USER_UPDATE_INFO params:_updateInfoParams successBlock:^(NSArray *array) {
            [self endActionLoading];
            SHOW_HINT(@"用户信息更新成功");
        
    
        } errorBlock:^(NSString *error) {
            [self endActionLoading];
            SHOW_HINT(@"用户信息更新失败");
        }];
}

//-(void)backViewClick {
//    NSLog(@"123123123");
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认操作" message:@"发现您未保存编辑信息，需要保存吗？" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
@end
