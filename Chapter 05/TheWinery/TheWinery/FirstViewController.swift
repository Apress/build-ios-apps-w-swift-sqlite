//
//  FirstViewController.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-06.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var imageSelector: UIImagePickerController!
    var imageData:Data = Data()
    var dbDAO:WineryDAO = WineryDAO()
    var wine:Wine = Wine()
    var wineriesArray = [Wineries]()
    var wineriesPickerView: UIPickerView = UIPickerView()
    var vintnor:Wineries = Wineries()
    var isEdit:Int = -1
    

    @IBAction func selectWineryButton(_ sender: AnyObject) {
         self.wineriesPickerView.isHidden = false
    }
    @IBAction func insertRecordAction(_ sender: AnyObject) {
        if(isEdit==1){
            //we should update
            let editWine = Wine()
            editWine.name = self.wineNameField.text!
            editWine.producer = self.selectWineryField.text!
            editWine.rating = Int32(self.wineRatingSetter.value)
            dbDAO.wineUpdate(editWine)
        }else{
            wine.name = self.wineNameField.text!
            wine.producer = self.selectWineryField.text!
            dbDAO.insertWineRecord(wine)
        }
    }
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        imageSelector =  UIImagePickerController()
        imageSelector.delegate = self
        imageSelector.sourceType = .camera
        
   
        present(imageSelector, animated: true, completion: nil)
        
        
    }
  
    @IBOutlet weak var wineRatingSetter: UISlider!
    
    @IBOutlet weak var selectWineryPicker: UIPickerView!
    @IBOutlet weak var selectWineryField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var wineNameField: UITextField!
    
    @IBOutlet weak var countryNameField: UITextField!
    

    
    @IBAction func wineRatingSlider(_ sender: AnyObject) {
        
        let ratingValue:float_t = sender.value
        wine.rating  = Int32(ratingValue)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //build data source
       //dbDAO.getWinerySchema()
        self.wineriesArray = dbDAO.selectWineriesList()
       
        
        self.wineriesPickerView.isHidden = true
        self.wineriesPickerView.dataSource = self
        self.wineriesPickerView.delegate = self
        self.wineriesPickerView.frame = CGRect(x: 19, y: 243, width: 336, height: 216)
        self.wineriesPickerView.backgroundColor = UIColor.white
        self.wineriesPickerView.layer.borderColor = UIColor.blue.cgColor
        self.wineriesPickerView.layer.borderWidth = 1
       
        
        //other pickerView code like dataSource and delegate
        self.view.addSubview(wineriesPickerView)
        
        
        wineNameField.delegate = self
        countryNameField.delegate = self
        
        self.wineNameField.text = wine.name
        self.wineRatingSetter.value = Float(wine.rating)
       
        self.imageView.image = UIImage(data: wine.image as Data)
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        imageSelector.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        wine.image = UIImagePNGRepresentation(imageView.image!)!
      
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wineriesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        vintnor = wineriesArray[row] as Wineries
        let pickernames = vintnor.name
        return  pickernames
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vintnor = wineriesArray[row] as Wineries
        selectWineryField.text = vintnor.name
        
        wineriesPickerView.endEditing(true)
        wineriesPickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 56.0
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }

    
   
  
   



}

