//
//  TagViewController.m
//  AXASDK
//
//  Created by AXAET_APPLE on 15/7/15.
//  Copyright (c) 2015年 axaet. All rights reserved.
//

#import "TagViewController.h"

#import "DetailViewController.h"

@interface TagViewController () <AXATagManagerDelegate>
@property (nonatomic, strong) NSMutableArray *bleDevices;
@property (nonatomic, strong) NSArray *sortedDevices;

@property (nonatomic, strong) DetailViewController *detailViewController;

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tag List";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"update" style:UIBarButtonItemStylePlain target:self action:@selector(pressLeftBar)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    self.bleDevices = [[NSMutableArray alloc] init];
    self.sortedDevices = [[NSArray alloc] init];
    
    self.detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
}

- (void)viewWillAppear:(BOOL)animated {
    [AXABeaconManager sharedManager].tagDelegate = self;
    [[AXABeaconManager sharedManager] startFindBleDevices];
}

- (void)viewWillDisappear:(BOOL)animated {
    [AXABeaconManager sharedManager].tagDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - press leftBar 

- (void)pressLeftBar {
    [self.bleDevices removeAllObjects];
    self.sortedDevices = nil;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tag"];
    
    AXABeacon *beacon = [[AXABeacon alloc] init];
    beacon = [self.sortedDevices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"name: %@", beacon.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"rssi: %@", [beacon.rssi stringValue]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AXABeacon *beacon = [self.sortedDevices objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    self.detailViewController.beacon = beacon;
}

#pragma mark - delegate

- (void)didDiscoverBeacon:(AXABeacon *)beacon {
    AXABeacon *temp = [self findBeaconWithBeacon:beacon inArray:self.bleDevices];
    if (temp) {
        int index = (int)[self.bleDevices indexOfObject:temp];
        [self.bleDevices replaceObjectAtIndex:index withObject:beacon];
    }
    else {
        [self.bleDevices addObject:beacon];
    }

    self.sortedDevices = [self.bleDevices sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AXABeacon *beacon1 = obj1;
        AXABeacon *beacon2 = obj2;
        return [beacon2.rssi compare:beacon1 .rssi];
    }];

    [self.tableView reloadData];
}

//- (void)didConnectBeacon:(AXABeacon *)beacon {
//    NSLog(@"%@", beacon.name);
//}
//
//- (void)didDisconnectBeacon:(AXABeacon *)beacon {
//    NSLog(@"%@", beacon.name);
//}
//
//- (void)didGetProximityUUIDForBeacon:(AXABeacon *)beacon {
//    NSLog(@"uuid: %@", beacon.proximityUUID);
//}
//
//- (void)didGetMajorMinorPowerAdvInterval:(AXABeacon *)beacon {
//    NSLog(@"major: %@ minor: %@ power: %@ advInterval: %@", beacon.major, beacon.minor, beacon.power, beacon.advInterval);
//}
//
//- (void)didWritePassword:(BOOL)correct {
//    NSLog(@"%d", correct);
//}

#pragma mark - private 


- (AXABeacon *) findBeaconWithBeacon:(AXABeacon *)beacon inArray:(NSMutableArray *)array {
    for (AXABeacon *temp in array) {
        if ([temp.uuidString isEqualToString:beacon.uuidString]) {
            return temp;
        }
    }
    return nil;
}

@end
