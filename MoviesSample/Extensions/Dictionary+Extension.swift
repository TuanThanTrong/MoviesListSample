//
//  Dictionary+Extension.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation

extension Dictionary {
    var queryString: String? {
        return self.reduce("") { (result, arg1) -> String in
            let (key, value) = arg1
            var actValue = value
            if let number = value as? NSNumber {
                let numberType = CFNumberGetType(number as CFNumber)
                if case CFNumberType.charType = numberType {
                    if let boolvalue = value as? Bool, boolvalue {
                        actValue = "true" as! Value
                    } else {
                        actValue = "false" as! Value
                    }
                } else {
                    actValue = value
                }
            }
            return "\(result)\(key)=\(actValue)&"
        }
    }
}
