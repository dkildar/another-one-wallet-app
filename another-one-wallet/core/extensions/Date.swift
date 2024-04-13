//
//  Date.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import Foundation

extension Date {

    func clearTime() -> Date?
    {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0

        return calendar.date(from: components)
    }

}
