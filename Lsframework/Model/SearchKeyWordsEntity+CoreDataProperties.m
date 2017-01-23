//
//  SearchKeyWordsEntity+CoreDataProperties.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SearchKeyWordsEntity+CoreDataProperties.h"

@implementation SearchKeyWordsEntity (CoreDataProperties)

+ (NSFetchRequest *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SearchKeyWordsEntity"];
}

@dynamic words;
@dynamic rowID;

@end
