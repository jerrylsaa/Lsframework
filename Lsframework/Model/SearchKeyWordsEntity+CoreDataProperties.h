//
//  SearchKeyWordsEntity+CoreDataProperties.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SearchKeyWordsEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchKeyWordsEntity (CoreDataProperties)

+ (NSFetchRequest *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *words;
@property (nullable, nonatomic, copy) NSNumber *rowID;

@end

NS_ASSUME_NONNULL_END
