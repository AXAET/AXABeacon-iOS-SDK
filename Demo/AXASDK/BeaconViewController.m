//
//  BeaconViewController.m
//  AXASDK
//
//  Created by AXAET_APPLE on 15/7/15.
//  Copyright (c) 2015年 axaet. All rights reserved.
//

#import "BeaconViewController.h"

@interface BeaconViewController () <AXABeaconManagerDelegate>
@property (nonatomic, strong) NSMutableDictionary *beaconRegions;
@property (nonatomic, strong) NSMutableDictionary *detectBeacons;

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Beacon List";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"] identifier:@"微信"];
    [AXABeaconManager sharedManager].beaconDelegate = self;
    [[AXABeaconManager sharedManager] requestAlwaysAuthorization];
    [[AXABeaconManager sharedManager] startRangingBeaconsInRegion:beaconRegion];
    
    self.beaconRegions = [[NSMutableDictionary alloc] init];
    self.detectBeacons = [[NSMutableDictionary alloc] init];
    
    self.beaconRegions[beaconRegion] = [NSArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.detectBeacons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *sectionValues = [self.detectBeacons allValues];
    return [sectionValues[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Beacon"];
//    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Beacon"];
//    }
    
    NSString *sectionKey = [self.detectBeacons allKeys][indexPath.section];
    CLBeacon *beacon = self.detectBeacons[sectionKey][indexPath.row];
    
    NSString *strings = nil;
    switch (beacon.proximity) {
        case 0:
            strings = @"Unknown";
            break;
        case 1:
            strings = @"Immediate";
            break;
        case 2:
            strings = @"Near";
            break;
        case 3:
            strings = @"Far";
            break;
            
        default:
            break;
    }
    cell.textLabel.text = beacon.proximityUUID.UUIDString;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, Acc: %.2fm %@", beacon.major, beacon.minor, beacon.accuracy, strings];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

#pragma mark - delegate 

- (void)didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    self.beaconRegions[region] = beacons;
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.beaconRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"accuracy != -1"];
//
    NSArray *rights = [allBeacons filteredArrayUsingPredicate:pre];
//
    NSString * str = @"accuracy";
    self.detectBeacons[str] = rights;
    
    [self.tableView reloadData];
}

@end
