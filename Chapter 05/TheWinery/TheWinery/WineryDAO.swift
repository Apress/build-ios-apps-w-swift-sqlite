//
//  WineryDAO.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-06.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import Foundation
import UIKit

class WineryDAO: NSObject {
    let dbName:String="thewinery.sqlite"
    var db:OpaquePointer?=nil
    var sqlStatement:OpaquePointer?=nil
    var errMsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>? = nil
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var dbPath:URL = URL.init(string: "")!
    var errStr:String = ""
    
    
    override init() {
        /*
         Create SQLite Winery.sqlite database in Documents directory
         
         */
        
        let dirManager = FileManager.default
        do {
            var directoryURL = try dirManager.urls(for:.documentDirectory, in:.userDomainMask)
            
            dbPath = try dirManager.urls(for:String(describing: directoryURL).appending(dbName), in:.userDomainMask)
            
            
            
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }

    }
    func selectWineriesList()->Array<Wineries>{
        var wineryArray = [Wineries]()
        

        let sql:String = "Select name, country, region, volume, uom from main.winery"
        
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql, -1, &sqlStatement, nil)==SQLITE_OK){
                while(sqlite3_step(sqlStatement)==SQLITE_ROW){
                    let vintnor:Wineries = Wineries.init()
                    
                    vintnor.name = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 0)))
                    vintnor.country = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 1)))
                    vintnor.region = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 2)))
                    vintnor.volume = sqlite3_column_double(sqlStatement, 3)
                    vintnor.uom = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 4)))
                    wineryArray.append(vintnor)
                }
            }
        }
        sqlite3_close(db)
        return wineryArray
    }
    //run from AppDelegate
    func createOrOpenDatabase()->Enums.SQLiteStatusCode{
       
        return Enums.SQLiteStatusCode(rawValue: sqlite3_open(dbPath.absoluteString.cString(using: String.Encoding.utf8)!, &db))!
    }
    
    func insertWineryRecord(_ vintner:Wineries) -> Enums.SQLiteStatusCode {
        let sql:String = "INSERT INTO main.winery(name, country, region, volume, uom) VALUES(?, ?, ?, ?, ? )"
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql, -1, &sqlStatement, nil)==SQLITE_OK){
               
                sqlite3_bind_text(sqlStatement, 1, vintner.name, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(sqlStatement, 2, vintner.country, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(sqlStatement, 3, vintner.region, -1, SQLITE_TRANSIENT)
                sqlite3_bind_double(sqlStatement, 4, vintner.volume)
                sqlite3_bind_text(sqlStatement, 5, vintner.uom, -1, SQLITE_TRANSIENT)
                sqlite3_step(sqlStatement)
                sqlite3_finalize(sqlStatement)
            }
            
        }else{
            print(String(cString: sqlite3_errmsg(db)))
            return Enums.SQLiteStatusCode.error
        }
        sqlite3_close(db)
        return Enums.SQLiteStatusCode.ok
    }
    func getWinerySchema() {
        let sql:String = "select sql from sqlite_master where type = 'table'"
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8)!, -1, &sqlStatement, nil)==SQLITE_OK){
                while(sqlite3_step(sqlStatement)==SQLITE_OK){
                 let schema:String = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 1)))
                  print(schema)
                }
               
               
            }
            
        }else{
            print(String(cString: sqlite3_errmsg(db)))
                    }
        sqlite3_close(db)

        
    }
    
    func insertWineRecord(_ wine:Wine)->Enums.SQLiteStatusCode{
        let sql:String = "INSERT INTO main.wine(name, rating, image, producer) VALUES(?, ?, ?, ?)"
        
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql, -1, &sqlStatement, nil)==SQLITE_OK){
            
                sqlite3_bind_text(sqlStatement, 1, wine.name, -1, SQLITE_TRANSIENT)
                sqlite3_bind_int(sqlStatement, 2, wine.rating)
                sqlite3_bind_blob(sqlStatement, 3, wine.image.bytes,Int32(wine.image.count), SQLITE_TRANSIENT)
                sqlite3_bind_text(sqlStatement, 4, wine.producer, -1, SQLITE_TRANSIENT)
                sqlite3_step(sqlStatement)
                sqlite3_finalize(sqlStatement)
            }
            
        
        }else{
            print(String(cString: sqlite3_errmsg(db)))
            return Enums.SQLiteStatusCode.error
        }
         sqlite3_close(db)
        return Enums.SQLiteStatusCode.ok
    }
    func buildSchema()->Void{
        if let filepath = Bundle.main.path(forResource: "thewinery", ofType: "sql") {
            do {
                let script = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                print(script)
                if sqlite3_open(dbName, &db)==SQLITE_OK {
                    if sqlite3_exec(db, script.cString(using: String.Encoding.utf8)!, nil, nil, errMsg) != SQLITE_OK{
                        print( errStr = String(cString: sqlite3_errmsg(db)))
                    }
                }else{
                    print("Could not open database " + String(cString: sqlite3_errmsg(db)))
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("file not found")
        }
        sqlite3_close(db)
      }
    
    func selectWineList()->Array<Wine>{
        var wineArray = [Wine]()
        let sql:String = "Select name, rating, image, producer from main.wine"
        
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8)!, -1, &sqlStatement, nil)==SQLITE_OK){
                while(sqlite3_step(sqlStatement)==SQLITE_ROW){
                    let wine:Wine = Wine.init()
                   
                    wine.name = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 0)))
                    wine.rating = sqlite3_column_int(sqlStatement, 1)
                    let raw:UnsafePointer = sqlite3_column_blob(sqlStatement, 2);
                    let rawLen:Int32 = sqlite3_column_bytes(sqlStatement, 2);
                    wine.image  = Data(bytes: UnsafePointer<UInt8>(raw), count: Int(rawLen))
               //     wine.producer = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 3)))!

                    wineArray.append(wine)
                }
            }
        }
        sqlite3_close(db)
        return wineArray
    }
    
    func selectWineryByName(_ name:String)->String{
        let vintnor:Wineries = Wineries.init()
        let sql:String = "Select name from main.winery where name=?"
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8)!, -1, &sqlStatement, nil)==SQLITE_OK){
                sqlite3_bind_text(sqlStatement, 0, vintnor.name.cString(using: String.Encoding.utf8)!, -1, SQLITE_TRANSIENT)
                if(sqlite3_step(sqlStatement)==SQLITE_OK){
                    vintnor.name = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement, 1)))
                }
            }
        }
        sqlite3_close(db)
        return vintnor.name
    }

    func wineUpdate(_ wine:Wine)->Int32{
        let sql:String = "UPDATE main.wine " +
        "SET rating = ?, " +
        "image = ?, " +
        "producer = ? " +
        "WHERE name = ?"
        
        var status_code:Int32 = 0
        
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, sql, -1, &sqlStatement, nil)==SQLITE_OK){
            
                sqlite3_bind_int(sqlStatement, 0, wine.rating)
                sqlite3_bind_blob(sqlStatement, 1, wine.image.bytes, Int32(wine.image.count), SQLITE_TRANSIENT)
                sqlite3_bind_text(sqlStatement, 2, wine.producer.cString(using: String.Encoding.utf8)!, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(sqlStatement, 3, wine.name.cString(using: String.Encoding.utf8)!, -1, SQLITE_TRANSIENT)
               status_code = sqlite3_step(sqlStatement)
               status_code = sqlite3_finalize(sqlStatement)
            }
        }
        sqlite3_close(db)
        
        return status_code
        
    }
    
    func wineryUpdate(_ winery:Wineries)->Int32{
let sql:String = "UPDATE winery SET country = '\(winery.country)', region = ' \(winery.region) ', volume = \(winery.volume), uom = ' \(winery.uom) ' WHERE name = ' \(winery.name) ' ;"
            var status_code:Int32 = 0
            
            if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
                status_code = sqlite3_prepare_v2(db, sql, -1, &sqlStatement, nil)
                if(status_code==0){
                    status_code = sqlite3_step(sqlStatement)
                    status_code = sqlite3_finalize(sqlStatement)
                }
            }
            sqlite3_close(db)
            
            return status_code
        }
    
    func deleteWineRecord(_ record:String){
        let deleteSQL = "DELETE FROM wine WHERE name = ?"
        
        if(sqlite3_open(dbPath.path, &db)==SQLITE_OK){
            if(sqlite3_prepare_v2(db, deleteSQL, -1, &sqlStatement, nil)==SQLITE_OK){
                sqlite3_bind_text(sqlStatement, 1, record, -1, SQLITE_TRANSIENT)
                if(sqlite3_step(sqlStatement)==SQLITE_DONE){
                    print("item deleted")
                }else{
                    print("unable to delete")
                }
            }
            
        }
    }
    
    func deleteWineryRecord(_ record:String){
        let deleteSQL = "DELETE FROM winery WHERE name = ?"
        
        if(sqlite3_exec(db, deleteSQL, nil, &sqlStatement, errMsg)==SQLITE_OK){
            sqlite3_bind_text(sqlStatement, 1, record, -1, SQLITE_TRANSIENT)
            sqlite3_close(db)
        }else{
            print("unable to delete")
        }
    }

}


