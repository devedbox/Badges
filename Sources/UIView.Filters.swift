//
//  UIView.Filters.swift
//  Badge
//
//  Created by devedbox on 2018/9/14.
//  Copyright © 2018 devedbox. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
