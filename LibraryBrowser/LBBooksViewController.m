//
//  LBBooksViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "LBBooksViewController.h"
#import "CRUDViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"


#define ENTITY @"Book"
#define SORT_KEY @"title"

@interface LBBooksViewController ()

@property (strong,nonatomic) Book * selectedBook;

@end

@implementation LBBooksViewController

#pragma mark - VIEW LIFECYCLE
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"Shelf No: %@",self.selectedShelfNumber];
    
    //setup the predicate for the new fetched results using a block
    
    self.currentPredicate = [NSPredicate predicateWithBlock:^BOOL(Book * book, NSDictionary *bindings) {
        return (self.selectedLibraryName == book.atLibrary.name) && (self.selectedShelfNumber == book.atShelf.number);
    }];

}


- (void) viewWillAppear:(BOOL)animated {
    // The fetched results controller needs to be reset to reflect the changes from the CRUD controller, also reload the table
    
    self.fetchedResultsController = nil;
    NSError * error = nil;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
}

#pragma mark - UI TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book * book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedBook = book;
    [self performSegueWithIdentifier:@"booksToBook" sender:self];
    // This method must be called in order to pass the necessary data to the CRUD VC
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Book * aBook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = aBook.title;
    cell.detailTextLabel.text = aBook.author;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass all necessary data to the CRUD VC
    
    CRUDViewController * nextViewCOntroller = segue.destinationViewController;
    nextViewCOntroller.selectedBook = self.selectedBook;
    nextViewCOntroller.selectedShelf = self.selectedShelf;
    nextViewCOntroller.selectedLibrary = self.selectedLibrary;
    nextViewCOntroller.managedObjectContext = self.managedObjectContext;
}



#pragma mark - Fetched Results Controller

//Overriding these two methods was very easy thanks to modularization and the use of #define

- (NSEntityDescription *) getEntityDescription {
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSSortDescriptor *) getSortDescriptor {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
    return sortDescriptor;
}

@end
