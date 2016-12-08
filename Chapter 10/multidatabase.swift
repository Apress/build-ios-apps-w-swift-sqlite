//
//  ViewController.swift
//  MultiDatabase
//
//  Created by Kevin Languedoc on 2016-08-20.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var databases = [String]()
    var dbPath = URL()
    var db:OpaquePointer? = nil
    var sqlStatement:OpaquePointer? = nil
    var attachDb:String = ""
  
    
    
    @IBOutlet weak var dbnamePicker: UIPickerView!
    @IBOutlet weak var dbnameField: UITextField!
    @IBAction func saveBtn(_ sender: AnyObject) {
        self.createDatabase(self.dbnameField.text!)
        dbnamePicker.reloadAllComponents()
    }

    @IBAction func attachDbBtn(_ sender: AnyObject) {
        let dbame = attachDb.components(separatedBy: ".")[0]
        self.attachDatabase(self.getDbToAttach(attachDb).path, schemaName: dbame+"_schema")
    }
    
    @IBAction func detachDbBtn(_ sender: AnyObject) {
        let dbame = attachDb.components(separatedBy: ".")[0]
        self.detachDatabase(self.getDbToAttach(attachDb).path,schemaName: dbame+"_schema")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbnamePicker.delegate = self
        dbnamePicker.dataSource = self
        
        
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let sqliteFiles = directoryContents.filter{ $0.pathExtension == "sqlite" }
           
            databases = sqliteFiles.flatMap({$0.lastPathComponent})
            print("list:", databases)
            
            //
            self.setDbpath()
           
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDbToAttach(_ db_to_attach:String)->URL{
        let dirManager = FileManager.default
        var db_to_attach_path = URL()
        do {
            let directoryURL = try dirManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            db_to_attach_path = directoryURL.appendingPathComponent(db_to_attach)
            
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }
        return db_to_attach_path
    }
    
    func setDbpath(){
        let dirManager = FileManager.default
        let dbname = "cities.sqlite"
        do {
            let directoryURL = try dirManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            dbPath = directoryURL.appendingPathComponent(dbname)
            
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }

    }
    func createDatabase(_ database:String){
        let dirManager = FileManager.default
        do {
            let directoryURL = try dirManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            dbPath = directoryURL.appendingPathComponent(database)
            if(!(sqlite3_open(dbPath.path!, &db) == SQLITE_OK))
            {
                print("Unable to create database")
                
            }else{
                print("Database: " + database + " successfully created ")
                databases.append(database)
                sqlite3_close(db);
            }
        } catch let err as NSError {
            print("Error: \(err.domain)")
        }
    }
    
    
    func attachDatabase(_ dbName:String, schemaName:String){
        var err:UnsafeMutablePointer<Int8>? = nil
            if(!(sqlite3_open( dbPath.path!, &db) == SQLITE_OK))
            {
                print("An error has occured.")
                
            }else{
                let dbstatus = sqlite3_open(dbName, &db)
                print(dbstatus)
                if(sqlite3_open(dbName, &db) == SQLITE_OK){
                    let attachSQL = "ATTACH DATABASE '\(dbName)' AS '\(schemaName)'"
                    var status = sqlite3_exec(db, attachSQL, nil, &sqlStatement, &err)
                    if(status != SQLITE_OK)
                    {
                        print("Problem with prepare statement " + String(sqlite3_errcode(db)));
                    }
                    if (status == SQLITE_OK) {
                        
                        print("Database : " + dbName + " attached as " + schemaName)
                        
                    }
                    status = sqlite3_prepare_v2(db, "PRAGMA database_list", -1, &sqlStatement, nil)
                    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
                        print(sqlite3_column_int(sqlStatement, 0))
                        print(sqlite3_column_text(sqlStatement, 1))
                        
                    }

                    
                }
                
               // sqlite3_finalize(sqlStatement);
              //  sqlite3_close(db);
            }
    }
    
    func detachDatabase(_ dbName:String, schemaName:String){
         var err:UnsafeMutablePointer<Int8>? = nil
        if(!(sqlite3_open(dbPath.path!, &db) == SQLITE_OK))
        {
            print("An error has occured.")
            
        }else{
            let detachSQL = "DETACH DATABASE '\(schemaName)' "
            var status = sqlite3_exec(db, detachSQL, nil, &sqlStatement, &err)
        
                
                status = sqlite3_prepare_v2(db, "PRAGMA database_list", -1, &sqlStatement, nil)
                while(sqlite3_step(sqlStatement) == SQLITE_ROW){
                    print(sqlite3_column_int(sqlStatement, 0))
                    print(sqlite3_column_text(sqlStatement, 1))
           
                }
                
                sqlite3_finalize(sqlStatement);
                sqlite3_close(db);
           
          
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return databases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dbname:String = databases[row]
        
        return  dbname
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        attachDb = databases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 56.0
    }



}

