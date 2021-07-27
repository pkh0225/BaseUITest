//
//  UICollectionViewExtension.swift
//  WiggleSDK
//
//  Created by pkh on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

private var cacheNibs = NSCache<NSString, UINib>()

func isXibFileExists(_ fileName: String) -> Bool {
    if let path: String = Bundle.main.path(forResource: fileName, ofType: "nib") {
        if FileManager.default.fileExists(atPath: path) {
            return true
        }
    }
    return false
}

extension UICollectionView {
    private struct AssociatedKeys {
        static var registerCellName: UInt8 = 0
        static var registerHeaderName: UInt8 = 0
        static var registerFooterName: UInt8 = 0
    }

    public var registerCellNames: Set<String> {
        get {
            if let result: Set<String> = objc_getAssociatedObject(self, &AssociatedKeys.registerCellName) as? Set<String> {
                return result
            }
            let result: Set<String> = Set<String>(minimumCapacity: 100)
            objc_setAssociatedObject(self, &AssociatedKeys.registerCellName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerCellName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var registerHeaderNames: Set<String> {
        get {
            if let result: Set<String> = objc_getAssociatedObject(self, &AssociatedKeys.registerHeaderName) as? Set<String> {
                return result
            }
            let result: Set<String> = Set<String>(minimumCapacity: 100)
            objc_setAssociatedObject(self, &AssociatedKeys.registerHeaderName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerHeaderName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var registerFooterNames: Set<String> {
        get {
            if let result: Set<String> = objc_getAssociatedObject(self, &AssociatedKeys.registerFooterName) as? Set<String> {
                return result
            }
            let result: Set<String> = Set<String>(minimumCapacity: 100)
            objc_setAssociatedObject(self, &AssociatedKeys.registerFooterName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerFooterName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func registerDefaultCell() {
        register(UICollectionViewCell.self)
        registerHeader(UICollectionReusableView.self)
        registerFooter(UICollectionReusableView.self)
    }

    public func register(_ Classs: UICollectionViewCell.Type...) {
        for Class: UICollectionViewCell.Type in Classs {
            guard registerCellNames.contains(Class.className) == false else { continue }

            registerCellNames.insert(Class.className)
            if isXibFileExists(Class.className) {
                registerNibCell(Class)
            }
            else {
                register(Class, forCellWithReuseIdentifier: Class.className)
            }
        }
    }

    public func register(Class: UICollectionViewCell.Type, withReuseIdentifier: String) {
        guard registerCellNames.contains(withReuseIdentifier) == false else { return }

        registerCellNames.insert(withReuseIdentifier)
        if isXibFileExists(Class.className) {
            registerNibCell(Class: Class, withReuseIdentifier: withReuseIdentifier)
        }
        else {
            register(Class, forCellWithReuseIdentifier: withReuseIdentifier)
        }
    }

    public func registerHeader(_ Classs: UICollectionReusableView.Type...) {
        for Class: UICollectionReusableView.Type in Classs {
            guard registerHeaderNames.contains(Class.className) == false else { continue }

            registerHeaderNames.insert(Class.className)
            if isXibFileExists(Class.className) {
                registerNibCellHeader(Class)
            }
            else {
                register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className)
            }
        }
    }

    public func registerHeader(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        guard registerHeaderNames.contains(withReuseIdentifier) == false else { return }

        registerHeaderNames.insert(withReuseIdentifier)
        if isXibFileExists(Class.className) {
            registerNibCellHeader(Class: Class, withReuseIdentifier: withReuseIdentifier)
        }
        else {
            register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: withReuseIdentifier)
        }
    }

    public func registerFooter(_ Classs: UICollectionReusableView.Type...) {
        for Class: UICollectionReusableView.Type in Classs {
            guard registerFooterNames.contains(Class.className) == false else { continue }

            registerFooterNames.insert(Class.className)
            if isXibFileExists(Class.className) {
                registerNibCellFooter(Class)
                return
            }
            else {
                register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className)
            }
        }
    }

    public func registerFooter(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        guard registerFooterNames.contains(Class.className) == false else { return }

        registerFooterNames.insert(Class.className)
        if isXibFileExists(Class.className) {
            registerNibCellFooter(Class: Class, withReuseIdentifier: withReuseIdentifier)
            return
        }
        else {
            register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: withReuseIdentifier)
        }
    }

    private func getNib(className: String) -> UINib {
        if let nib = cacheNibs.object(forKey: className as NSString) {
            return nib
        }

        let nib = UINib(nibName: className, bundle: nil)
        cacheNibs.countLimit = 100
        cacheNibs.setObject(nib, forKey: className as NSString)
        return nib
    }

    public func registerNibCell(_ Classs: UICollectionViewCell.Type...) {
        Classs.forEach { (Class: UICollectionViewCell.Type) in
            register(getNib(className: Class.className), forCellWithReuseIdentifier: Class.className)
        }
    }

    public func registerNibCell(Class: UICollectionViewCell.Type, withReuseIdentifier: String) {
        register(getNib(className: Class.className), forCellWithReuseIdentifier: withReuseIdentifier)
    }

    public func registerNibCellHeader(_ Classs: UICollectionReusableView.Type...) {
        Classs.forEach { (Class: UICollectionReusableView.Type) in
            register(getNib(className: Class.className), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className)
        }
    }

    public func registerNibCellHeader(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        register(getNib(className: Class.className), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: withReuseIdentifier)
    }

    public func registerNibCellFooter(_ Classs: UICollectionReusableView.Type...) {
        Classs.forEach { (Class: UICollectionReusableView.Type) in
            register(getNib(className: Class.className), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className)
        }
    }

    public func registerNibCellFooter(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        register(getNib(className: Class.className), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: withReuseIdentifier)
    }

    public func registerCustomKindReusableView(_ Class: UICollectionReusableView.Type, _ Kind: String, _ identifier: String) {
        register(Class, forSupplementaryViewOfKind: Kind, withReuseIdentifier: identifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: Class.className, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(_ Class: T.Type, for indexPath: IndexPath, withReuseIdentifier: String) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }

    public func dequeueReusableHeader<T: UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className, for: indexPath) as! T
        view.indexPath = indexPath
        return view
    }

    public func dequeueReusableHeader<T: UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath, withReuseIdentifier: String) -> T {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: withReuseIdentifier, for: indexPath) as! T
        view.indexPath = indexPath
        return view
    }

    public func dequeueReusableFooter<T: UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className, for: indexPath) as! T
        view.indexPath = indexPath
        return view
    }

    public func dequeueDefaultSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        view.indexPath = indexPath
        return view
    }

    public func realodSectionWithoutAnimation(_ indexPath: IndexPath) {
        self.realodSectionWithoutAnimation(indexPath.section)
    }

    public func realodSectionWithoutAnimation(_ section: Int) {
        UIView.setAnimationsEnabled(false)
        self.performBatchUpdates({
            self.reloadSections([section])
        }, completion: { _ in
            UIView.setAnimationsEnabled(true)
        })
    }

    public func setTabTouchScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.scrollsToTop = false

        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.scrollsToTop = true
        }
    }

    public func scrollToItemIfPaging(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        // iOS 14에서 paging 있는 scrollToItem에 버그가 있으므로 아래와 같이 처리
        // 참고 URL: https://developer.apple.com/forums/thread/663156
        guard self.isPagingEnabled else {
            self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            return
        }
        if #available(iOS 14, *) {
            self.isPagingEnabled = false
            self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            self.isPagingEnabled = true
        }
        else {
            self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        }
    }

    public func reloadDataAndInvalidateLayout() {
        self.reloadData()
        if #available(iOS 12, *) {
        }
        else {
            self.collectionViewLayout.invalidateLayout()
        }
    }

    /// 다음페이지를 호출해야 하는 검사
    /// willDisplay에서 호출해 주세요
    /// - Parameter cell: cell
    /// - Returns: 체크값
    public func checkMorePage(cell: UICollectionViewCell) -> Bool {
        return (contentSize.height - cell.frame.maxY) < (h * 4)
    }
}

extension UICollectionReusableView {
    private struct AssociatedKeys {
        static var indexPath: UInt8 = 0
        static var allRow: UInt8 = 0
    }
    public var indexPath: IndexPath {
        get {
            if let indexPath: IndexPath = objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath {
                return indexPath
            }
            return IndexPath(row: 0, section: 0)

        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Adapter에서만 제공
    public var allRow: Int {
        get {
            if let allRow: Int = objc_getAssociatedObject(self, &AssociatedKeys.allRow) as? Int {
                return allRow
            }
            return -1

        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.allRow, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

}
