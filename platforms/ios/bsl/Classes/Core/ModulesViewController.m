//
//  ModulesViewController.m
//  Cube
//
//  Created by Justin Yip on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModulesViewController.h"
#import "ModuleCell.h"

@interface ModulesViewController ()

@end

@implementation ModulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.application = [CubeApplication currentApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidUpdate:) name:CubeAppUpdateFinishNotification object:self.application];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void)applicationDidUpdate:(NSNotification*)note
{
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"已安装";
        case 1:
            return @"有更新";
        case 2:
            return @"可安装";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.application.modules count];
        case 1:
            return [self.application.updatableModules count];
        case 2:
            return [self.application.availableModules count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ModuleCell" owner:self options:nil] objectAtIndex:0];
    
    CubeModule *module = nil;
    switch (indexPath.section) {
        case 0:
            module = [self.application.modules objectAtIndex:indexPath.row];
            break;
        case 1:
            module = [self.application.updatableModules objectAtIndex:indexPath.row];
            break;
        case 2:
            module = [self.application.availableModules objectAtIndex:indexPath.row];
            break;
    }
    
    cell.nameLabel.text = module.name;
    cell.versionLabel.text = [NSString stringWithFormat:@"version:%@ build %d", module.version, module.build];
    [cell.iconImageView loadImageWithURLString:module.iconUrl];
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            cell.actionImageView.image = [UIImage imageNamed:@"Module_Action_Update.png"];
            break;
        case 2:
            cell.actionImageView.image = [UIImage imageNamed:@"Module_Action_Install.png"];
            break;
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CubeModule *module = nil;
    switch (indexPath.section) {
        case 0:
           // module = [self.application.modules objectAtIndex:indexPath.row];
            break;
        case 1:
            module = [self.application.updatableModules objectAtIndex:indexPath.row];
            [module install];
            break;
        case 2:
            module = [self.application.availableModules objectAtIndex:indexPath.row];
            [module install];
            break;
    }
}


- (IBAction)didClickSync:(id)sender {
    [self.application sync];
}

- (IBAction)didClickDone:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
