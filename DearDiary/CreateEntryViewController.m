//
//  CreateEntryViewController.m
//  DearDiary
//
//  Created by Stephanie Shupe on 8/30/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "CreateEntryViewController.h"
#import "Entry.h"
#import "DiaryStore.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

@interface CreateEntryViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *entryImageView;
@property (weak, nonatomic) IBOutlet UITextField *entryTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *entryContentsTextView;
- (IBAction)saveEntry:(id)sender;

@end

@implementation CreateEntryViewController
@synthesize entryImageView = _entryImageView;
@synthesize entryTitleTextField = _entryTitleTextField;
@synthesize entryContentsTextView = _entryContentsTextView;
@synthesize currentEntry = _currentEntry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Set input delegates
    self.entryTitleTextField.delegate = self;
    self.entryContentsTextView.delegate = self;
    
    // Add camera button
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonPressed)];
    self.navigationItem.rightBarButtonItem = cameraButton;
       
    // Add border to imageView
    [self.entryImageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.entryImageView.layer setBorderWidth:1.0];

    // Add border to textView
    [self.entryContentsTextView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.entryContentsTextView.layer setBorderWidth:1.0];
        
    self.entryImageView.image = [UIImage imageWithData:self.currentEntry.photoData];
    self.entryContentsTextView.text = self.currentEntry.content;
    self.entryTitleTextField.text = self.currentEntry.title;
}

- (void)viewDidUnload
{
    [self setEntryImageView:nil];
    [self setEntryTitleTextField:nil];
    [self setEntryContentsTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.entryContentsTextView resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cameraButtonPressed
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
   
    if (![UIImagePickerController isSourceTypeAvailable:imagePickerController.sourceType]) {
        UIAlertView *sourceNotAvailableAlertView = [[UIAlertView alloc]
                                                    initWithTitle:@"Error"
                                                    message:@"Photo source not available"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil,
                                                    nil];
        [sourceNotAvailableAlertView show];
    }
    
    imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.entryImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveEntry:(id)sender {
  
    // Set the attributes of this diary entry
    self.currentEntry.title = self.entryTitleTextField.text;
    self.currentEntry.content = self.entryContentsTextView.text;
    self.currentEntry.date = [NSDate date];
    //newEntry.photo = self.entryImageView.image;
    self.currentEntry.photoData = UIImageJPEGRepresentation(self.entryImageView.image,0.5);
            
    // Use the EntryStore CoreData object to save the entry
    [DiaryStore save];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end




