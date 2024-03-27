//
//  MPRow.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPRow : NSObject

@property(nonatomic) NSString* offset;
@property(nonatomic) NSString* data;
@property(nonatomic) NSString* descriptions;
@property(nonatomic) NSString* value;

+ (instancetype)_initWithDataOffset:(NSString *)_offset
                               data:(NSString *)_data
                        description:(NSString *)_description
                              value:(NSString *)_value;

@end

NS_ASSUME_NONNULL_END
