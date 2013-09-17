//
//  RepositoryManager.h
//  pilot
//
//  Created by chen shaomou on 8/21/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepositoryManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (RepositoryManager *)shareRepositoryManager;

@end
