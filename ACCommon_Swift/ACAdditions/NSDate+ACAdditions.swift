//
//  NSDate+ACAdditions.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-29.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import Foundation

extension NSDate {
//    #pragma mark - 时间分段取出
    
    
    func dateComponents() -> NSDateComponents {
        let cal: NSCalendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.EraCalendarUnit |
                        NSCalendarUnit.YearCalendarUnit |
                        NSCalendarUnit.MonthCalendarUnit |
                        NSCalendarUnit.DayCalendarUnit |
                        NSCalendarUnit.HourCalendarUnit |
                        NSCalendarUnit.MinuteCalendarUnit |
                        NSCalendarUnit.SecondCalendarUnit |
                        NSCalendarUnit.WeekdayCalendarUnit
        return cal.components(unitFlags, fromDate: self)
    }
    
    func weeks() -> NSDictionary {
        let weeks = [NSNumber(2): "一",
            NSNumber(3): "二",
            NSNumber(4): "三",
            NSNumber(5): "四",
            NSNumber(6): "五",
            NSNumber(7): "六",
            NSNumber(1): "日"]
        return weeks
    }
    
    func era() -> NSString {
    }
    
    func year() -> NSString {
        
    }
    
    func month() -> NSString {
        
    }
    
    func month_MM() -> NSString {
        
    }
    
    func day() -> NSString {
        
    }
    
    func day_dd() -> NSString {
        
    }
    
    func hour() -> NSString {
        
    }
    
    func hour_hh() -> NSString {
        
    }
    
    func minute() -> NSString {
        
    }
    
    func minute_mm() -> NSString {
        
    }
    
    func second() -> NSString {
        
    }
    
    func second_ss() -> NSString {
        
    }
    
    func week() -> NSString {
        
    }
}
