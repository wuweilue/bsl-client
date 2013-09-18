//
//  NSManagedObject+Repository.m
//  ComicHunter
//
//  Created by Justin Yip on 9/26/10.
//  Copyright 2010 TenNights.com. All rights reserved.
//

#import "NSManagedObject+Repository.h"
#import "RepositoryManager.h"

@implementation NSManagedObject(Repository)

//retrieve Core Data ManagedObjectContext from appDelegate
+(NSManagedObjectContext*)managedObjectContext {

    return [[RepositoryManager shareRepositoryManager] managedObjectContext];
}

+(id)insert {
	return [NSEntityDescription insertNewObjectForEntityForName:[self description] 
										 inManagedObjectContext:[self managedObjectContext]];
}

+(BOOL)save {
	NSError *error = nil;
	BOOL result = [[self managedObjectContext] save:&error];
	if (!result || error) {
		NSLog(@"save fail, %@", error);
	}
	return result;
}

+(BOOL)deleteAll {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self description] 
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];//only fetch the managedObjectID
	
	NSError *error = nil;
	NSArray *allObjects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	[request release];
	
	for (NSManagedObject *object in allObjects) {
		[[self managedObjectContext] deleteObject:object];
	}
	return [self save];
}

+(NSArray *)findAll{

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self description]
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];//only fetch the managedObjectID
	
	NSError *error = nil;
	NSArray *allObjects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    [request release];
	
    return allObjects;
}

+(id)first:(NSString*)aPredicate, ...
{
    va_list argumentList;
    va_start(argumentList, aPredicate);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:aPredicate arguments:argumentList];
    va_end(argumentList);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self description] 
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	//predicate
	[request setPredicate:predicate];
    
    [request setFetchLimit:1];
	
	NSError *error = nil;
	NSArray *result_objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	[request release];
	
	if (!error && nil != result_objects && [result_objects count] > 0) {
		return [result_objects objectAtIndex:0];
	} else {
		return nil;
	}
}

+(NSArray*)find:(NSString*)aPredicate, ...
{
    va_list argumentList;
    va_start(argumentList, aPredicate);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:aPredicate arguments:argumentList];
    va_end(argumentList);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self description] 
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	//predicate
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *result_objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	[request release];
	
	if (error) {
		NSLog(@"query error, %@", error);
		return nil;
	}
	
	return result_objects;
}

+(id)getByPredicate:(NSPredicate*)aPredicate {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self description] 
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	//predicate
	[request setPredicate:aPredicate];
    
    [request setFetchLimit:1];
	
	NSError *error = nil;
	NSArray *result_objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	[request release];
	
	if (!error && nil != result_objects && [result_objects count] >0) {
		return [result_objects objectAtIndex:0];
	} else {
		return nil;
	}
}

+(NSArray*)findByPredicate:(NSPredicate*)aPredicate {
    
    
    return [self findByPredicate:aPredicate sortDescriptors:nil];

}


+(NSArray*)findByPredicate:(NSPredicate*)aPredicate sortDescriptors:(NSArray *)sortDescriptors{

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self description]
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	//predicate
	[request setPredicate:aPredicate];
    
    //
    if(sortDescriptors){
    
        [request setSortDescriptors:sortDescriptors];
    }
	
	NSError *error = nil;
	NSArray *result_objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	[request release];
	
	if (error) {
		NSLog(@"query error, %@", error);
		return nil;
	}
	
	return result_objects;
}


#pragma mark -
#pragma mark Instance Method

-(NSString*)shortID {
	
	NSURL *url = [[self objectID] URIRepresentation];
	NSArray *components = [[url absoluteString] componentsSeparatedByString:@"/"];
	return [components lastObject];
}

-(BOOL)save {
	return [NSManagedObject save];
}

-(void)remove {
	[[self managedObjectContext] deleteObject:self];
    [self save];
}

-(void)removeNoSave{
    [[self managedObjectContext] deleteObject:self];
}

-(NSArray*)entitiesNamed:(NSString*)name predicate:(NSPredicate*)aPredicate orders:(NSArray*)sds{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	//entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:name 
											  inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	//predicate
	[request setPredicate:aPredicate];
	[request setSortDescriptors:sds];
	
	NSError *error = nil;
	NSArray *result_objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	[request release];
	
	if (error) {
		NSLog(@"query error, %@", error);
		return nil;
	}
	
	return result_objects;
}

@end
