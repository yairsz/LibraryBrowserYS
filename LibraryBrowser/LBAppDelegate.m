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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //The next call that will set up the database, it will get remade everytime the app is launched but that could be easily changed
    
    [self initializeDatabase];
    
    // Override point for customization after application launch.
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    LBViewController * controller = (LBViewController *) navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    //This sets up the Managed Object Context for use in all the VC's
    
    return YES;
}



- (void)initializeDatabase

{
    //Here I need to create the dummy database of libraries from a JSON file
    // The File will get serialized and then through some nested loops, all the objects in the initial database will get created
    
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
        
        for (NSString * shelfNumberKey in shelvesDict) {
            NSArray * booksArray = [shelvesDict objectForKey:shelfNumberKey];
            Shelf * shelf = [NSEntityDescription insertNewObjectForEntityForName:@"Shelf" inManagedObjectContext:self.managedObjectContext];
            shelf.number = shelfNumberKey;
            shelf.atLibrary = library;

            for (NSDictionary * bookDict in booksArray) {
                Book * book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
                book.title = [bookDict objectForKey:@"title"];
                book.author = [bookDict objectForKey:@"author"];
                [book enshelve:shelf]; //Using the required enshelve method
                book.atLibrary = library;
            }
        }
    }
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
    //lazy instantiation of the managed object context
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
    //lazy instantiation of the managed object model
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
    
    //Using the In memory data store type to enable predicates with blocks
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {

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
