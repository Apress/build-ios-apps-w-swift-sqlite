//
//  WineryListTableViewController.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-31.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class WineryListTableViewController: UITableViewController {
    var wineryListArray = [Wineries]()
    let wineDAO:WineryDAO = WineryDAO()
    
    func loadWineList(){
        wineryListArray = wineDAO.selectWineriesList()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWineList()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
       
        return wineryListArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineryCellTableViewCell", for: indexPath) as! WineryCellTableViewCell
        let winery:Wineries = wineryListArray[(indexPath as NSIndexPath).row]
       
       
        cell.wineryNameOutlet.text = winery.name
        cell.regionOutlet.text = winery.region
        cell.countryOutlet.text = winery.country
        cell.volumeOutlet.text = String(winery.volume)
        cell.uomOutlet.text = winery.uom
 
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
            // Delete the row from the data source
            let winery:Wineries = wineryListArray[(indexPath as NSIndexPath).row]
            tableView.deleteRows(at: [indexPath], with: .fade)
             wineDAO.deleteWineryRecord(winery.name)
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
        if(segue.identifier == "showWineryDetail"){
            let wineryController = segue.destination as! SecondViewController
            if let wineryCell = sender as? WineryCellTableViewCell {
                let indexPath = tableView.indexPath(for: wineryCell)!
                let selectedWinery = wineryListArray[(indexPath as NSIndexPath).row]
                wineryController.winery = selectedWinery
                wineryController.isEdit = 1
                                
            }
        }
       
    }


}
