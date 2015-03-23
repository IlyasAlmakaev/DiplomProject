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
#import "AFNetworking.h"
#import "XMLReader.h"

static NSString *const BaseURLString = @"http://diplomproject.esy.es/materials.xml";

@interface MaterialViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameMaterialField;
@property (weak, nonatomic) IBOutlet UITextField *countMaterialField;
@property (weak, nonatomic) IBOutlet UIButton *getMaterial;
- (IBAction)getInfoFromSite:(id)sender;

@property (strong, nonatomic) AppDelegate *appD;
@property (strong, nonatomic) Common *com;

@property (strong, nonatomic) NSMutableDictionary *xmlMaterial;
@property (strong, nonatomic) NSMutableDictionary *currentDictionary;
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSMutableString *outstring;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    if (self.editMaterial)
    {
        
        [self.nameMaterialField setText:[self.material valueForKey:@"nameMaterial"]];
        [self.countMaterialField setText:[self.material valueForKey:@"countMaterial"]];

//        self.nameMaterialField.placeholder = nil;
    }
    else
    {
        self.nameMaterialField.placeholder = NSLocalizedString(@"NameMaterialField_PlaceHolder", nil);
        self.countMaterialField.placeholder = NSLocalizedString(@"CountMaterialField_PlaceHolder", nil);
    }
}

// Add/Edit material
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
                                                                          inManagedObjectContext:self.appD.managedOCMaterial];
            
                materialAdd.nameMaterial = self.nameMaterialField.text;
                materialAdd.countMaterial = self.countMaterialField.text;
            }
            
            NSError *error = nil;
            NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
        
            if (![self.appD.managedOCMaterial save:&error])
                [self.com showToast:text view:self];
        
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

- (IBAction)getInfoFromSite:(id)sender
{
    NSString *string = BaseURLString;
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    NSError *error = nil;
    
    NSDictionary *dict = [XMLReader dictionaryForXMLData:responseData error:&error];
    
    for(int i=0; i<[[[dict valueForKey:@"materials"] valueForKey:@"material"] count]; i++)
    {
        MaterialData *materialAdd = [NSEntityDescription insertNewObjectForEntityForName:@"MaterialData"
                                                                  inManagedObjectContext:self.appD.managedOCMaterial];

        materialAdd.nameMaterial = [[[[[dict valueForKey:@"materials"] valueForKey:@"material"]objectAtIndex:i] objectForKey:@"name"] objectForKey:@"text"];
        materialAdd.countMaterial = [[[[[dict valueForKey:@"materials"] valueForKey:@"material"]objectAtIndex:i] objectForKey:@"count"] objectForKey:@"text"];
    }
}
@end
