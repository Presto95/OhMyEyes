//
//  String+.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 8..
//  Copyright © 2018년 presto. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
