//
//  DiaryStore.h
//  DearDiary
//
//  Created by Stephanie Shupe on 8/30/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Entry;

@interface DiaryStore : NSObject
+(NSArray*)allEntries;
+(Entry*)createEntry;
+(void)save;
@end
