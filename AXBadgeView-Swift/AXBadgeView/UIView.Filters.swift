//
//  UIView.Filters.swift
//  AXBadgeView-Swift
//
//  Created by devedbox on 2018/9/14.
//  Copyright © 2018 devedbox. All rights reserved.
//

import UIKit

// MARK: - UIView.

internal extension UIView {
  /// Returns the end points views in all the subviews of the receiver view.
  internal func endpoints(
    where filter: (UIView) throws -> Bool = { _ in true }) rethrows -> [UIView]
  {
    guard !subviews.isEmpty else {
      return [self]
    }
    var views: [UIView] = []
    
    for view in subviews {
      if view.subviews.isEmpty, try filter(view) {
        views.append(view)
      } else {
        views.append(contentsOf: try view.endpoints(where: filter))
      }
    }
    
    return views
  }
  
  /// Returns the view of min y position of all ennpoints subviews.
  internal func viewInEndpointsOfMinY(
    where filter: (UIView) throws -> Bool = { _ in true }) rethrows -> UIView
  {
    return try endpoints(where: filter).reduce(nil) { result, aview -> UIView? in
      if let resultView = result {
        return
          aview.convert(aview.frame, to: self).minY
       <= resultView.convert(resultView.frame, to: self).minY
        ? aview
        : result
      }
      return aview
    }!
  }
}
