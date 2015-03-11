//
//  MaterialViewController.m
//  NotifyAlert
//
//  Created by intent on 09/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "MaterialViewController.h"
#import "MaterialData.h"
#import "Common.h"

@interface MaterialViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameMaterialField;
@property (weak, nonatomic) IBOutlet UITextField *countMaterialField;

@property (strong, nonatomic) AppDelegate *appD;
@property (strong, nonatomic) Common *com;

@end

@implementation MaterialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"Material_Title", nil);
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(save)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add/Edit notification
- (void)save
{
    NSString *ErrorString = NSLocalizedString(@"View_Error", nil);
    // Not empty field
    if ((self.nameMaterialField.text && self.nameMaterialField.text.length > 0 &&
         [self.nameMaterialField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0) &&
        (self.countMaterialField.text && self.countMaterialField.text.length > 0
         && [self.countMaterialField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0))
    {
            // Edit material
            if (self.material && self.editMaterial == YES)
            {
                [self.material setValue:self.nameMaterialField.text forKey:@"nameMaterial"];
                [self.material setValue:self.countMaterialField.text forKey:@"countMaterial"];
            }
            // Add new material
            else
            {
                MaterialData *materialAdd = [NSEntityDescription insertNewObjectForEntityForName:@"MaterialData"
                                                                          inManagedObjectContext:self.appD.managedOC];
            
                materialAdd.nameMaterial = self.nameMaterialField.text;
                materialAdd.countMaterial = self.countMaterialField.text;
            }
            
            NSError *error = nil;
            
            if (![self.appD.managedOC save:&error])
                [self.com showToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription]) view:self];
        
        // Dismiss the view controller
        [self performSelector:@selector(back) withObject:nil];
    }
    else
        [self.com showToast:NSLocalizedString(@"Toast_EmptyNameField", nil) view:self];
}

// Exit
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
