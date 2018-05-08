// 
//   NSDateExtension.swift
// 
//   Created by CodeVision on 15/06/16.
//   Copyright © 2016 Codevision. All rights reserved.
// 

import Foundation

extension Date {

    func isLaterThan(_ dateToCompare: Date) -> Bool {
        var isLater = false

        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isLater = true
        }

        return isLater
    }

    func isEarlierThan(_ dateToCompare: Date) -> Bool {
        var isEarlier = false

        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isEarlier = true
        }

        return isEarlier
    }

    func isEqualTo(_ dateToCompare: Date) -> Bool {
        var isEqual = false

        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqual = true
        }

        return isEqual
    }

    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)

        return dateWithHoursAdded
    }

    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)

        return dateWithDaysAdded
    }
    
    
    func addSeconds(_ secondToAdd: Double) -> Date {
        let seconds: TimeInterval = secondToAdd
        let dateWithSecondsAdded: Date = self.addingTimeInterval(seconds)
        
        return dateWithSecondsAdded
    }
    

    func addMiliSeconds(_ miliSecondToAdd: Int) -> Date {
        let seconds: TimeInterval = Double(miliSecondToAdd/1000)
        let dateWithmilisecondAdded: Date = self.addingTimeInterval(seconds)

        return dateWithmilisecondAdded
    }

    func addMonth(_ monthsToAdd: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self)!
    }

    func addYear(_ yearsToAdd: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self)!
    }

    func convertDateToLocalTimeZone() -> Date {
        let timeZoneSeconds = NSTimeZone.local.secondsFromGMT()
        let dateInLocal = self.addHours(timeZoneSeconds/3600)
        return dateInLocal
    }

    func getDaysInMonth() -> Int {
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
    }

    func getNumberOfWeekDay() -> Int {

        let weekday: Int = Calendar.current.component(.weekday, from: self)

        return weekday == 1 ? 7: weekday - 1

    }

    func getFirstDayNumberOfWeekDay() -> Int {

        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        return date.getNumberOfWeekDay()
    }

    func getLastDayNumberOfWeekDay() -> Int {

        let date = endOfMonth()

        return date.getNumberOfWeekDay()
    }

    func getNumberOfWeek() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfYear, from: self)
    }

    func todayFormat() -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let today = dateFormatter.string(from: self)

        let todayDate = dateFormatter.date(from: today)

        return todayDate!

    }

    func getDay() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)

        return components.day!
    }

    func getMonth() -> Int {

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)

        return components.month!
    }

    func getYear() -> Int {

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)

        return components.year!
    }

    func getHour() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)

        return components.hour!

    }

    func getMinute() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: self)

        return components.minute!
    }

    func getSecond() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: self)

        return components.second!
    }

    func getMonthName() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM"
        fmt.locale = Locale(identifier: "en-GB")
        let month = fmt.monthSymbols[self.getMonth() - 1]
        return month
    }

    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func dateWithMillisecInString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
        return dateFormatter.string(from: self)
    }





}
