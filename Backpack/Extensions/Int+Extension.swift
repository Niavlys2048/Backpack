//
//  Int+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 31/01/2023.
//

import Foundation

extension Int {
    func timeFromTimezone() -> String {
        let currentDate = Date()

        // 1. Create a DateFormatter() object.
        let format = DateFormatter()

        // 2. Set the timezone
        format.timeZone = .init(secondsFromGMT: self)

        // 3. Set the format of the altered date.
        format.dateFormat = "HH:mm"

        // 4. Set the current date, altered by timezone.
        let dateString = format.string(from: currentDate)

        return dateString
    }
}
