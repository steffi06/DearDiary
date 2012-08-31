//
//  DiaryTableViewController.m
//  DearDiary
//
//  Created by Stephanie Shupe on 8/30/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "DiaryTableViewController.h"
#import "CreateEntryViewController.h"
#import "DiaryStore.h"
#import "Entry.h"

@interface DiaryTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DiaryTableViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Dear Diary";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Make the create button
    UIBarButtonItem *createEntryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createEntry)];
    self.navigationItem.leftBarButtonItem = createEntryButton;
    
    // Set table delegate/data source in XIB file :)
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) createEntry
{
    CreateEntryViewController *createController = [CreateEntryViewController new];
    createController.currentEntry = [DiaryStore createEntry];

    // push the create entry controller
    [self.navigationController pushViewController:createController animated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [DiaryStore allEntries].count;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Today";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DiaryStore allEntries].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Entry"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Entry"];
    }
    
    Entry *entry = [[DiaryStore allEntries] objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.title;
    cell.imageView.image = [UIImage imageWithData:entry.photoData];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateEntryViewController *entryVC = [CreateEntryViewController new];
    entryVC.currentEntry = [[DiaryStore allEntries] objectAtIndex: indexPath.row];
    //entryVC.currentEntry = [DiaryStore createEntry];
    [self.navigationController pushViewController:entryVC animated:YES];
}

@end
