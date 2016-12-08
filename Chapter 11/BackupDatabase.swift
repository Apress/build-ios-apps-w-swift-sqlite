//
//  ViewController.swift
//  DatabaseBackup
//
//  Created by Kevin Languedoc on 2016-08-31.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var db:OpaquePointer? = nil  // SQLite database connection for sourceDB filename
    var bakdb :OpaquePointer? = nil  // the SQLite Backup Object
    var filedb :OpaquePointer? = nil  // the SQLite Backup Object
    let fileMgr:FileManager = FileManager.default
    let sourcedb:String = "Chinook_Sqlite.sqlite" // The SQLite database to be backed up
    let targetdb:String = "backup_chinook.sqlite"
    var sqlStatement:OpaquePointer? = nil
    var err:UnsafeMutablePointer<Int8>? = nil
    
    @IBAction func backupOnDisk(_ sender: AnyObject) {
        self.backupRunningDatabase()
    }
    

    @IBAction func backupInMemory(_ sender: AnyObject) {
        self.backupInMemory()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.copyDatabaseIntoDocuments(sourcedb)
        self.copyDatabaseIntoDocuments(targetdb)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func copyDatabaseIntoDocuments(_ dbFilename:String){
      
        var srcPath:URL
        var destPath:URL
        let dirManager = FileManager.default
        let projectBundle = Bundle.main
        
        
        do {
            let resourcePath = projectBundle.path(forResource: dbFilename.components(separatedBy: ".")[0], ofType: "sqlite")
            let documentURL = try dirManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            
            srcPath = URL(fileURLWithPath: resourcePath!)
            destPath = documentURL.appendingPathComponent(dbFilename)
            
            if !dirManager.fileExists(atPath: destPath.path) {
                
                try dirManager.copyItem(at: srcPath, to: destPath)
                
            }
      
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }

        
    }
    func getDatabasePath(_ database:String)->URL{
        var dbfile:URL = URL()
        let dirManager = FileManager.default
       
        do {
            let directoryURL = try dirManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            
            dbfile = directoryURL.appendingPathComponent(database)

            
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }
        return dbfile
    }
    func backupInMemory(){
        if(sqlite3_open(sourcedb, &filedb)==SQLITE_OK){
            if(sqlite3_open("file::memory:", &db) == SQLITE_OK){
                bakdb = sqlite3_backup_init(db, "main", filedb, "main")
                sqlite3_backup_step(bakdb, -1)
                sqlite3_backup_finish(bakdb)
                
                sqlite3_close(db);
                sqlite3_close(filedb)
            }
        }
    }
    func backupRunningDatabase(){
        var rc:Int32 = -1
        var remaining:Int32 = 0
        var page_count:Int32 = 0
        
        if(sqlite3_open(self.getDatabasePath(sourcedb).path, &db)==SQLITE_OK){
            if(sqlite3_open(self.getDatabasePath(targetdb).path, &filedb) == SQLITE_OK){
            bakdb = sqlite3_backup_init(filedb, "main", db, "main");
            remaining = sqlite3_backup_remaining(db)
            
            while(remaining != 0){
                rc = sqlite3_backup_step(bakdb, 10) //copy 10 pages to backup db
                if(rc == SQLITE_OK){
                    remaining = sqlite3_backup_remaining(db)
                    page_count = sqlite3_backup_pagecount(db)
                    print(remaining)
                    print(page_count)
                    
                    if( rc==SQLITE_OK || rc==SQLITE_BUSY || rc==SQLITE_LOCKED ){
                        sqlite3_sleep(250);
                    }
                }

            }
             sqlite3_backup_finish(bakdb)
          }
        }
         sqlite3_close(db)
         sqlite3_close(filedb)
       }
    
    func backupCopyDatabase(){
        if sqlite3_close(db) == SQLITE_OK{
            let fileMgr = FileManager.default
            
            do {
                try fileMgr.copyItem(atPath: self.sourcedb, toPath: self.targetdb)
                if(sqlite3_exec(db, "VACUUM", nil, &sqlStatement, &err) == SQLITE_OK){
                   print("database compressed")
                }
               
               
            }
            catch let error as NSError {
                print("Backup error: \(error)")
            }
            
        }
        
    }

 }
    
    




