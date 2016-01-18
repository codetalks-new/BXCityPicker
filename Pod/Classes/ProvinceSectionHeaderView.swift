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
import PinAutoLayout

// -ProvinceSectionHeaderView(m=BXProvince):cc
// name[l15,y](f15,cdt)

class ProvinceSectionHeaderView: UICollectionViewCell,BXBindable {
  let nameLabel = UILabel(frame:CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  func bind(item:String){
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
    nameLabel.pinCenterY()
    nameLabel.pinLeading(15)
    
  }
  
  func setupAttrs(){
    nameLabel.textColor = UIColor.darkTextColor()
    nameLabel.font = UIFont.systemFontOfSize(15)
    backgroundColor = UIColor(white: 0.912, alpha: 1.0)
  }
}
