//
//  SettingViewController.m
//  SoundShare
//
//  Created by steven on 12/5/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import "SettingViewController.h"
#import "Utility.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NotifyRefresh:)
                                                 name:NotificationNeedRefresh
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self
												   name:NotificationNeedRefresh
												 object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if ( 0 == indexPath.section && 0 == indexPath.row) {
        static NSString *CellIdentifier = @"SocialCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SocialCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton* sinaImageBtn = (UIButton*)[cell viewWithTag:1];
        if ([Utility GetInstance].isWeiboAvailable) {
            [sinaImageBtn setImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateNormal];
        }
        else{
            [sinaImageBtn setImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateNormal];
        }
        [sinaImageBtn addTarget:self action:@selector(sinaPressed) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"0.0.1";
    }
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Social Account";
    }
    if (section == 1)
    {
        return @"Version";
    }
    
    return 0;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            [[Utility GetInstance].sinaweibo logOut];
        }
    }
}

#pragma mark - 

- (IBAction)Done:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sinaPressed{
    if ([Utility GetInstance].isWeiboAvailable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:[NSString stringWithFormat:@"Do you want to unbind sina account?"]
                                                           delegate:self cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        alertView.tag = 0;
        [alertView show];
    }
    else{
        [[Utility GetInstance].sinaweibo logIn];
    }
}

- (void)NotifyRefresh:(NSNotification *)notification{
    [self.tableView reloadData];
}

@end
