//
//  String+Extensions.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation
import UIKit

extension String {
    func convertToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func format(stringAttribute: String, fontAttribute: UIFont = UIFont.boldSystemFont(ofSize: 14), colorAttribute: UIColor = UIColor.blue, font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: self,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: fontAttribute, NSAttributedString.Key.foregroundColor: colorAttribute]
        for string in [stringAttribute] {
            attributedString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: string))
        }
        return attributedString
    }
}
