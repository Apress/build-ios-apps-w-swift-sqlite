//
//  DbMgrDAO.swift
//  Db Mgr
//
//  Created by Kevin Languedoc on 2016-05-19.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import Foundation


class DbMgr:NSObject{
    
    let dbName:String="DbMgr.db";
    let db:OpaquePointer?=nil;
    let sqlStatement:OpaquePointer?=nil;
    var errMsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>? = nil;
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self);
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self);
    var dbPath:URL = URL();
    var dbOpenStatusCode:int=nil;
    
    
    override init() {
        let dirManager = FileManager.default
        
        do {
            let directoryURL = try dirManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            
            dbPath = directoryURL.appendingPathComponent("database.sqlite")
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }
        
       dbOpenStatusCode = sqlite3_open(dbPath.absoluteString.cStringUsingEncoding(String.Encoding.utf8)!, &db)!
    
    }
    
    func executeQuery(_ sqlStr:String) -> Enums.SQLiteStatusCode {
        let statuscode = sqlite3_exec(db, query.cStringUsingEncoding(String.Encoding.utf8)!, nil, nil, errMsg);
        return SQLiteStatusCode(rawValue: statuscode)!
        let dbS
        
    }
    
    func executeQueryResult(_ sqlStr:String)->Enums.SQLiteStatusCode{
        
    }
    
}
