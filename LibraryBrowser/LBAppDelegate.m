//
//  AppDelegate.m
//  TweetXplorer
//
//  Created by Yair Szarf on 9/5/12.
//  Copyright (c) 2012 Yair Szarf. All rights reserved.
//

#import "LBAppDelegate.h"
#import "LBViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

@interface LBAppDelegate ()

@property (readwrite, strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@end

@implementation LBAppDelegate

- (void)initializeDatabase

{
    //Here I need to create the dummy database of libraries from a JSON file
    
    NSString *JSONFilePath = [[NSBundle mainBundle] pathForResource:@"librariesDatabase" ofType:@"json"];
    NSError *readJsonError = nil;
    NSDictionary * librariesDict = [NSJSONSerialization
                            JSONObjectWithData:[NSData dataWithContentsOfFile:JSONFilePath]
                            options:kNilOptions
                            error:&readJsonError];
    
    if(!librariesDict) {
        NSLog(@"Could not read JSON file: %@", readJsonError);
    }
    
    for (NSString * libraryNameKey in librariesDict) {
        NSDictionary * shelvesDict = [librariesDict objectForKey:libraryNameKey];
        Library * library = [NSEntityDescription insertNewObjectForEntityForName:@"Library" inManagedObjectContext:self.managedObjectContext];
        library.name = libraryNameKey;
        
        NSMutableArray * shelvesArrayCD = [[NSMutableArray alloc]init];
        
        for (NSString * shelfNumberKey in shelvesDict) {
            NSArray * booksArray = [shelvesDict objectForKey:shelfNumberKey];
            Shelf * shelf = [NSEntityDescription insertNewObjectForEntityForName:@"Shelf" inManagedObjectContext:self.managedObjectContext];
            shelf.number = shelfNumberKey;
            shelf.atLibrary = library;
            [shelvesArrayCD addObject:shelf];
            
            NSMutableArray * booksArrayCD = [[NSMutableArray alloc]init];
            
            for (NSDictionary * bookDict in booksArray) {
                Book * book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
                book.title = [bookDict objectForKey:@"title"];
                book.author = [bookDict objectForKey:@"author"];
                book.atShelf = shelf;
                book.atLibrary = library;
                [booksArrayCD addObject:book];
            }
            shelf.books = [[NSOrderedSet alloc]initWithArray:booksArrayCD];
        }
        library.shelves = [[NSOrderedSet alloc]initWithArray:shelvesArrayCD];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self initializeDatabase];
    // Override point for customization after application launch.

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    LBViewController * controller = (LBViewController *) navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.*/
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void) saveContext {
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LibraryModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LibraryModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
