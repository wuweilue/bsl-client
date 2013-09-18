//
//  MessageRecordManager.m
//  cube-ios
//
//  Created by chen shaomou on 4/9/13.
//
//

#import "MessageRecordManager.h"

@implementation MessageRecordManager


static MessageRecordManager *instance = nil;

+ (MessageRecordManager *)sharedMessageRecordManager{
    @synchronized ([MessageRecordManager class]) {
        if (instance == nil) {
			instance = [[MessageRecordManager alloc] init];
            [instance openDB];
        }
    }
    return instance;
}
- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(BOOL) openDB{


    return [self openDBWithPath:[[self getBaseDocumentsDirectory] stringByAppendingPathComponent:@"AMP.cube.sqlite"] sqlite:&database reName:@"cube_message_record"];
}

- (BOOL) openDBWithPath:(NSString *)path sqlite:(sqlite3 **)sqlite reName:(NSString *)DBName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    if (!find) {
		NSString *rePath = getBundleFilePath(DBName, @"sqlite");
		NSData *dataFile = [NSData dataWithContentsOfFile:rePath];
		[dataFile writeToFile:path atomically:YES];
        
	}else{
        NSLog(@"Database file have already existed.");
    }
	if(sqlite3_open([path UTF8String], sqlite) != SQLITE_OK) {
		sqlite3_close(*sqlite);
		NSLog(@"Error: open database file.");
		return NO;
	}
	return YES;
}

- (BOOL) isTableExist:(NSString *)tablename{
    
    sqlite3_stmt *statement = nil;
    const char *sql = [[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",tablename] UTF8String];
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: check table exist fail,%@",tablename);
        return NO;
    }
    NSString *value = nil;
    while (sqlite3_step(statement) == SQLITE_ROW) {
		char *field = (char*)sqlite3_column_text(statement, 0);
		if (field)
			value = [NSString stringWithUTF8String:field];
    }
    sqlite3_finalize(statement);
    
    if(value == nil){
    
        return NO;
    }
    
    return YES;
}

- (BOOL) createTable:(NSDictionary *)object tablename:(NSString *)tablename{
    
    NSDictionary *reObject = [[object allValues] objectAtIndex:0];
    
    NSString *sql = [NSString stringWithFormat:@"create table '%@' ",tablename];
    
    sql = [sql stringByAppendingString:@"("];
    
    int index = 0;
    
    for(NSString *eachKey in [reObject allKeys]){
        
        sql = [sql stringByAppendingFormat:@"'%@' TEXT",eachKey];
        
        if(index < [[reObject allKeys] count] - 1){
        
            index ++;
            
            sql = [sql stringByAppendingString:@","];
        }
    }
    
    sql = [sql stringByAppendingString:@")"];
    
    char *errmsg = NULL;
    int result = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    
    if (result != SQLITE_OK) {
        NSLog(@"%d %s", result, errmsg);
        
        return NO;
    }

    return YES;
}

- (BOOL) insertData:(NSDictionary *)object tablename:(NSString *)tablename{
    
    sqlite3_stmt *statement;
    NSMutableString *sqlString = [[NSMutableString alloc] init];
    
    NSDictionary *reObject = [[object allValues] objectAtIndex:0];
    
    NSArray *attrs = [reObject allKeys];
    
    [sqlString appendFormat:@"INSERT INTO '%@' (",tablename];
    for(int index = 0 ; index < [attrs count] ; index++){
        if(index < [attrs count] - 1){
            [sqlString appendFormat:@"'%@',",[attrs objectAtIndex:index]];
        }else{
            [sqlString appendFormat:@"'%@') VALUES (",[attrs objectAtIndex:index]];
        }
    }
    for(int index = 0 ; index < [attrs count] ; index++){
        if(index < [attrs count] - 1){
            [sqlString appendFormat:@"?,"];
        }else{
            [sqlString appendFormat:@"?)"];
        }
    }
    const char *sql = [sqlString UTF8String];
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
       
        
        for(NSString *eachAttr in attrs){
            [self checkColumn:eachAttr From:tablename DataBase:database];
        }
        
        success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
        if (success != SQLITE_OK){
            NSLog(@"Error: failed to insert buffer");
            [sqlString release];
            return NO;
        }
        
        
	}
    sqlite3_exec(database, "begin", 0, 0, NULL);
    for(int index = 0; index < [attrs count] ; index ++){
        id var = [reObject valueForKey:[attrs objectAtIndex:index]];
            sqlite3_bind_text(statement, index + 1, [var UTF8String], -1, SQLITE_TRANSIENT);
    }
    success = sqlite3_step(statement);
    sqlite3_reset(statement);
    sqlite3_exec(database, "commit", 0, 0, NULL);
	sqlite3_finalize(statement);
    [sqlString release];
	if (success == SQLITE_ERROR) {
        return NO;
    }
    return YES;
}

NSString *getBundleFilePath(NSString* filename, NSString* ext) {
	return [[NSBundle mainBundle] pathForResource:filename ofType:ext];
}

-(NSString*)getBaseDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(BOOL)storeJSONObject:(NSDictionary *)object module:(NSString *)module{

    NSString *tablename = [NSString stringWithFormat:@"%@.%@",module,[[object allKeys] objectAtIndex:0]];
    
    if(![self isTableExist:tablename]){
    
        [self createTable:object tablename:tablename];
    }
    
    [self insertData:object tablename:tablename];
    

    return NO;
}

//检查数据库表字段是否存在，如果不存在就添加这个字段
-(void)checkColumn:(NSString*)column From:(NSString*)from DataBase:(sqlite3*)dataBase{
    
    NSString *sqlObjcStr = [NSString stringWithFormat:@"SELECT %@ FROM '%@'",column,from];
    const char *sql = [sqlObjcStr UTF8String];
    char *errmsg = NULL;
    int result = sqlite3_exec(dataBase, sql, NULL, NULL, &errmsg);
    if (result != SQLITE_OK) {
        NSLog(@"%d %s", result, errmsg);
        
        NSString *sqlStr = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN %@ TEXT",from,column];
        const char *sql2 = [sqlStr UTF8String];
        
        result = sqlite3_exec(dataBase,sql2 , NULL, NULL, &errmsg);
        if (result != SQLITE_OK) {
            NSLog(@"%d %s", result, errmsg);
        }
        
    }
    
}

- (NSArray *)excuteQuery:(NSString *)sql{
    
    sqlite3_stmt *statement = nil;
    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error1: failed to excute the sql");
        return nil;
    }
    
    int colcount = sqlite3_column_count(statement);
    
    NSMutableArray *resultSet =[[NSMutableArray alloc] init];
    
    int i = 0;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        NSLog(@"%d",i++);
        
        NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
        
        for(int index = 0 ; index < colcount; index ++){
            int type = sqlite3_column_type(statement, index);
            switch (type) {
                case SQLITE_INTEGER:
                {
                    int field = sqlite3_column_int(statement, index);
                    NSString *value= [[NSString alloc] initWithFormat:@"%d",field];
                    NSString *key = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, index)];
                    [obj setValue:value forKey:key];
                    [value release];
                    [key release];
                }
                    break;
                case SQLITE_TEXT:
                {
                    char *field = (char*)sqlite3_column_text(statement, index);
                    if(field){
                        NSString *value = [[NSString alloc] initWithUTF8String:field];
                        NSString *key = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, index)];
                        [obj setValue:value forKey:key];
                        [value release];
                        [key release];
                    }
                }
                    break;
            }
            
        }

        [resultSet addObject:obj];
        [obj release];
    }
    sqlite3_finalize(statement);
        
    return [resultSet autorelease];
}

@end
