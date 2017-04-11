//
//  DBManager.h
//  IMAGE DB
//
//  Created by Apple on 4/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property(nonatomic,strong) NSString *documentsDirectory;

@property(nonatomic,strong)NSArray *directoryPaths;

-(void)database;
- (void) SaveImagesToSql: (NSData*) imgData;
- (NSData*) LoadImagesFromSql;

@end
