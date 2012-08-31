//
//  DiaryStore.m
//  DearDiary
//
//  Created by Stephanie Shupe on 8/30/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "DiaryStore.h"
#import "Entry.h"
#import <CoreData/CoreData.h>

NSManagedObjectContext *diaryContext;
NSManagedObjectModel *diaryModel;

@interface DiaryStore()
+ (NSManagedObjectContext*)context;
+ (NSManagedObjectModel*)model;
@end


@implementation DiaryStore

+ (NSManagedObjectModel*)model
{
    if (!diaryModel) {
        diaryModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return diaryModel;
}

+ (NSManagedObjectContext*)context
{
     // Set up the location of where CoreData will save data
    if (!diaryContext) {
        // Grab an array of available locations to save
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Just use the first location available
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        
        NSURL *storeURL = [NSURL fileURLWithPath:[documentDirectory stringByAppendingString:@"diaryStore.data"]];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[DiaryStore model]];
        
        NSError *err;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&err]) {
            [NSException raise:@"Open failed!" format:@"Reason: %@", [err localizedDescription]];
        } else {
            diaryContext = [NSManagedObjectContext new];
            [diaryContext setPersistentStoreCoordinator:psc];
            
            // Allows for the context to undo saved actions etc
            [diaryContext setUndoManager:nil];
        }
    }
    return diaryContext;
}

+ (NSArray *)allEntries
{
    NSFetchRequest *req = [NSFetchRequest new];
    req.entity = [[DiaryStore model].entitiesByName objectForKey:@"Entry"];
    
    NSError *err;
    NSArray *result = [[DiaryStore context] executeFetchRequest:req error:&err];
    
    if (!result) {
        [NSException raise:@"Fetch failed!" format:@"Reason: %@", [err localizedDescription]];
    }
    
    return result;
}

+ (Entry*)createEntry
{
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:[DiaryStore context]];
    return newEntry;
}

+ (void)save
{
    NSError *err;
    if (![[DiaryStore context] save:&err]) {
        [NSException raise:@"Save Failed!" format:@"Reason: %@", [err localizedDescription]];
    }
}

@end
