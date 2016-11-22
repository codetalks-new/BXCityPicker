//
//  ProvinceSectionHeaderView.swift
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

// -ProvinceSectionHeaderView(m=BXProvince):cc
// name[l15,y](f15,cdt)

class ProvinceSectionHeaderView: UICollectionViewCell,BXBindable {
  let nameLabel = UILabel(frame:CGRect.zero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  func bind(_ item:String){
    nameLabel.text  =  item
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  var allOutlets :[UIView]{
    return [nameLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [nameLabel]
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    for childView in allOutlets{
      contentView.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    nameLabel.pa_centerY.install()
    nameLabel.pa_leading.eq(15).install()
    
  }
  
  func setupAttrs(){
    nameLabel.textColor = UIColor.darkText
    nameLabel.font = UIFont.systemFont(ofSize: 15)
    backgroundColor = UIColor(white: 0.912, alpha: 1.0)
  }
}
