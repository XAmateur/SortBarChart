//
//  NSMutableArray+BubbleSort.m
//  Sorting
//
//  Created by amateur on 11/10/16.
//  Copyright © 2016 amateur. All rights reserved.
//

#import "NSMutableArray+CustomSort.h"


@implementation NSMutableArray (CustomSort)

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 didChangeCallBack:(ExchangeCallBack )callBack
{
    id temp = self[idx1];
    self[idx1] = self[idx2];
    self[idx2] = temp;
    
    if (callBack) {
        callBack(temp, self[idx1]);
    }
}

- (void)bubbleSortCompared:(ComparisoinResult)result didExchange:(ExchangeCallBack)callBack
{
    for (NSInteger i=self.count-1;i>0;i--) {
        for (NSInteger j=0;j<i;j++) {
            if(result(self[j],self[j+1]) == NSOrderedDescending) {
                [self exchangeObjectAtIndex:j withObjectAtIndex:j+1 didChangeCallBack:callBack];
            }
        }
    }
}

- (void)quickSortCompared:(ComparisoinResult)result didExchange:(ExchangeCallBack)callBack
{
    if (self.count == 0) {
        return;
    }
    
    [self quickSortWithLowIndex:0 highIndex:self.count-1 compareResult:result exchangeCallBack:callBack];
}

- (void)quickSortWithLowIndex:(NSInteger )low
                    highIndex:(NSInteger)high
                compareResult:(ComparisoinResult)result
             exchangeCallBack:(ExchangeCallBack)callBack
{
    if (low >= high) {
        return;
    }
    
    NSInteger pivot = [self pivotValueWithLowIndex:low highIndex:high compareResult:result exchangeCallBack:callBack];
    
    [self quickSortWithLowIndex:low highIndex:pivot compareResult:result exchangeCallBack:callBack];
    [self quickSortWithLowIndex:pivot +1 highIndex:high compareResult:result exchangeCallBack:callBack];
}

- (NSInteger)pivotValueWithLowIndex: (NSInteger )lowIndex
                          highIndex:(NSInteger)highIndex
                      compareResult:(ComparisoinResult)result
                   exchangeCallBack:(ExchangeCallBack)callBack
{
    id pivot = self[lowIndex];
    
    NSInteger i = lowIndex;
    NSInteger j = highIndex;
    
    while (i < j) {
        
        while (i < j && result(pivot,self[j]) != NSOrderedDescending) {
            j--;
        }
        
        if (i < j) {
            [self exchangeObjectAtIndex:i withObjectAtIndex:j didChangeCallBack:callBack];
            i ++;
        }
        
        while (i < j && result(self[i],pivot) != NSOrderedDescending) {
            i++;
        }
        
        if (i < j) {
            [self exchangeObjectAtIndex:i withObjectAtIndex:j didChangeCallBack:callBack];
            j--;
        }
    }
    return j;
}


@end
