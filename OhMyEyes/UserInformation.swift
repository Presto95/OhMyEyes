//
//  UserInformation.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 5..
//  Copyright © 2018년 presto. All rights reserved.
//

class UserInformation {
    static let shared = UserInformation()
    var eyePosition: EyePosition?
    var height: Int?
    var armLength: Double {
        return Double((height ?? 0) / 3)
    }
}
