//
//  LBViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "LBViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

#define ENTITY @"Library"
#define SORT_KEY @"name"

@interface LBViewController ()



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get Name of library and set that to the nextPredicate
    Library * library = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedLibraryName = library.name;
    [self performSegueWithIdentifier:@"libraryToShelves" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LBViewController * nextController = segue.destinationViewController;
    nextController.managedObjectContext = self.managedObjectContext;
    nextController.selectedLibraryName = self.selectedLibraryName;
}




- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Library * aLibrary = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = aLibrary.name;
}


#pragma mark - Fetched Results Controller

- (NSFetchRequest *) currentFetchRequest {
    if (_currentFetchRequest == nil) {
        _currentFetchRequest = [[NSFetchRequest alloc] init];
        [_currentFetchRequest setEntity:[self getEntityDescription]];
        [_currentFetchRequest setPredicate:self.currentPredicate];
        [self.currentFetchRequest setFetchBatchSize:20]; // set the batch size
    }
        return _currentFetchRequest;
}

- (NSEntityDescription *) getEntityDescription {
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSArray *sortDescriptors = [NSArray arrayWithObjects:[self getSortDescriptor], nil];
    [self.currentFetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.currentFetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;

}

- (NSSortDescriptor *) getSortDescriptor {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
    return sortDescriptor;
}



@end
