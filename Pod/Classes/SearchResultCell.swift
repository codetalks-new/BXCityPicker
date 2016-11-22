//
//  SearchResultCell.swift
//  Pods
//
//  Created by Haizhen Lee on 15/12/22.
//
//

import UIKit
import BXModel

class SearchResultCell:UITableViewCell,BXBindable{
  func bind(_ item: BXCity) {
    textLabel?.text = item.name
  }
}
