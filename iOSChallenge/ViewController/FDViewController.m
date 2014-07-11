//
// Created by Alexandre Santana on 10/07/14.
// Copyright (c) 2014 Felipe Docil. All rights reserved.
//

#import "FDViewController.h"
#import "FDNoContentView.h"
#import "KeepLayout.h"
#import "FDModelFacade.h"
#import "FDTableViewController.h"

static NSString *const kURL = @"http://ckl.io/challenge/";
static FDViewController *viewController;

@interface FDViewController ()

@property(nonatomic, strong) FDNoContentView *noContentView;
@property(nonatomic, strong) FDTableViewController *tableViewController;

@end


@implementation FDViewController
@synthesize managedObjectContext = __managedObjectContext;


- (void)loadView
{
    [super loadView];
    [self setTitle:NSLocalizedString(@"JSON_TITLE", nil)];

    viewController = self;
    [FDModelFacade requestWithURL:[NSURL URLWithString:kURL] sender:NSStringFromClass([self class])];


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(organize:)];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:__managedObjectContext];

    [request setEntity:entityDescription];
    NSUInteger count = [__managedObjectContext countForFetchRequest:request error:nil];
    NSLog(@"count: %u", count);

    if (count == 0) {
        self.noContentView = [[FDNoContentView alloc] init];
        [self.noContentView setBackgroundColor:[UIColor whiteColor]];
        [self.noContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.noContentView.delegate = self;
        [self.view addSubview:self.noContentView];
        [self.tableViewController.tableView setHidden:YES];
        NSLog(@"noContentView %@", self.noContentView);
    } else {
        self.tableViewController = [[FDTableViewController alloc] init];
        self.tableViewController.managedObjectContext = __managedObjectContext;

        [self addChildViewController:self.tableViewController];
        [self.view addSubview:self.tableViewController.view];

        CGFloat topInset = [self.topLayoutGuide length];
        [self.tableViewController.view keepInsets:UIEdgeInsetsMake(topInset, 0, 0, 0)];


        [self.tableViewController dataFromDatabase];
    }

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGFloat topInset = [self.topLayoutGuide length];
    NSLog(@"%f, %@", topInset, self.topLayoutGuide);
    [self.noContentView keepInsets:UIEdgeInsetsMake(topInset, 0, 0, 0)];
}


- (void)organize:(id)organize
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"ORGANIZE_TITLE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"AUTHORS", nil), NSLocalizedString(@"DATE", nil), NSLocalizedString(@"TITLE", nil), NSLocalizedString(@"WEBSITE", nil), nil];
    actionSheet.tag = 100;

    [actionSheet showInView:self.view];
}

#pragma mark - FDControllerProtocol

+ (void)receiveError:(NSError *)error
{
    [viewController.noContentView.messageLabel setText:[error localizedDescription]];
}

+ (void)receiveSuccess
{
    [viewController.noContentView removeFromSuperview];
    [viewController.tableViewController.tableView removeFromSuperview];

    viewController.tableViewController = [[FDTableViewController alloc] init];
    viewController.tableViewController.managedObjectContext = viewController.managedObjectContext;

    [viewController addChildViewController:viewController.tableViewController];
    [viewController.view addSubview:viewController.tableViewController.view];

    CGFloat topInset = [viewController.topLayoutGuide length];
    [viewController.tableViewController.view keepInsets:UIEdgeInsetsMake(topInset, 0, 0, 0)];


    [viewController.tableViewController dataFromDatabase];
}


#pragma mark - FDNoContentViewDelegate

- (void)didButtonPressed:(UIButton *)sender
{
    viewController = self;
    [FDModelFacade requestWithURL:[NSURL URLWithString:kURL] sender:NSStringFromClass([self class])];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSSortDescriptor *sortDescriptor;
    NSArray *customSortDescription;

    switch (buttonIndex) {
        case 0:
            //Authors
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"authors" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            self.tableViewController.customSortDescription = customSortDescription;

            break;
        case 1:
            //Date
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            self.tableViewController.customSortDescription = customSortDescription;
            break;
        case 2:
            //Title
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            self.tableViewController.customSortDescription = customSortDescription;
            break;
        case 3:
            //Website
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"website" ascending:YES];
            customSortDescription = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            self.tableViewController.customSortDescription = customSortDescription;
            break;
        default:
            break;
    }
}

@end