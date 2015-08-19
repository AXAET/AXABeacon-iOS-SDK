//
//  DetailViewController.h
//  AXASDK
//
//  Created by AXAET_APPLE on 15/7/15.
//  Copyright (c) 2015年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BeaconSDK/BeaconSDK.h>



@interface DetailViewController : UITableViewController
@property (nonatomic, strong) AXABeacon *beacon;

@end
