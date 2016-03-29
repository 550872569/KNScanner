//
//  KNScannerController.h
//  KNScanner
//
//  Created by LuKane on 16/2/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FROMWHERE){
    FORMHOME,
    FORMREPORT,
};

typedef void(^ScannerBlock)(NSString *content);


@interface KNScannerController : UIViewController

@property (nonatomic,weak) id scanedDelegate;

@property (assign, nonatomic) FROMWHERE cFrom;

@property (nonatomic, copy) ScannerBlock scannerBlock; // block 回调扫描的内容

@end

@protocol ScanedQRCodeActionDelegate <NSObject>

- (void)scanedQRCodeForString:(NSString *)stringValue;

@end