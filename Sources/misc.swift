//
//  misc.swift
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
import QuartzCore

// MARK: - Animations.

/// Breath animation.
///
/// - parameter reapeating: repeat count of animation.
/// - parameter duration: animation duration.
///
/// - returns: breath animation.
internal func createBreathingAnimation(
  repeating: Float = .greatestFiniteMagnitude,
  duration: TimeInterval) -> CABasicAnimation
{
  let animation = CABasicAnimation(keyPath: "opacity")
  animation.fromValue = 1.0
  animation.toValue = 0.1
  animation.autoreverses = true
  animation.duration = duration
  animation.repeatCount = repeating
  animation.isRemovedOnCompletion = false
  animation.timingFunction = CAMediaTimingFunction(name: .linear)
  animation.fillMode = .forwards
  return animation
}

/// Rotation animation
///
/// - parameter duration: animation duration.
/// - parameter degree: the degree to rotate.
/// - parameter direction: the direction to rotate. Support values: [x, y, z].
/// - parameter repeatCount: repeat count of animation.
///
/// - returns: rotation animation.
internal func createRotationAnimation(
  duration: TimeInterval,
  degree: CGFloat,
  direction: String,
  repeatCount: Float) -> CABasicAnimation
{
  var animation: CABasicAnimation!
  animation = CABasicAnimation(keyPath: "transform.rotation.\(direction)")
  animation.fromValue = 0
  animation.toValue = degree
  animation.autoreverses = true
  animation.duration = duration
  animation.repeatCount = repeatCount
  animation.isRemovedOnCompletion = false
  animation.fillMode = .forwards
  return animation
}

/// Scale animation.
///
/// - parameter fromScale: scale value to begin.
/// - parameter duration:  animation duration.
/// - parameter repeatCount: repeat count of animation.
///
/// - returns: scale animation.
internal func createScaleAnimation(
  fromScale from: Float,
  toScale: Float,
  duration: TimeInterval,
  repeatCount: Float) -> CABasicAnimation
{
  let animation = CABasicAnimation(keyPath: "transform.scale")
  animation.fromValue = from
  animation.toValue = toScale
  animation.duration = duration
  animation.autoreverses = true
  animation.repeatCount = repeatCount
  animation.isRemovedOnCompletion = false
  animation.fillMode = .forwards
  return animation
}

/// Shake animation.
///
/// - parameter repeatCount: time
/// - parameter duration:    duration
/// - parameter fromLayer:   layer to add begin.
///
/// - returns: shake animation.
internal func createShakeAnimation(
  repeatCount: Float,
  duration: TimeInterval,
  fromLayer layer: CALayer) -> CAKeyframeAnimation
{
  let originSize = layer.bounds.size
  let hOffset = originSize.width/4
  let animation = CAKeyframeAnimation(keyPath: "transform")
  animation.values = [
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(-hOffset, 0, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(hOffset, 0, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))
  ]
  animation.repeatCount = repeatCount
  animation.duration = duration
  animation.fillMode = .forwards
  return animation
}

/// Bounce animation.
///
/// - parameter repeatCount: count of repeat times.
/// - parameter duration:    duration of animation.
/// - parameter fromLayer:   layer to add begin.
///
/// - returns: bounce animation.
internal func createBounceAnimation(
  repeatCount: Float,
  duration: TimeInterval,
  fromLayer layer: CALayer) -> CAKeyframeAnimation
{
  let originSize = layer.bounds.size
  let hOffset = originSize.height / 4.0
  let animation = CAKeyframeAnimation(keyPath: "transform")
  animation.values = [
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, -hOffset, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, hOffset, 0)),
    NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))
  ]
  animation.repeatCount = repeatCount
  animation.duration = duration
  animation.fillMode = .forwards
  return animation
}
