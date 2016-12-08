//
//  Enums.swift
//  Db Mgr
//
//  Created by Kevin Languedoc on 2016-05-19.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import Foundation


class Enums{

    enum SQLiteStatusCode : Int32 {
        case ok = 0
        case error = 1
        case internalLogicError = 2
        case accessPermissionDenied = 3
        case abort = 4
        case busy = 5
        case noMemory = 7
        case readOnly = 8
        case interrupt = 9
        case ioError = 10
        case corrupt = 11
        case notFound = 12
        case full = 13
        case cantOpen = 14
        case `protocol` = 15
        case empty = 16
        case schema = 17
        case tooBig = 18
        case constraint = 19
        case mismatch = 20
        case misuse = 21
        case noLFS = 22
        case authDeniedUTH = 23
        case format = 24
        case range = 25
        case notADatabase = 26
        case row = 100
        case done = 101
    }

}
