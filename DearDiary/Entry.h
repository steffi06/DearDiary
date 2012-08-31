//
//  Entry.h
//  DearDiary
//
//  Created by Stephanie Shupe on 8/30/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) UIImage * photo;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSSet * tags;
@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
