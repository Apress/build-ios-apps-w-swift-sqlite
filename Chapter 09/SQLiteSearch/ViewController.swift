//
//  ViewController.swift
//  SQLiteSearch
//
//  Created by Kevin Languedoc on 2016-08-17.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource   {

    @IBOutlet weak var searchField: UISearchBar!

    @IBOutlet weak var searchResults: UITableView!
    
    
    var nameList = [String]()
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.searchField.text=""
        searchResults.reloadData()
        searchField.resignFirstResponder()
        self.view.endEditing(true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchDatabase(searchField.text!)
        self.searchField.text=""
        searchResults.reloadData()
        searchField.resignFirstResponder()
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.delegate = self
        searchField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchDatabase(_ searchTerm:String){
        var fileExist:Bool = false
        var db:OpaquePointer? = nil
        var sqlStatement:OpaquePointer?=nil
       
        let projectBundle = Bundle.main
        let fileMgr = FileManager.default
        let resourcePath = projectBundle.path(forResource: "dbsearch", ofType: "sqlite")
        
        fileExist = fileMgr.fileExists(atPath: resourcePath!)
        
        if(fileExist){
            
            if(!(sqlite3_open(resourcePath!, &db) == SQLITE_OK))
            {
                print("An error has occured.")
                
            }else{
                
                let sqlQry = "SELECT firstname,lastname  FROM  names where firstname=? or lastname=?"
                if(sqlite3_prepare_v2(db, sqlQry, -1, &sqlStatement, nil) != SQLITE_OK)
                {
                    print("Problem with prepare statement " + String(sqlite3_errcode(db)));
                }
                sqlite3_bind_text(sqlStatement, 0, searchTerm, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(sqlStatement, 1, searchTerm, -1, SQLITE_TRANSIENT)
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    
                    let concatName:String = String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement,0))) + " " + String(cString: UnsafePointer<Int8>(sqlite3_column_text(sqlStatement,1)))
                    
                    print("This is the name : " + concatName)
                    nameList.append(concatName)
                }
                sqlite3_finalize(sqlStatement);
                sqlite3_close(db);
            }
            
        }
 
    }
    func tableView(_ tableView: UITableView,
                     cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! searchResultCellTableViewCell
        
        // Configure the cell...
        let nameObj = nameList[(indexPath as NSIndexPath).row]
        cell.famousName.text = nameObj
       
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    func tableView(_ tableView: UITableView,
                     numberOfRowsInSection section: Int) -> Int{
        return nameList.count
    }
    


}

