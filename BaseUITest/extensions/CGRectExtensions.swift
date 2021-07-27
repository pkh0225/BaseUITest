//
//  CGRectExtensions.swift
//  Qorum
//
//  Created by Goktug Yilmaz on 26/08/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// 0.5 단위 버림 처림
/// 0.5 작으면 0
/// 0.5 보다 크면 0.5
/// - Returns: 0.5 단위 버림 처리
@inline(__always) public func floorUI(_ value: CGFloat) -> CGFloat {
    let roundValue = round(value)
    let floorValue = floor(value)
    if roundValue == floorValue {
        return CGFloat(roundValue)
    }
    return CGFloat(roundValue - 0.5)
}

/// 0.5 단위 올림 처리
/// 0.5 작으면 0.5
/// 0.5 보다 크면 1
/// - Returns: 0.5 단위 올림 처리
@inline(__always) public func ceilUI(_ value: CGFloat) -> CGFloat {
    let roundValue = round(value)
    let ceilValue = ceil(value)
    if roundValue == ceilValue {
        return CGFloat(roundValue)
    }
    return CGFloat(roundValue + 0.5)
}

extension CGRect {
    ///   Easier initialization of CGRect
    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }

    ///   X value of CGRect's origin
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        set(value) {
            self.origin.x = value
        }
    }

    ///   Y value of CGRect's origin
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        set(value) {
            self.origin.y = value
        }
    }

    ///   Width of CGRect's size
    public var w: CGFloat {
        get {
            return self.size.width
        }
        set(value) {
            self.size.width = value
        }
    }

    ///   Height of CGRect's size
    public var h: CGFloat {
        get {
            return self.size.height
        }
        set(value) {
            self.size.height = value
        }
    }

    /// EZSE : Surface Area represented by a CGRectangle
    public var area: CGFloat {
        return self.h * self.w
    }

    public var center: CGPoint {
        get {
            return CGPoint(x: x + (w / 2.0), y: y + (h / 2.0))
        }
        set {
            x = newValue.x - (w / 2.0)
            y = newValue.y - (h / 2.0)
        }
    }
}

extension CGSize {
    public func ratioSize(setWidth: CGFloat) -> CGSize {
        return CGSize(width: setWidth, height: ratioHeight(setWidth: setWidth) )
    }

    public func ratioHeight(setWidth: CGFloat) -> CGFloat {
        guard self.width != 0 else { return 0 }
        if self.width == setWidth {
            return self.height
        }
        let origin: CGFloat = self.height * setWidth / self.width
        return ceilUI(origin)
    }

    public func ratioWidth(setHeight: CGFloat) -> CGFloat {
        guard self.height != 0 else { return 0 }
        if self.height == setHeight {
            return self.width
        }
        let origin: CGFloat = self.width * setHeight / self.height
        return ceilUI(origin)
    }

    public var w: CGFloat {
        get {
            return self.width
        }
        set(value) {
            self.width = value
        }
    }

    public var h: CGFloat {
        get {
            return self.height
        }
        set(value) {
            self.height = value
        }
    }
}

#endif
