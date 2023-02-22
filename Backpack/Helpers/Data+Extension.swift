//
//  Data+Extension.swift
//  Backpack
//
//  Created by Cobra on 20/02/2023.
//

import Foundation

// https://stackoverflow.com/questions/28124119/convert-html-to-plain-text-in-swift
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(
                data: self,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
