//
//  NSDateExtensions.swift
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
       
        return NSString(format: "%d",self.dateComponents().era)
    }
    
    func year() -> NSString {
        return NSString(format: "%d",self.dateComponents().year)
    }
    
    func month() -> NSString {
        return NSString(format: "%d",self.dateComponents().month)
    }
    
    func month_MM() -> NSString {
        return NSString(format: "%02d",self.dateComponents().month)
    }
    
    func day() -> NSString {
        
        return NSString(format: "%d",self.dateComponents().day)
    }
    
    func day_dd() -> NSString {
        
        return NSString(format: "%02d",self.dateComponents().day)
    }
    
    func hour() -> NSString {
        
        return NSString(format: "%d",self.dateComponents().hour)
    }
    
    func hour_hh() -> NSString {
        
        return NSString(format: "%02d",self.dateComponents().hour)
    }
    
    func minute() -> NSString {
        
        return NSString(format: "%d",self.dateComponents().minute)
    }
    
    func minute_mm() -> NSString {
        
        return NSString(format: "%02d",self.dateComponents().minute)
    }
    
    func second() -> NSString {
        
        return NSString(format: "%d",self.dateComponents().second)
    }
    
    func second_ss() -> NSString {
        
        return NSString(format: "%02d",self.dateComponents().second)
    }
    
    func week() -> NSString {
        return NSString(format: "周%@", self.weeks()[NSNumber(self.dateComponents().weekday)])
    }
}
