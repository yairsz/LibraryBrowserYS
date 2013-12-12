//
//  LBViewController.h
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/11/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreData/Coredata.h>

@interface LBViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *currentFetchRequest;
@property (strong, nonatomic) NSEntityDescription *currentEntity;
@property (strong, nonatomic) NSPredicate *currentPredicate;
@property (strong,nonatomic) NSString * selectedLibraryName;
@property (strong,nonatomic) NSString * selectedShelfNumber;

@end
