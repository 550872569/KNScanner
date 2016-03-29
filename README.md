# KNScanner
###1.二维码扫描

实例代码:
```
KNScannerController *scannerVc = [[KNScannerController alloc] init]; // 扫描界面
  scannerVc.scannerBlock = ^(NSString *content){
    _scannerResultLabel.text = content;// 扫描的内容
  };
[self.navigationController pushViewController:scannerVc animated:YES];
```

###2.二维码的生成(如果添加图片,则可以在二维码中心显示图片)
```
    KNQRCodeView *qrCodeView = [KNQRCodeView QRCodeViewWithContent:_textField.text image:img frame:CGRectMake(self.view.frame.size.width * 0.5 - 150, self.view.frame.size.height * 0.5 - 150, 300, 300)];
    [self.view addSubview:qrCodeView];
```
