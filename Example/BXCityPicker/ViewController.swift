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
    let resultLabel =  UILabel()
    let pickProvinceButton = UIButton(type: .system)
    let pickCityButton = UIButton(type: .system)
    let pickDistrictButton = UIButton(type: .system)
    let selectCityButton = UIButton(type: .system)
  
  var allButtons: [(UIButton,String)]{
    return [
      (pickProvinceButton, "弹出省份选择"),
      (pickCityButton, "弹出城市选择"),
      (pickDistrictButton, "弹出地区选择"),
      (selectCityButton, "全功能城市选择器"),
    ]
  }
  
  override func loadView() {
    super.loadView()
    view.addSubview(resultLabel)
    resultLabel.translatesAutoresizingMaskIntoConstraints = false
    resultLabel.pa_below(topLayoutGuide, offset: 32).install()
    resultLabel.pa_centerX.install()
   
    var prevView: UIView = resultLabel
    for (button, title) in allButtons{
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.pa_centerX.install()
        button.pa_below(prevView, offset: 8).install()
      button.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        prevView = button
    }
    
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      title = "城市地区选择器"
    }

  func onButtonPressed(sender: UIButton){
    switch sender {
    case pickCityButton:
      chooseCity{ (province, city) in
          let addr = "\(province.name) \(city.name)"
          self.resultLabel.text = addr
      }
    case pickDistrictButton:
      chooseDistrict{ ( province, city, district) in
          let addr = "\(province.name) \(city.name) \(district.name)"
          self.resultLabel.text = addr
      }
      
    case selectCityButton:
      selectCity{ (province,city) in
          let addr = "\(province.name) \(city.name)"
          self.resultLabel.text = addr
      }
    default:
      break
    }
  }

  
  func readRegion() -> [Province]{
    let path = Bundle.main.path(forResource: "region", ofType: "json")
    let content = try? String(contentsOfFile: path!)
    let json = JSON.parse(content!)
    return Province.arrayFrom(json["data"])
  }
}

