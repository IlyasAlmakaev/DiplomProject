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

static NSString *const BaseURLString = @"http://diplomproject.esy.es/info.json";

@interface MaterialViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameMaterialField;
@property (weak, nonatomic) IBOutlet UITextField *countMaterialField;
@property (weak, nonatomic) IBOutlet UIButton *getMaterial;
- (IBAction)getInfoFromSite:(id)sender;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getInfoFromSite:(id)sender
{
    NSString *string = BaseURLString;
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSArray *materials = [dic objectForKey:@"material_info"];
        NSString *m = [materials objectAtIndex:0];
        NSLog(@"%@", m);
        int count = 0;
        
        MaterialData *materialAdd = [NSEntityDescription insertNewObjectForEntityForName:@"MaterialData"
                                                                  inManagedObjectContext:self.appD.managedOCMaterial];
        
        for(NSDictionary *dict in [dic objectForKey:@"material_info"])
        {
            if (count==2)
            {
                NSString *nname = [dict valueForKey:@"materialName"];
                NSLog(@"%@", nname);
            }
            count++;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"not up");
    }];
    [operation start];
/*    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSArray *name = [dic objectForKey:@"material_info"];
        NSArray *count = [dic objectForKey:@"materialCount"];
        
        MaterialData *materialAdd = [NSEntityDescription insertNewObjectForEntityForName:@"MaterialData"
                                                                  inManagedObjectContext:self.appD.managedOCMaterial];
        
        for(int i=0; i==name.count; i++)
        {
            NSLog(@"%@", [name objectAtIndex:i]);
            materialAdd.nameMaterial = [name objectAtIndex:i];
            materialAdd.countMaterial = [count objectAtIndex:i];
        }
         NSLog(@"update");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"update");
    }];*/
}
@end
