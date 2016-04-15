//
//  OtherCityHeaderView.swift
//  Pods
//
//  Created by Haizhen Lee on 16/1/18.
//
//

import Foundation

// Build for target uimodel
//locale (None, None)
import UIKit
import SwiftyJSON
import BXModel
import PinAuto

// -OtherCityHeaderView:v
// title[l15,y](f15,cdt)

public class OtherCityHeaderView : UIView{
  public let titleLabel = UILabel(frame:CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  var allOutlets :[UIView]{
    return [titleLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [titleLabel]
  }
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    titleLabel.pa_centerY.install()
    titleLabel.pa_leading.eq(15).install()
    titleLabel.pa_trailing.eq(15).install()
    
  }
  
  func setupAttrs(){
    titleLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    titleLabel.font = UIFont.systemFontOfSize(15)
    
    titleLabel.text = "其他城市"
  }
}