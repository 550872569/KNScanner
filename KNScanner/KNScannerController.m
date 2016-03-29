//
//  KNScannerController.m
//  KNScanner
//
//  Created by LuKane on 16/2/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNScannerController.h"
#import "KNScannerView.h"
#import <AVFoundation/AVFoundation.h>

@interface KNScannerController ()<AVCaptureMetadataOutputObjectsDelegate>{
    KNScannerView *aScanView;
}

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;

@end

@implementation KNScannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建 相机镜头
    [self setupCamera];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!aScanView){
        aScanView = [[KNScannerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (self.cFrom == FORMHOME) {
            aScanView.aLabel.text = @"自定义扫描";
        }else{
            aScanView.aLabel.text = @"反身扫描";
        }
        [self.view addSubview:aScanView];
    }
    [aScanView toStartAnimation]; // 开始滑动 (中间的绿线)
}

- (void)setupCamera{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc] init];
    // AVCaptureSessionPresetHigh : 高 . AVCaptureSessionPresetMedium:一般 . AVCaptureSessionPresetLow:低
    [self.session setSessionPreset:AVCaptureSessionPresetHigh]; // 设置分辨率
    
    // 添加输入
    if ([self.session canAddInput:self.input]){
        [self.session addInput:self.input];
    }
    // 添加输出
    if ([self.session canAddOutput:self.output]){
        [self.session addOutput:self.output];
    }
    
    // 条码类型:条形码, 二维码 等等
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    //感应区域 :屏幕中间显示 --- 配合 KNScannerView的显示区域
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat ScreenWidth = frame.size.width;
    CGFloat ScreenHigh = frame.size.height;
    [self.output setRectOfInterest:CGRectMake (142/ScreenHigh, ((ScreenWidth - 250)/ 2)/ ScreenWidth, 250 / ScreenHigh, 250 / ScreenWidth)];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:self.preview];
    
    // Start
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [_session stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
    
    if(_scannerBlock){
        _scannerBlock(stringValue?stringValue:@"扫描失败");
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [aScanView removeFromSuperview];
    aScanView = nil;
}

@end
