//
//  DBManager.m
//  IMAGE DB
//
//  Created by Apple on 4/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager(){
    
    
sqlite3 *sqlite3DatabaseObject;
sqlite3_stmt* sqlite3Statement;
}
@end

@implementation DBManager

@synthesize directoryPaths;
@synthesize documentsDirectory;

-(void)database
{
    
    directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [directoryPaths objectAtIndex:0];
    NSString * databasePath = [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"informationdb.sql"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:databasePath] == NO) {
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &sqlite3DatabaseObject)== SQLITE_OK) {
            char * errorMessage;
            const char *sqlite3Query = "CREATE TABLE IF NOT EXISTS PICTURES (PHOTO BLOB)";
            if (sqlite3_exec(sqlite3DatabaseObject, sqlite3Query, NULL, NULL, &errorMessage)!= SQLITE_OK) {
                NSLog(@"failed = %@",sqlite3DatabaseObject);
            }
            sqlite3_close(sqlite3DatabaseObject);
        }else{
            NSLog(@"failed to create database");
        }
    }
}



- (void) SaveImagesToSql: (NSData*) imgData  {
    
    directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [directoryPaths objectAtIndex:0];
    NSString * databasePath = [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"informationdb.sql"]];
    
    const char* sqlite3Query = "INSERT INTO PICTURES (PHOTO) VALUES (?)";
    int openDatabaseResult = sqlite3_open_v2([databasePath UTF8String], &sqlite3DatabaseObject, SQLITE_OPEN_READWRITE , NULL);
    if (openDatabaseResult == SQLITE_OK) {
        int sqlite3Prepare = sqlite3_prepare_v2(sqlite3DatabaseObject, sqlite3Query, -1, &sqlite3Statement, NULL);
        if( sqlite3Prepare == SQLITE_OK ) {
            sqlite3_bind_blob(sqlite3Statement, 1, [imgData bytes], [imgData length], SQLITE_TRANSIENT);
            sqlite3_step(sqlite3Statement);
        }
        else
        {
            NSLog(@"Error is: %s", sqlite3_errmsg(sqlite3DatabaseObject));
        }
        sqlite3_finalize(sqlite3Statement);
        
    }
    else NSLog( @"Error is:  %s", sqlite3_errmsg(sqlite3DatabaseObject) );
    sqlite3_close(sqlite3DatabaseObject);
}


- (NSData*) LoadImagesFromSql
{
    NSData* data = nil;
    
    const char* sqlite3Query = "SELECT photo FROM pictures";
    
    if( sqlite3_prepare_v2(sqlite3DatabaseObject, sqlite3Query, -1, &sqlite3Statement, NULL) == SQLITE_OK )
    {
        if( sqlite3_step(sqlite3Statement) == SQLITE_ROW )
        {
            int length = sqlite3_column_bytes(sqlite3Statement, 0);
            data       = [NSData dataWithBytes:sqlite3_column_blob(sqlite3Statement, 0) length:length];
        }
    }
    
    sqlite3_finalize(sqlite3Statement);
    return data;
    
}

@end
