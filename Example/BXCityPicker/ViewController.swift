//
//  ViewController.swift
//  BXCityPicker
//
//  Created by banxi1988 on 12/22/2015.
//  Copyright (c) 2015 banxi1988. All rights reserved.
//

import UIKit
import SwiftyJSON
import BXCityPicker



extension City:BXCity{
}

extension Province:BXProvince{
  typealias CityType = City
  func cityList() -> [City]{
    return self.city
  }

}

class ViewController: UIViewController {
  @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func pickCity(sender: AnyObject) {
    let provinces = readRegion()
    let vc = BXCityPickerController<Province,City>()
    vc.updateProvinces(provinces)
    showViewController(vc, sender: self)
  }
  
  
  func readRegion() -> [Province]{
    let path = NSBundle.mainBundle().pathForResource("region", ofType: "json")
    let content = try? String(contentsOfFile: path!)
    let json = JSON.parse(content!)
    return Province.arrayFrom(json["data"])
  }
}

