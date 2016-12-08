//
//  Wine.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-06.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import Foundation

class Wine: NSObject {
    var id:Int32 = 0
    var name:String = ""
    var rating:Int32 = 0
    var image:Data = Data()
    var producer:String = ""
    var isEdit:Int32 = 0
    
    override init(){
        
    }
}


