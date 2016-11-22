//
//  SearchIndexHotItemCell.swift
//  VV3CV4
//
//  Created by Haizhen Lee on 15/12/13.
//  Copyright © 2015年 vv3c. All rights reserved.
//

import Foundation

// Build for target uimodel
//locale (None, None)
import UIKit
import SwiftyJSON
import BXModel

// -CityCell(m=SearchIndexItem):cc
// name[e0,h30](f15,cdt)

open class CityCell : UICollectionViewCell,BXBindable {
  let nameLabel = UILabel(frame:CGRect.zero)
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  open func bind(_ item:BXCity){
    nameLabel.text  = item.name
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  var allOutlets :[UIView]{
    return [nameLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [nameLabel]
  }
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    translatesAutoresizingMaskIntoConstraints = false
    for childView in allOutlets{
      contentView.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    nameLabel.pac_edge(UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2))
    
  }
  
  func setupAttrs(){
    nameLabel.textColor = UIColor.darkText
    nameLabel.font = UIFont.systemFont(ofSize: 14)
    nameLabel.minimumScaleFactor = 11.0 / 14.0
    nameLabel.textAlignment = .center
    backgroundColor = .white
    layer.cornerRadius = 2
  }
  
  open override var isHighlighted: Bool{
    didSet{
      backgroundColor = isHighlighted ? UIColor(white: 0.912, alpha: 1.0): UIColor.white
    }
  }
  
  
  
//  override func drawRect(rect: CGRect) {
//    super.drawRect(rect)
//    UIColor(white: 0.912, alpha: 1.0).set()
//    let path = UIBezierPath(roundedRect: rect, cornerRadius: 2)
//    path.stroke()
//    
//  }
}
