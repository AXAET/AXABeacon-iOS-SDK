//
//  AXABeaconManager.h
//  AXASDK
//
//  Created by AXAET_APPLE on 15/7/15.
//  Copyright (c) 2015年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class AXABeacon;
@class AXABeaconManager;

@protocol AXABeaconManagerDelegate <NSObject>

@optional

/**
 * 范围扫描触发的回调方法
 * 检索出所有的beacon设备，每个设备都是一个CLBeacon实例.
 *
 * @param beacons 所有的beacon设备，即CLBeacon实体
 * @param region Beacon 区域
 *
 * @return void
 */
- (void)didRangeBeacons:(NSArray *)beacons
             inRegion:( CLBeaconRegion *)region;

/**
 * 范围扫描失败触发的回调方法，已经关联的错误信息
 *
 * @param region Beacon 区域
 * @param error 错误信息
 *
 * @return void
 */
-(void)rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
           withError:(NSError *)error;

/**
 * 在调用startMonitoringForRegion:方法，当beacon区域状态变化会触发该方法
 *
 * @param region Beacon 区域
 *
 * @return void
 */
-(void)didStartMonitoringForRegion:(CLRegion *)region;

/**
 *
 * 区域监听失败触发的回调方法，以及关联的错误信息
 *
 * @param region Beacon 区域
 * @param error 错误信息
 *
 * @return void
 */
-(void)monitoringDidFailForRegion:(CLRegion *)region
           withError:(NSError *)error;

/**
 *
 * 在区域监听中，iOS设备进入beacon设备区域触发该方法
 *
 * @param region Beacon 区域
 *
 * @return void
 */
-(void)didEnterRegion:(CLRegion *)region;

/**
 *
 * 在区域监听中，iOS设备离开beacon设备区域触发该方法
 *
 * @param region Beacon 区域
 *
 * @return void
 */
-(void)didExitRegion:(CLRegion *)region;

@end

@protocol AXATagManagerDelegate <NSObject>


@optional
#pragma mark - CoreBlueTooth

/**
 * 在该区域使用CoreBluetooth framework发现AXABeacon将回调该方法
 *
 * @param beacon AXABeacon 实体
 *
 * @return void
 */
- (void)didDiscoverBeacon:(AXABeacon *)beacon;

/**
 * 在该区域使用CoreBluetooth framework 连接上AXABeacon将回调该方法
 *
 * @param beacon AXABeacon 实体
 *
 * @return void
 */
- (void)didConnectBeacon:(AXABeacon *)beacon;

/**
 * 在该区域使用CoreBluetooth framework 断开AXABeacon将回调该方法
 *
 * @param beacon AXABeacon 实体
 *
 * @return void
 */
- (void)didDisconnectBeacon:(AXABeacon *)beacon;

/**
 * 在该区域使用CoreBluetooth framework read AXABeacon将回调该方法
 *
 * @param beacon AXABeacon 实体
 *
 * @return void
 */
- (void)didGetProximityUUIDForBeacon:(AXABeacon *)beacon;

/**
 * 在该区域使用CoreBluetooth framework read AXABeacon将回调该方法
 *
 * @param beacon AXABeacon 实体
 *
 * @return void
 */
- (void)didGetMajorMinorPowerAdvInterval:(AXABeacon *)beacon;

/**
 * 在该区域使用CoreBluetooth framework write password to AXABeacon将回调该方法
    
 
 *
 * @param beacon AXABeacon 实体
 *
 * @return void
 */
- (void)didWritePassword:(BOOL)correct;

#pragma mark - add in version 1.2
- (void)didModifyPasswordRight;

@end

@interface AXABeaconManager : NSObject
@property (nonatomic) id<AXABeaconManagerDelegate> beaconDelegate;
@property (nonatomic) id<AXATagManagerDelegate> tagDelegate;

+ (AXABeaconManager *)sharedManager;

/**
 * 范围扫描所有的可见的 Beacon设备.
 * 检索 Beacon设备，通过回调函数beaconManager:didRangeBeacons:inRegion:
 * 返回一个NSArray包含的
 * AXABeacon 对象。
 *
 * @param region beacon 区域
 *
 * @return void
 */
-(void)startRangingBeaconsInRegion:(CLBeaconRegion *)region;

/**
 * 开始监测区域Start monitoring for particular region.
 * 该功能在后台也能够工作.
 * 只要你进入或者离开区域，都会回调: beaconManager:didEnterRegtion:
 * 或 beaconManager:didExitRegion:
 *
 * @param region beacon 区域
 *
 * @return void
 */
-(void)startMonitoringForRegion:(CLRegion *)region;

/**
 * 停止范围扫描 Bright beacon设备.
 *
 * @param region beacon 区域
 *
 * @return void
 */
-(void)stopRangingBeaconsInRegion:(CLBeaconRegion *)region;

/**
 * 注销程序iOS区域检测
 *
 * @param region beacon region
 *
 * @return void
 */
-(void)stopMonitoringForRegion:(CLRegion *)region;


/// @name 转换设备为 iBeacon

/**
 * 设备模拟成 iBeacon.可以使用检测状态[[BRTBeaconSDK BRTBeaconManager] isAdvertising]
 *
 * @param proximityUUID beacon设备UUID String值
 * @param major beacon设备major值
 * @param minor beacon设备minor值
 * @param identifier 唯一的区域标识
 * @param power 测量功率（1米处的RSSI值）
 *
 * @return void
 */
-(void)startAdvertisingWithProximityUUID:(NSString *)proximityUUID
                                   major:(CLBeaconMajorValue)major
                                   minor:(CLBeaconMinorValue)minor
                              identifier:(NSString*)identifier
                                   power:(NSNumber *)power;
/**
 * 是否正在模拟beacon广播
 *
 * @return BOOL
 */
-(BOOL)isAdvertising;

/**
 * 停止模拟beacon广播
 *
 * @return void
 */
-(void)stopAdvertising;

/**
 *  获取定位权限：允许后台定位，可以支持后台区域推送，网络数据传输等
 * 
 *  需要在plist 文件里面添加NSLocationAlwaysUsageDescription key
 */
- (void)requestAlwaysAuthorization;

/**
 *  获取定位权限：只允许APP运行期间定位，不支持后台区域感知
 *  
 *  需要在plist 文件里面添加NSLocationWhenInUseUsageDescription key
 */
- (void)requestWhenInUseAuthorization;


#pragma mark - CoreBluetooth

// scan ble device
- (void)startFindBleDevices;

// stop scan ble device
- (void)stopFindBleDevices;

// connect ble device
- (void)connectBleDevice:(AXABeacon *)beacon;

// disconnect ble device
- (void)disconnectBleDevice:(AXABeacon *)beacon;

// send  proximityUUID value to ble device
- (void)writeProximityUUID:(NSString *)proximityUUID;

// send value to ble device
- (void)writeMajor:(NSString *)major withMinor:(NSString *)minor withPower:(NSString *)power withAdvInterval:(NSString *)advInterval;

#pragma mark - add in version 1.1
// send  name value to ble device
- (void)writeName:(NSString *)name;

// send  password value to ble device, enter - (void)didWritePassword:(BOOL)correct;
- (void)writePassword:(NSString *)password;

// send  reset commond value to ble device
- (void)resetDevice;

#pragma mark - add in version 1.2
//send change password which must be length of six, right will return none. no will enter - (void)didWritePassword:(BOOL)correct;
- (void)writeModifyPassword:(NSString *)originPsw newPSW:(NSString *)newPsw;

@end
