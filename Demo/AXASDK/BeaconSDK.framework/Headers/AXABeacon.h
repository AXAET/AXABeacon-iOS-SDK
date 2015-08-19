//
//  AXABeacon.h
//  AXASDK
//
//  Created by AXAET_APPLE on 15/7/15.
//  Copyright (c) 2015年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import CoreLocation;
@interface AXABeacon : NSObject

/**
 *  peripheral
 *
 *    代表一个周边设备，用于蓝牙连接.
 */
@property (nonatomic, strong)   CBPeripheral*           peripheral;

/**
 *  uuidString
 *
 *  Discussion:
 *    beacon设备的物理地址.可以唯一标识Beacon设备
 */
@property (nonatomic, strong)   NSString*               uuidString;

/**
 *  name
 *
 *    beacon设备名.
 *
 */
@property (nonatomic, strong)   NSString*               name;

/**
 *  rssi
 *
 *    beacon的接收信号强度指示（Received Signal Strength Indicator）以分贝为单位.
 *    该值是根据本次beacon发射的信号所收集到样本的平均值.
 *
 */
@property (nonatomic)           NSNumber               *rssi;

/**
 *  isConnectable
 *
 *   beacon设备是否可以连接 YES can connect
 */
@property (nonatomic)           BOOL            isConnectable;


/////////////////////////////////////////////////////
// 通过蓝牙连接，读取的属性

/// @name 连接之后属性可用

/**
 *  proximityUUID
 *
 *    beacon设备的UUID，可以用作区域标识
 *
 */
@property (nonatomic, strong)   NSString*                 proximityUUID;

/**
 *  major
 *
 *    设备的主要属性值，可以用作区域标识
 *
 * Discussion:
 * 注意该值在用于区域标识
 */
@property (nonatomic, strong)   NSString*               major;

/**
 *  minor
 *
 *    设备的次要属性值。可以用作区域标识，类同Major
 *
 * Discussion:
 * 注意该值在用于区域标识
 */
@property (nonatomic, strong)   NSString*               minor;

/**
 *  power
 *
 *  以分贝计的发射功率，连接后可用
 *  TI芯片：0：-23dBm 1：-6dBm 2：0dBm
 */
@property (nonatomic, strong)   NSString*           power;

/**
 *  advInterval
 *
 *    广播发射间隔，值范围100ms~10000ms,连接后可用
 */
@property (nonatomic, strong)   NSString*               advInterval;

@end
