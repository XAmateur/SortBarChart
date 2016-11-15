//
//  NSMutableArray+BubbleSort.h
//  Sorting
//
//  Created by amateur on 11/10/16.
//  Copyright © 2016 amateur. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ExchangeCallBack)(id obj1, id obj2);
typedef NSComparisonResult(^ComparisoinResult)(id obj1, id obj2);


@interface NSMutableArray (CustomSort)

- (void)bubbleSortCompared:(ComparisoinResult)result didExchange:(ExchangeCallBack)callBack;

- (void)quickSortCompared:(ComparisoinResult)result didExchange:(ExchangeCallBack)callBack;

@end
