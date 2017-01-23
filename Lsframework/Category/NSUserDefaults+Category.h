//
//  NSUserDefaults+Category.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Category)

- (void)saveValue:(id) value withKeyPath:(NSString*) keyPath;

- (id)valueForkey:(NSString*) keyPath;

- (void)removeValueWithKey:(NSString*) keyPath;

- (id)readValueForKey:(NSString*) keyPath;


@end
