//
//  TimeManager.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 03. 29..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import Foundation
import MHSNTP
import Kronos

class TimeManager: NSObject {
    
    static let shared = TimeManager()
    
    let sntp = MHSNTPManager()
    
    override init() {
        sntp.addAppleSNTPServers()
        Clock.sync()
    }
    
    func now() -> Date {
        print(sntp.systemClockOffset())
        return Clock.now ?? sntp.now()
    }
    
    func calculateOffsetFromNetActualTime(date: Date) -> TimeInterval {
        return date.timeIntervalSince1970 - now().timeIntervalSince1970
    }
    
    func calculateStartTime(offset: Int = 5) -> Date {
        return now().addSeconds(offset)
    }
    
    
}
