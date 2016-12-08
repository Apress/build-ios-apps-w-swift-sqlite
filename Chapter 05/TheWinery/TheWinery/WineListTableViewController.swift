//
//  WineListTableViewController.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-31.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class WineListTableViewController: UITableViewController {

    
    var wineListArray = [Wine]()
    let wineDAO:WineryDAO = WineryDAO()
    
    func loadWineList(){
        wineListArray = wineDAO.selectWineList()
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWineList()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wineListArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineCellTableViewCell", for: indexPath) as! WineCellTableViewCell

        // Configure the cell...
        let wine = wineListArray[(indexPath as NSIndexPath).row]
       
        cell.wineRatingOutlet.text = String(wine.rating)
        cell.wineNameOutlet.text = wine.name
        cell.wineryNameOutlet.text = wine.producer
        cell.wineImageOutlet.image =  UIImage.init(data: wine.image as Data)

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let wine = wineListArray[(indexPath as NSIndexPath).row]
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            wineDAO.deleteWineRecord(wine.name)
            tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
         if(segue.identifier == "showWineDetail"){
            let wineViewController = segue.destination as! FirstViewController
            if let wineCell = sender as? WineCellTableViewCell{
                
                let indexPath = tableView.indexPath(for: wineCell)!
                let selectedWine = wineListArray[(indexPath as NSIndexPath).row]
                wineViewController.wine = selectedWine
                wineViewController.isEdit = 1
            }
        }
       
    
       
        
    }


}
