//
//  ViewController.m
//  KNScanner
//
//  Created by LuKane on 16/2/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "ViewController.h"

#import "KNScannerController.h"
#import "KNQRCodeView.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    UILabel *_scannerResultLabel;
    
    UITextField *_textField;
    UIImageView *_icon;
    
    UIImage *_QRCodeImg; // 用于生出二维码的图片 ... 从相册或相机中选择
    BOOL _hasImg;
    
    KNQRCodeView *_QRCodeView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /****************************** == 华丽的分割线 == ********************************/
    //  扫描二维码 //
    
    UIButton *presentBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [presentBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [presentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [presentBtn setFrame:CGRectMake(100, self.view.frame.size.height * 0.8, 50, 25)];
    presentBtn.layer.cornerRadius = 3;
    presentBtn.layer.masksToBounds = YES;
    presentBtn.layer.borderWidth = 1;
    presentBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [presentBtn addTarget:self action:@selector(presentSomeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentBtn];
    
    UILabel *scannerResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 ,CGRectGetMaxY(presentBtn.frame) + 20 , self.view.frame.size.width - 20, presentBtn.frame.size.height)];
    scannerResultLabel.textColor = [UIColor redColor];
    _scannerResultLabel = scannerResultLabel;
    [self.view addSubview:_scannerResultLabel];
    /****************************** == 华丽的分割线 == ********************************/
    
    UILabel *fengexian = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 30) * 0.5, self.view.frame.size.width, 30)];
    fengexian.text = @"====== == 华丽的分割线 == ======";
    fengexian.textAlignment = NSTextAlignmentCenter;
    fengexian.textColor = [UIColor greenColor];
    [self.view addSubview:fengexian];
    
    
    /****************************** == 华丽的分割线 == ********************************/
    //  生成二维码 //
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width - 100, 30)];
    textField.textColor = [UIColor greenColor];
    textField.placeholder = @"请输入需要生出二维码的文字";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 0.7;
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    _textField = textField;
    [self.view addSubview:textField];
    
    // 添加的图片
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(textField.frame) + 20, 60, 60)];
    icon.userInteractionEnabled = YES;
    icon.image = [UIImage imageNamed:@"add_images"];
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewIBAction)]];
    [icon addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)]];
    _icon = icon;
    [self.view addSubview:icon];
    
    UIButton *makeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [makeBtn setTitle:@"生成" forState:UIControlStateNormal];
    [makeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [makeBtn setFrame:CGRectMake(CGRectGetMaxX(textField.frame) - 50, CGRectGetMinY(icon.frame) + 15, 50, 25)];
    makeBtn.layer.cornerRadius = 3;
    makeBtn.layer.masksToBounds = YES;
    makeBtn.layer.borderWidth = 1;
    makeBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [makeBtn addTarget:self action:@selector(makeQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeBtn];
}

#pragma mark 取消 键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_QRCodeView removeFromSuperview];
    _QRCodeView = nil;
}

#pragma mark 图片点击
- (void)iconViewIBAction{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark 图片长按
- (void)longPressView:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
    if(longPressGestureRecognizer.state == UIGestureRecognizerStateBegan){
        UIImageView *imageView = (UIImageView *)longPressGestureRecognizer.view;
        imageView.image = [UIImage imageNamed:@"add_images"];
        _hasImg = NO;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (0 == buttonIndex) {  // 拍照模式
        [self openCamera];
    }else if (1 == buttonIndex) {  // 手机相册
        [self openAlbum];
    }
}

- (void)openCamera{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openAlbum{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *resultImage = nil;
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        _icon.image = resultImage;
        _hasImg = YES;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 生成二维码的点击
- (void)makeQRCode{
    
    if(_textField.text.length == 0){
        return;
    }
    UIImage *img;
    
    if(_hasImg){
        img = _icon.image;
    }else{
        img = nil;
    }
    
    KNQRCodeView *qrCodeView = [KNQRCodeView QRCodeViewWithContent:_textField.text image:img frame:CGRectMake(self.view.frame.size.width * 0.5 - 150, self.view.frame.size.height * 0.5 - 150, 300, 300)];
    [qrCodeView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeView:)]];
    _QRCodeView = qrCodeView;
    [self.view addSubview:qrCodeView];
}

// 写入相册
- (void)qrCodeView:(UILongPressGestureRecognizer *)longGestureRecognizer{
    if(longGestureRecognizer.state == UIGestureRecognizerStateBegan){
        UIImageView *imageView = (UIImageView *)longGestureRecognizer.view;
        ALAssetsLibrary *asset = [[ALAssetsLibrary alloc] init];
        [asset writeImageToSavedPhotosAlbum:[imageView.image CGImage] orientation:ALAssetOrientationRight completionBlock:nil];
        
        [_QRCodeView removeFromSuperview];
        _QRCodeView = nil;
    }
}

#pragma mark 去扫描
- (void)presentSomeViewController{
    KNScannerController *scannerVc = [[KNScannerController alloc] init];
    scannerVc.scannerBlock = ^(NSString *content){
        _scannerResultLabel.text = content;
    };
    
    [self.navigationController pushViewController:scannerVc animated:YES];
}

@end
