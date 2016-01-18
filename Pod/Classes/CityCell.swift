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

public class CityCell : UICollectionViewCell,BXBindable {
  let nameLabel = UILabel(frame:CGRectZero)
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  public func bind(item:BXCity){
    nameLabel.text  = item.name
  }
  
  override public func awakeFromNib() {
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
    nameLabel.pinEdge(UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2))
    
  }
  
  func setupAttrs(){
    nameLabel.textColor = UIColor.darkTextColor()
    nameLabel.font = UIFont.systemFontOfSize(14)
    nameLabel.minimumScaleFactor = 11.0 / 14.0
    nameLabel.textAlignment = .Center
    backgroundColor = .whiteColor()
    layer.cornerRadius = 2
  }
  
  public override var highlighted: Bool{
    didSet{
      backgroundColor = highlighted ? UIColor(white: 0.912, alpha: 1.0): UIColor.whiteColor()
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
