//
//  ModelBeaconViewController.m
//  AXASDK
//
//  Created by AXAET_APPLE on 15/7/15.
//  Copyright (c) 2015年 axaet. All rights reserved.
//

#import "ModelBeaconViewController.h"

#define ProximityUUID           @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"
#define Major                   @"1111"
#define Minor                   @"2222"

@interface ModelBeaconViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *uuidTextField;
@property (nonatomic, strong) UITextField *majorTextField;
@property (nonatomic, strong) UITextField *minorTextField;
@property (nonatomic, strong) UIButton *advBtn;

@end

@implementation ModelBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"model"];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(cell.contentView.frame) - 40, CGRectGetHeight(cell.contentView.frame))];
    
    
    
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:textField];
            textField.text = ProximityUUID;
            self.uuidTextField = textField;
            self.uuidTextField.delegate = self;
            
            break;
        case 1:
            [cell.contentView addSubview:textField];
            textField.text = Major;
            self.majorTextField = textField;
            self.majorTextField.delegate = self;
            
            break;
        case 2:
            [cell.contentView addSubview:textField];
            textField.text = Minor;
            self.minorTextField = textField;
            self.minorTextField.delegate = self;
            
            break;
        case 3:
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(cell.contentView.frame) - 40, CGRectGetHeight(cell.contentView.frame))];
            [button addTarget:self action:@selector(handleStartAdv) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor blueColor];
            [button setTitle:@"start advertisement" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:button];
            self.advBtn = button;
        }
            
            break;
            
        default:
            break;
    }
    
    textField.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"proximityUUID";
            break;
        case 1:
            return @"major (0 ~ 65565)";
            break;
        case 2:
            return @"minor (0 ~ 65565)";
            break;
            
        default:
            return @"start advertisement";
            break;
    }
    return nil;
}

#pragma mark - private

- (void)handleStartAdv {
    if ([self.advBtn.backgroundColor isEqual:[UIColor blueColor]]) {
        self.advBtn.backgroundColor = [UIColor greenColor];
    } else {
        self.advBtn.backgroundColor = [UIColor blueColor];
    }
    NSLog(@"%@", self.uuidTextField.text);
    [[AXABeaconManager sharedManager] startAdvertisingWithProximityUUID:self.uuidTextField.text major:[self.majorTextField.text intValue] minor:[self.minorTextField.text intValue] identifier:@"identifier" power:nil];
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
