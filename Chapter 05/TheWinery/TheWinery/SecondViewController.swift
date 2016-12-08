//
//  SecondViewController.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-06.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wineryNameField: UITextField!
    
    @IBOutlet weak var countryNameField: UITextField!
    
    @IBOutlet weak var regionNameField: UITextField!
    
    @IBOutlet weak var enterVolume: UITextField!
    
    @IBOutlet weak var enterUoM: UITextField!
    
    var dbDAO:WineryDAO = WineryDAO()
    var winery:Wineries = Wineries()
    var isEdit:Int = -1
    
    
    @IBAction func insertWineryBtn(_ sender: AnyObject) {
        winery.name = wineryNameField.text!
        winery.country = countryNameField.text!
        winery.region = regionNameField.text!
        winery.volume = Double(enterVolume.text!)!
        winery.uom = enterUoM.text!
      
        if(winery.isEdit==1){
            dbDAO.wineryUpdate(winery)
        }else{
            dbDAO.insertWineryRecord(winery)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        wineryNameField.delegate = self
        countryNameField.delegate = self
        regionNameField.delegate = self
        enterVolume.delegate = self
        enterUoM.delegate = self
        
        wineryNameField.text = winery.name
        countryNameField.text = winery.country
        regionNameField.text = winery.region
        enterVolume.text = String(winery.volume)
        enterUoM.text = winery.uom
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
   

}

