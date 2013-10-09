//
//  EbookListViewController.m
//  pilot
//
//  Created by Sencho Kong on 13-2-4.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "EbookListViewController.h"
#import "PDFDocumentsViewController.h"

@interface EbookListViewController ()

@end

@implementation EbookListViewController
@synthesize tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"电子资料";
   
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 主页" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonForBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = buttonForBack;
    [buttonForBack release];
    
    
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    
    self.tableView=[[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped]autorelease];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView.backgroundView = imageView;
    [imageView release];

    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (device_Type == UIUserInterfaceIdiomPad) {
        UIImageView* imageView = nil;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
        self.tableView.backgroundView = imageView;
        [imageView release];
        return YES;
    }else{
        return interfaceOrientation == UIInterfaceOrientationMaskPortrait;
    }
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)configureEbookList:(NSString *)type Title:(NSString*)title{
    PDFDocumentsViewController* pdfViewController=[[PDFDocumentsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    if(type){
        pdfViewController.bookType = type;
        pdfViewController.title=title;
    }else{
        pdfViewController.bookType = nil;
    }
    
    [self.navigationController pushViewController:pdfViewController animated:YES];
    [pdfViewController release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            
            cell.textLabel.text=@"放行标准";
            
            break;
        case 1:
            cell.textLabel.text=@"运行规范";
            break;
        case 2:
            cell.textLabel.text=@"管理手册";
            break;
              default:
            break;
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            [self configureEbookList:@"FLY" Title:@"放行标准"];
            break;
        case 1  :
            [self configureEbookList:@"RUN" Title:@"运行规范"];
            break;
        case 2  :
            [self configureEbookList:@"MAG" Title:@"管理手册"];
            break;
            
        default:
            break;
    }
    
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

@end
