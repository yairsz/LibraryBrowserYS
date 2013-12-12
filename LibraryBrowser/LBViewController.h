//
//  LBViewController.h
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

// This is the parent View Controller class, two other classes will inherit from it. Most of the delegate methods for UITableView,
// It conforms to three protocols the UIView Delegate, UI Table View Data Source and the Fetched results Controller delegate.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreData/Coredata.h>
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

@interface LBViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

// Properties used for core data
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *currentFetchRequest;
@property (strong, nonatomic) NSEntityDescription *currentEntity;
@property (strong, nonatomic) NSPredicate *currentPredicate;


//this class and all subclasses will need a reference to what the user selects, in case a book is created in the CRUD VC
//The string names of library and and shelf are also stored for convenience

@property (strong, nonatomic) Library * selectedLibrary;
@property (strong, nonatomic) Shelf * selectedShelf;

@property (strong, nonatomic) NSString * selectedShelfNumber;
@property (strong, nonatomic) NSString * selectedLibraryName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
