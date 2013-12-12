//
//  LBShelvesViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "LBShelvesViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

#define ENTITY @"Shelf"
#define SORT_KEY @"number"

@interface LBShelvesViewController ()

@end

@implementation LBShelvesViewController

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
	// Do any additional setup after loading the view.
    self.currentPredicate = [NSPredicate predicateWithBlock:^BOOL(Shelf * shelf, NSDictionary *bindings) {
        return (self.selectedLibraryName == shelf.atLibrary.name);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get Name of library and set that to the nextPredicate
    Shelf * shelf = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedShelfNumber = shelf.number;
    [self performSegueWithIdentifier:@"shelvesToBooks" sender:self];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Shelf * aShelf = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Shelf No.: %@",aShelf.number];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LBViewController * nextController = segue.destinationViewController;
    nextController.managedObjectContext = self.managedObjectContext;
    nextController.selectedLibraryName = self.selectedLibraryName;
    nextController.selectedShelfNumber = self.selectedShelfNumber;
}

#pragma mark - Fetched Results Controller


- (NSEntityDescription *) getEntityDescription {
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSSortDescriptor *) getSortDescriptor {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
    return sortDescriptor;
}


@end
