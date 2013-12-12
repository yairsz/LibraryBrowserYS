//
//  CRUDViewController.m
//  LibraryBrowser
//
//  Created by Yair Szarf on 12/12/13.
//  Copyright (c) 2013 Yair Szarf. All rights reserved.
//

#import "CRUDViewController.h"

@interface CRUDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)update:(UIButton *)sender;
- (IBAction)delete:(UIButton *)sender;
- (IBAction)createNew:(UIButton *)sender;

@end

@implementation CRUDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Prepopulate the text fields and message Label. This is the READ part of CRUD
    
    self.titleTextField.text = self.selectedBook.title;
    self.authorTextField.text = self.selectedBook.author;
    self.textLabel.text = @" ";
}


- (IBAction)update:(id)sender {
    
    //This is the UPDATE section of CRUD. The user can change the name of the author or title of a book in the database
    //There is a check to make sure the text fields are not empty
    
    if (![self.titleTextField.text isEqualToString:@""] && ![self.authorTextField.text isEqualToString:@""]) {
        self.selectedBook.title = self.titleTextField.text;
        self.selectedBook.author = self.authorTextField.text;
        self.textLabel.text = [NSString stringWithFormat:@"The book has been updated"];
    } else {
        self.textLabel.text = [NSString stringWithFormat:@"Please type a title and author."];
    }
}

- (IBAction)delete:(UIButton *)sender {
    
    // This is the DELETE section of CRUD. The user is able to delete entries from the database
    
    [self.managedObjectContext deleteObject:self.selectedBook];
    
    self.textLabel.text = [NSString stringWithFormat:@"The book has been deleted"];
}

- (IBAction)createNew:(UIButton *)sender {
    
    // This is the Create a section of CRUD. The user is able to create a new entry in the database by inputing a title and author
    // duplicate entries are allowed. The new book will live in the selected shelf and library
    // There is a check to make sure the text fields are not empty
    if (![self.titleTextField.text isEqualToString:@""] && ![self.authorTextField.text isEqualToString:@""]) {
        Book * book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
        book.title = self.titleTextField.text;
        book.author = self.authorTextField.text;
        [book enshelve:self.selectedShelf];
        book.atLibrary = self.selectedLibrary;
        
        self.textLabel.text = [NSString stringWithFormat:@"The book has been created"];
        self.selectedBook = book;
        
    }else {
        self.textLabel.text = [NSString stringWithFormat:@"Please type a title and author."];
    }
    
    
    
}
@end
