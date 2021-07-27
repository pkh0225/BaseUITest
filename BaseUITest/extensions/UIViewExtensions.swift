//  UIViewExtensions.swift
//

#if os(iOS) || os(tvOS)

import UIKit

public var cacheViewNibs = NSCache<NSString, UIView>()
private var cacheNibs = NSCache<NSString, UINib>()

public enum VIEW_ADD_TYPE {
    case horizontal
    case vertical
}

public struct GoneType: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let leading = GoneType(rawValue: 1 << 0)
    public static let trailing = GoneType(rawValue: 1 << 1)
    public static let top = GoneType(rawValue: 1 << 2)
    public static let bottom = GoneType(rawValue: 1 << 3)
    public static let width = GoneType(rawValue: 1 << 4)
    public static let height = GoneType(rawValue: 1 << 5)

    public static let size: GoneType = [.width, .height]

    public static let widthLeading: GoneType = [.width, .leading]
    public static let widthTrailing: GoneType = [.width, .trailing]
    public static let widthPadding: GoneType = [.width, .leading, .trailing]

    public static let heightTop: GoneType = [.height, .top]
    public static let heightBottom: GoneType = [.height, .bottom]
    public static let heightPadding: GoneType = [.height, .top, .bottom]

    public static let padding: GoneType = [.leading, .trailing, .top, .bottom]
    public static let all: GoneType = [.leading, .trailing, .top, .bottom, .width, .height]
}

extension NSLayoutConstraint.Attribute {
    var string: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            return ""
        }
    }
}

private class ViewDidAppearCADisplayLink {
    static let shared = ViewDidAppearCADisplayLink()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    var displayLink: CADisplayLink?
    var views: [UIView] = [UIView]() {
        didSet {
            DispatchQueue.main.async {
                if self.views.count > 0 {
                    if self.displayLink == nil {
                        self.start()
                    }
                }
                else {
                    self.stop()
                }
            }
        }
    }

    @objc func applicationDidEnterBackgroundNotification() {
        stop()
        DispatchQueue.main.async {
            for view: UIView in self.views {
                self.setViewVisible(view: view, isVisible: false)
            }
        }
    }

    @objc func applicationDidBecomeActiveNotification() {
        DispatchQueue.main.async {
            for view: UIView in self.views {
                self.setViewVisible(view: view, isVisible: true)
            }
        }
        start()
    }

    @objc private func onViewDidAppear() {
        guard self.views.count > 0 else {
            stop()
            return
        }

        DispatchQueue.main.async {
            for view: UIView in self.views.reversed() {
                autoreleasepool {
                    self.setViewVisible(view: view, isVisible: view.isVisible)
                    let windowRect: CGRect = view.superview?.convert(view.frame, to: nil) ?? .zero
                    if windowRect == .zero {
                        view.viewDidAppear?(false)
                        view.viewDidAppear = nil
                        self.views.remove(object: view)
                    }
                }
            }
        }
    }

    func setViewVisible(view: UIView, isVisible: Bool) {
        if view.viewDidAppearIsVisible != isVisible {
            view.viewDidAppearIsVisible = isVisible
            view.viewDidAppear?(isVisible)
        }
    }

    func start() {
        stop()
        displayLink = CADisplayLink(target: self, selector: #selector(onViewDidAppear))
        displayLink?.add(to: .main, forMode: .common)
        displayLink?.preferredFramesPerSecond = 5
    }

    func stop() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }

}

extension UIView {
    private struct AssociatedKeys {
//        static var viewDidDisappear: UInt8 = 0
//        static var viewDidDisappearCADisplayLink: UInt8 = 0

        static var viewDidAppearIsVisible: UInt8 = 0
        static var viewDidAppear: UInt8 = 0
//        static var viewDidAppearCADisplayLink: UInt8 = 0

        static var constraintInfo: UInt8 = 0
        static var goneInfo: UInt8 = 0

        static var cache: UInt8 = 0
        static var unitName: String = ""
    }

    private class ConstraintInfo {
        var isWidthConstraint: Bool?
        var isHeightConstraint: Bool?
        var isTopConstraint: Bool?
        var isLeadingConstraint: Bool?
        var isBottomConstraint: Bool?
        var isTrailingConstraint: Bool?
        var isCenterXConstraint: Bool?
        var isCenterYConstraint: Bool?

        var widthConstraint: NSLayoutConstraint?
        var heightConstraint: NSLayoutConstraint?
        var topConstraint: NSLayoutConstraint?
        var leadingConstraint: NSLayoutConstraint?
        var bottomConstraint: NSLayoutConstraint?
        var trailingConstraint: NSLayoutConstraint?
        var centerXConstraint: NSLayoutConstraint?
        var centerYConstraint: NSLayoutConstraint?

        var widthDefaultConstraint: CGFloat?
        var heightDefaultConstraint: CGFloat?
        var topDefaultConstraint: CGFloat?
        var leadingDefaultConstraint: CGFloat?
        var bottomDefaultConstraint: CGFloat?
        var trailingDefaultConstraint: CGFloat?
        var centerXDefaultConstraint: CGFloat?
        var centerYDefaultConstraint: CGFloat?

        func getLayoutConstraint(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
            var result: NSLayoutConstraint?
            switch attribute {
            case .top:
                result = topConstraint
            case .bottom:
                result = bottomConstraint
            case .leading:
                result = leadingConstraint
            case .trailing:
                result = trailingConstraint
            case .width:
                result = widthConstraint
            case .height:
                result = heightConstraint
            case .centerX:
                result = centerXConstraint
            case .centerY:
                result = centerYConstraint
            default:
                break
            }

            return result
        }

        func setLayoutConstraint(attribute: NSLayoutConstraint.Attribute, value: NSLayoutConstraint) {
            switch attribute {
            case .top:
                topConstraint = value
            case .bottom:
                bottomConstraint = value
            case .leading:
                leadingConstraint = value
            case .trailing:
                trailingConstraint = value
            case .width:
                widthConstraint = value
            case .height:
                heightConstraint = value
            case .centerX:
                centerXConstraint = value
            case .centerY:
                centerYConstraint = value
            default:
                break
            }
        }

        func getConstraintDefaultValue(attribute: NSLayoutConstraint.Attribute) -> CGFloat? {
            var result: CGFloat?
            switch attribute {
            case .top:
                result = topDefaultConstraint
            case .bottom:
                result = bottomDefaultConstraint
            case .leading:
                result = leadingDefaultConstraint
            case .trailing:
                result = trailingDefaultConstraint
            case .width:
                result = widthDefaultConstraint
            case .height:
                result = heightDefaultConstraint
            case .centerX:
                result = centerXDefaultConstraint
            case .centerY:
                result = centerYDefaultConstraint
            default:
                break
            }

            return result
        }

        func setConstraintDefaultValue(attribute: NSLayoutConstraint.Attribute, value: CGFloat) {
            switch attribute {
            case .top:
                topDefaultConstraint = value
            case .bottom:
                bottomDefaultConstraint = value
            case .leading:
                leadingDefaultConstraint = value
            case .trailing:
                trailingDefaultConstraint = value
            case .width:
                widthDefaultConstraint = value
            case .height:
                heightDefaultConstraint = value
            case .centerX:
                centerXDefaultConstraint = value
            case .centerY:
                centerYDefaultConstraint = value
            default:
                break
            }
        }
    }

    private class GoneInfo {
        var widthEmptyConstraint: NSLayoutConstraint?
        var heightEmptyConstraint: NSLayoutConstraint?
    }

    public var cache: Bool {
        get {
            if let info = objc_getAssociatedObject(self, &AssociatedKeys.cache) as? Bool {
                return info
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cache, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var unitName: String {
        get {
            if let info = objc_getAssociatedObject(self, &AssociatedKeys.unitName) as? String {
                return info
            }
            return ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.unitName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var constraintInfo: ConstraintInfo {
        get {
            if let info = objc_getAssociatedObject(self, &AssociatedKeys.constraintInfo) as? ConstraintInfo {
                return info
            }
            let info = ConstraintInfo()
            objc_setAssociatedObject(self, &AssociatedKeys.constraintInfo, info, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return info
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.constraintInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var goneInfo: GoneInfo {
        get {
            if let info = objc_getAssociatedObject(self, &AssociatedKeys.goneInfo) as? GoneInfo {
                return info
            }
            let info = GoneInfo()
            objc_setAssociatedObject(self, &AssociatedKeys.goneInfo, info, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return info
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.goneInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var isWidthConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isWidthConstraint {
                return value
            }
            else {
                let value: Bool = self.getAttributeConstrains(constraints: self.constraints, layoutAttribute: .width).count > 0
                constraintInfo.isWidthConstraint = value
                return value
            }
        }
    }

    public var isHeightConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isHeightConstraint {
                return value
            }
            else {
                let value: Bool = self.getAttributeConstrains(constraints: self.constraints, layoutAttribute: .height).count > 0
                constraintInfo.isHeightConstraint = value
                return value
            }
        }
    }

    public var isTopConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isTopConstraint {
                return value
            }
            else {
                if let _ = self.getLayoutConstraint(.top, errorCheck: false) {
                    constraintInfo.isTopConstraint = true
                    return true
                }
                constraintInfo.isTopConstraint = false
                return false

            }
        }
    }

    public var isLeadingConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isLeadingConstraint {
                return value
            }
            else {
                if let _ = self.getLayoutConstraint(.leading, errorCheck: false) {
                    constraintInfo.isLeadingConstraint = true
                    return true
                }
                constraintInfo.isLeadingConstraint = false
                return false
            }
        }
    }

    public var isBottomConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isBottomConstraint {
                return value
            }
            else {
                if let _ = self.getLayoutConstraint(.bottom, errorCheck: false) {
                    constraintInfo.isBottomConstraint = true
                    return true
                }
                constraintInfo.isBottomConstraint = false
                return false
            }
        }
    }

    public var isTrailingConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isTrailingConstraint {
                return value
            }
            else {
                if let _ = self.getLayoutConstraint(.trailing, errorCheck: false) {
                    constraintInfo.isTrailingConstraint = true
                    return true
                }
                constraintInfo.isTrailingConstraint = false
                return false
            }
        }
    }

    public var isCenterXConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isCenterXConstraint {
                return value
            }
            else {
                if let _ = self.getLayoutConstraint(.centerX, errorCheck: false) {
                    constraintInfo.isCenterXConstraint = true
                    return true
                }
                constraintInfo.isCenterXConstraint = false
                return false
            }
        }
    }

    public var isCenterYConstraint: Bool {
        get {
            if let value: Bool = constraintInfo.isCenterYConstraint {
                return value
            }
            else {
                if let _ = self.getLayoutConstraint(.centerY, errorCheck: false) {
                    constraintInfo.isCenterYConstraint = true
                    return true
                }
                constraintInfo.isCenterYConstraint = false
                return false
            }
        }
    }

    public var widthConstraint: CGFloat {
        get {
            return self.getConstraint(.width)
        }
        set {
            self.setConstraint(.width, newValue)
        }
    }

    public var heightConstraint: CGFloat {
        get {
            return self.getConstraint(.height)
        }
        set {
            self.setConstraint(.height, newValue)
        }
    }

    public var topConstraint: CGFloat {
        get {
            return self.getConstraint(.top)
        }
        set {
            let constraint: NSLayoutConstraint? = self.getLayoutConstraint(.top)
            if constraint?.secondItem === self {
                self.setConstraint(.top, newValue * -1)
            }
            else {
                self.setConstraint(.top, newValue)
            }
        }
    }

    public var leadingConstraint: CGFloat {
        get {
            return self.getConstraint(.leading)
        }
        set {
            let constraint: NSLayoutConstraint? = self.getLayoutConstraint(.leading)
            if constraint?.secondItem === self {
                self.setConstraint(.leading, newValue * -1)
            }
            else {
                self.setConstraint(.leading, newValue)
            }
        }
    }

    public var bottomConstraint: CGFloat {
        get {
            return self.getConstraint(.bottom)
        }
        set {
            let constraint: NSLayoutConstraint? = self.getLayoutConstraint(.bottom)
            if constraint?.firstItem === self {
                self.setConstraint(.bottom, newValue * -1)
            }
            else {
                self.setConstraint(.bottom, newValue)
            }
        }
    }

    public var trailingConstraint: CGFloat {
        get {
            return self.getConstraint(.trailing)
        }
        set {
            let constraint: NSLayoutConstraint? = self.getLayoutConstraint(.trailing)
            if constraint?.firstItem === self {
                self.setConstraint(.trailing, newValue * -1)
            }
            else {
                self.setConstraint(.trailing, newValue)
            }
        }
    }

    public var centerXConstraint: CGFloat {
        get {
            return self.getConstraint(.centerX)
        }
        set {
            let constraint: NSLayoutConstraint? = self.getLayoutConstraint(.centerX)
            if constraint?.secondItem === self {
                self.setConstraint(.centerX, newValue * -1)
            }
            else {
                self.setConstraint(.centerX, newValue)
            }
        }
    }

    public var centerYConstraint: CGFloat {
        get {
            return self.getConstraint(.centerY)
        }
        set {
            let constraint: NSLayoutConstraint? = self.getLayoutConstraint(.centerY)
            if constraint?.secondItem === self {
                self.setConstraint(.centerY, newValue * -1)
            }
            else {
                self.setConstraint(.centerY, newValue)
            }
        }
    }

    public var widthDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.width)
        }
    }

    public var heightDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.height)
        }
    }

    public var topDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.top)
        }
    }

    public var leadingDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.leading)
        }
    }

    public var bottomDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.bottom)
        }
    }

    public var trailingDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.trailing)
        }
    }

    public var centerXDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.centerX)
        }
    }

    public var centerYDefaultConstraint: CGFloat {
        get {
            return self.getDefaultConstraint(.centerY)
        }
    }

    public func getConstraint(_ layoutAttribute: NSLayoutConstraint.Attribute) -> CGFloat {
        return self.getLayoutConstraint(layoutAttribute)?.constant ?? 0
    }
    

    public func getDefaultConstraint(_ layoutAttribute: NSLayoutConstraint.Attribute) -> CGFloat {
        self.getLayoutConstraint(layoutAttribute)
        if let value = constraintInfo.getConstraintDefaultValue(attribute: layoutAttribute) {
            return value
        }

        assertionFailure("Error getDefaultConstraint")
        return 0.0
    }

    public func setConstraint(_ layoutAttribute: NSLayoutConstraint.Attribute, _ value: CGFloat) {
        guard self.getLayoutConstraint(layoutAttribute)?.constant != value else { return }
        self.getLayoutConstraint(layoutAttribute)?.constant = value
        setNeedsLayout()
    }

    /// 특정뷰의 layoutAttribute를 가져오기 (전뷰를 검사하기 때문에 느림. 셀에서는 쓰지 말것)
    /// - Parameter layoutAttribute: layoutAttribute
    /// - Parameter toTaget: 특정뷰
    public func getConstraint(_ layoutAttribute: NSLayoutConstraint.Attribute, toTaget: UIView) -> NSLayoutConstraint? {
        let constraints: [NSLayoutConstraint] = self.getContraints(self.topParentViewView, checkSub: true)
        var constraintsTemp: [NSLayoutConstraint] = self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)
        constraintsTemp = constraintsTemp.filter { value -> Bool in
            return value.firstItem === toTaget || value.secondItem === toTaget
        }
//        assert(constraintsTemp.first != nil, "not find TagetView")
        return constraintsTemp.first
    }

    public var topParentViewView: UIView {
        guard let superview: UIView = superview else {
            return  self
        }
        return superview.topParentViewView

    }
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    @inline(__always) public func getContraints(_ view: UIView, checkSub: Bool = false) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = [NSLayoutConstraint]()
        result.reserveCapacity(100)
        if checkSub {
            for subView: UIView in view.subviews {
                result += self.getContraints(subView, checkSub: checkSub)
            }
        }

        result += view.constraints

        return result
    }

    @inline(__always) public func getAttributeConstrains(constraints: [NSLayoutConstraint], layoutAttribute: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        var constraintsTemp: [NSLayoutConstraint] = [NSLayoutConstraint]()
        constraintsTemp.reserveCapacity(100)
        for constraint: NSLayoutConstraint in constraints {
            switch layoutAttribute {
            case .width, .height:
                if type(of: constraint) === NSLayoutConstraint.self {
                    if  constraint.firstItem === self && constraint.firstAttribute == layoutAttribute && constraint.secondItem == nil {
                        if self is UIButton || self is UILabel || self is UIImageView {
                            constraintsTemp.append(constraint)
                        }
                        else {
                            if self is UIButton || self is UILabel || self is UIImageView {
                                constraintsTemp.append(constraint)
                            }
                            else {
                                constraintsTemp.append(constraint)
                            }
                        }
                    }
                    else if  constraint.firstAttribute == layoutAttribute && constraint.secondAttribute == layoutAttribute {
                        if constraint.firstItem === self || constraint.secondItem === self {
                            constraintsTemp.append(constraint)
                        }
                    }
                }
            case .centerX, .centerY:
                if constraint.firstAttribute == layoutAttribute && constraint.secondAttribute == layoutAttribute {
                    if (constraint.firstItem === self && (constraint.secondItem === self.superview || constraint.secondItem is UILayoutGuide)) ||
                        (constraint.secondItem === self && (constraint.firstItem === self.superview || constraint.firstItem is UILayoutGuide)) {
                        constraintsTemp.append(constraint)
                    }
                    else if constraint.firstItem === self || constraint.secondItem === self {
                        constraintsTemp.append(constraint)
                    }
                }
            case .top :
                if  constraint.firstItem === self && constraint.firstAttribute == .top && constraint.secondAttribute == .bottom {
                    constraintsTemp.append(constraint)
                }
                else if  constraint.secondItem === self && constraint.secondAttribute == .top && constraint.firstAttribute == .bottom {
                    constraintsTemp.append(constraint)
                }
                else if constraint.firstAttribute == .top && constraint.secondAttribute == .top {
                    if (constraint.firstItem === self && constraint.secondItem === self.superview ) ||
                        (constraint.secondItem === self && constraint.firstItem === self.superview ) {
                        constraintsTemp.append(constraint)
                    }
                    else {
                        if (constraint.firstItem === self && constraint.secondItem is UILayoutGuide) ||
                            (constraint.secondItem === self && constraint.firstItem is UILayoutGuide) {
                            constraintsTemp.append(constraint)
                        }
                        else if constraint.firstItem === self || constraint.secondItem === self {
                            constraintsTemp.append(constraint)
                        }
                    }
                }
            case .bottom :
                if  constraint.firstItem === self && constraint.firstAttribute == .bottom && constraint.secondAttribute == .top {
                    constraintsTemp.append(constraint)
                }
                else if  constraint.secondItem === self && constraint.secondAttribute == .bottom && constraint.firstAttribute == .top {
                    constraintsTemp.append(constraint)
                }
                else if constraint.firstAttribute == .bottom && constraint.secondAttribute == .bottom {
                    if (constraint.firstItem === self && constraint.secondItem === self.superview ) ||
                        (constraint.secondItem === self && constraint.firstItem === self.superview ) {
                        constraintsTemp.append(constraint)
                    }
                    else {
                        if (constraint.firstItem === self && constraint.secondItem is UILayoutGuide) ||
                            (constraint.secondItem === self && constraint.firstItem is UILayoutGuide) {
                            constraintsTemp.append(constraint)
                        }
                        else if constraint.firstItem === self || constraint.secondItem === self {
                            constraintsTemp.append(constraint)
                        }
                    }
                }
            case .leading :
                if  constraint.firstItem === self && constraint.firstAttribute == .leading && constraint.secondAttribute == .trailing {
                    constraintsTemp.append(constraint)
                }
                else if  constraint.secondItem === self && constraint.secondAttribute == .leading && constraint.firstAttribute == .trailing {
                    constraintsTemp.append(constraint)
                }
                else if constraint.firstAttribute == .leading && constraint.secondAttribute == .leading {
                    if (constraint.firstItem === self && constraint.secondItem === self.superview ) ||
                        (constraint.secondItem === self && constraint.firstItem === self.superview ) {
                        constraintsTemp.append(constraint)
                    }
                    else {
                        if (constraint.firstItem === self && constraint.secondItem is UILayoutGuide) ||
                            (constraint.secondItem === self && constraint.firstItem is UILayoutGuide) {
                            constraintsTemp.append(constraint)
                        }
                        else if constraint.firstItem === self || constraint.secondItem === self {
                            constraintsTemp.append(constraint)
                        }
                    }
                }
            case .trailing :
                if  constraint.firstItem === self && constraint.firstAttribute == .trailing && constraint.secondAttribute == .leading {
                    constraintsTemp.append(constraint)
                }
                else if  constraint.secondItem === self && constraint.secondAttribute == .trailing && constraint.firstAttribute == .leading {
                    constraintsTemp.append(constraint)
                }
                else if constraint.firstAttribute == .trailing && constraint.secondAttribute == .trailing {
                    if (constraint.firstItem === self && constraint.secondItem === self.superview ) ||
                        (constraint.secondItem === self && constraint.firstItem === self.superview ) {
                        constraintsTemp.append(constraint)
                    }
                    else {
                        if (constraint.firstItem === self && constraint.secondItem is UILayoutGuide) ||
                            (constraint.secondItem === self && constraint.firstItem is UILayoutGuide) {
                            constraintsTemp.append(constraint)
                        }
                        else if constraint.firstItem === self || constraint.secondItem === self {
                            constraintsTemp.append(constraint)
                        }
                    }
                }

            default :
                assertionFailure("not supput \(layoutAttribute)")
            }
        }

        return constraintsTemp
    }

    public func getLayoutAllConstraints(_ layoutAttribute: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        var resultConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        resultConstraints.reserveCapacity(100)
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        constraints.reserveCapacity(100)

        if layoutAttribute == .width || layoutAttribute == .height {
            constraints = self.getContraints(self)
            resultConstraints += self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)

            if resultConstraints.count == 0 {
                if let view = superview {
                    constraints = self.getContraints(view)
                    resultConstraints += self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)
                }
            }

            if resultConstraints.count == 0 {
                constraints = self.getContraints(self.topParentViewView, checkSub: true)
                resultConstraints += self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)
            }
        }
        else {
            if let view = superview {
                constraints = self.getContraints(view)
                resultConstraints += self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)
            }

            if resultConstraints.count == 0 {
                constraints = self.getContraints(self)
                resultConstraints += self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)
            }

            if resultConstraints.count == 0 {
                constraints = self.getContraints(self.topParentViewView, checkSub: true)
                resultConstraints += self.getAttributeConstrains(constraints: constraints, layoutAttribute: layoutAttribute)
            }
        }

        return resultConstraints
    }

    @discardableResult
    public func getLayoutConstraint(_ layoutAttribute: NSLayoutConstraint.Attribute, errorCheck: Bool = true) -> NSLayoutConstraint? {
        if let value: NSLayoutConstraint = constraintInfo.getLayoutConstraint(attribute: layoutAttribute) {
            return value
        }

        let constraintsTemp: [NSLayoutConstraint] = getLayoutAllConstraints(layoutAttribute)

        if constraintsTemp.count == 0 {
            if errorCheck {
                assertionFailure("\n\n🔗 ------------------------------------------------ \n\(self.constraints)\nAutoLayout Not Make layoutAttribute : \(layoutAttribute.string) \nView: \(self)\n🔗 ------------------------------------------------ \n\n")
            }
            return nil
        }

        let constraintsSort: Array = constraintsTemp.sorted(by: { obj1, obj2 -> Bool in
            return obj1.priority.rawValue > obj2.priority.rawValue
        })

        let result: NSLayoutConstraint? = constraintsSort.first
        if let result = result {
            constraintInfo.setLayoutConstraint(attribute: layoutAttribute, value: result)

            if constraintInfo.getConstraintDefaultValue(attribute: layoutAttribute) == nil {
               constraintInfo.setConstraintDefaultValue(attribute: layoutAttribute, value: result.constant)
            }
        }

        return result
    }

    public func copyView() -> AnyObject {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as AnyObject
    }

    public func addSubViewAutoLayout(_ subview: UIView) {
        self.addSubViewAutoLayout(subview, edgeInsets: UIEdgeInsets.zero)
    }

    public func addSubViewAutoLayout(_ subview: UIView, edgeInsets: UIEdgeInsets) {
        self.addSubview(subview)
        self.setSubViewAutoLayout(subview, edgeInsets: edgeInsets)
    }

    public func addSubViewAutoLayout(insertView: UIView, subview: UIView, edgeInsets: UIEdgeInsets, isFront: Bool) {
        if isFront {
            self.insertSubview(insertView, belowSubview: subview)
        }
        else {
            self.insertSubview(insertView, aboveSubview: subview)
        }
        self.setSubViewAutoLayout(insertView, edgeInsets: edgeInsets)
    }

    public func setSubViewAutoLayout(_ subview: UIView, edgeInsets: UIEdgeInsets) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        let views: Dictionary = ["subview": subview]
        let edgeInsetsDic: Dictionary = ["top": (edgeInsets.top), "left": (edgeInsets.left), "bottom": (edgeInsets.bottom), "right": (edgeInsets.right)]

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(left)-[subview]-(right)-|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: edgeInsetsDic,
                                                           views: views))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[subview]-(bottom)-|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: edgeInsetsDic,
                                                           views: views))
    }

    public func addSubViewAutoLayout(subviews: [UIView], addType: VIEW_ADD_TYPE, edgeInsets: UIEdgeInsets, buttonGap: CGFloat = 0.0) {
        var constraints: String = String()
        var views = [String: UIView]()
        var metrics: Dictionary = ["top": (edgeInsets.top), "left": (edgeInsets.left), "bottom": (edgeInsets.bottom), "right": (edgeInsets.right), "buttonGap": buttonGap]

        for (idx, obj) in subviews.enumerated() {
            obj.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(obj)
            views["view\(idx)"] = obj

            if addType == .horizontal {
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[view\(idx)]-(bottom)-|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: ["top": (edgeInsets.top), "bottom": (edgeInsets.bottom)],
                    views: views))

                metrics["width\(idx)"] = (obj.frame.size.width)

                if subviews.count == 1 {
                    constraints += "H:|-(left)-[view\(idx)(width\(idx))]-(right)-|"

                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints,
                                                                       options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                       metrics: metrics,
                                                                       views: views))

                }
                else {
                    if idx == 0 {
                        constraints += "H:|-(left)-[view\(idx)(width\(idx))]"
                    }
                    else if idx == subviews.count - 1 {
                        constraints += "-(buttonGap)-[view\(idx)(width\(idx))]-(right)-|"

                        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints,
                                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                           metrics: metrics,
                                                                           views: views))
                    }
                    else {
                        constraints += "-(buttonGap)-[view\(idx)(width\(idx))]"
                    }
                }

            }
            else {
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(left)-[view\(idx)]-(right)-|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: ["left": (edgeInsets.left), "right": (edgeInsets.right)],
                    views: views))

                metrics["height\(idx)"] = (obj.frame.size.height)

                if subviews.count == 1 {
                    constraints += "V:|-(top)-[view\(idx)(height\(idx))]-(bottom)-|"

                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints,
                                                                       options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                       metrics: metrics,
                                                                       views: views))
                }
                else {
                    if idx == 0 {
                        constraints += "V:|-(top)-[view\(idx)(height\(idx))]"

                    }
                    else if idx == subviews.count - 1 {
                        constraints += "-(buttonGap)-[view\(idx)(height\(idx))]-(bottom)-|"

                        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints,
                                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                           metrics: metrics,
                                                                           views: views))
                    }
                    else {
                        constraints += "-(buttonGap)-[view\(idx)(height\(idx))]"
                    }
                }

            }

        }

    }

    public func removeSuperViewAllConstraints() {
        guard let superview: UIView = self.superview else { return }

        for c: NSLayoutConstraint in superview.constraints {
            if c.firstItem === self || c.secondItem === self {
                superview.removeConstraint(c)
            }
        }
    }

    public func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        guard let superview: UIView = self.superview else { return }

        for c: NSLayoutConstraint in superview.constraints {
            if c.firstItem === self && c.firstAttribute == attribute {
                superview.removeConstraint(c)
            }
            else if c.secondItem === self && c.secondAttribute == attribute {
                superview.removeConstraint(c)
            }
        }
    }

    public func removeAllConstraints() {
        self.removeSuperViewAllConstraints()
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    var viewDidAppearIsVisible: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.viewDidAppearIsVisible) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.viewDidAppearIsVisible, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

//    private var viewDidAppearCADisplayLink: CADisplayLink? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.viewDidAppearCADisplayLink) as? CADisplayLink
//        }
//        set {
//            objc_setAssociatedObject ( self, &AssociatedKeys.viewDidAppearCADisplayLink, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }

//    @objc private func onViewDidAppear() {
//        defer {
//            let windowRect = self.superview?.convert(self.frame, to: nil) ?? .zero
//            if windowRect == .zero {
//                self.viewDidAppearCADisplayLink?.invalidate()
//                self.viewDidAppearCADisplayLink = nil
//                self.viewDidAppear = nil
//            }
//        }
//
//
//        if viewDidAppearIsVisible != self.isVisible {
//            viewDidAppearIsVisible = self.isVisible
//            self.viewDidAppear?(viewDidAppearIsVisible)
//        }
//    }

    public var viewDidAppear: BoolClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.viewDidAppear) as? BoolClosure
        }
        set {
            guard self.cache == false else { return }
            objc_setAssociatedObject( self, &AssociatedKeys.viewDidAppear, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            DispatchQueue.main.async {
                if newValue != nil {
                    if ViewDidAppearCADisplayLink.shared.views.contains(self) == false {
                        self.viewDidAppearIsVisible = !self.isVisible
                        ViewDidAppearCADisplayLink.shared.views.append(self)
                    }
                }
                else {
                    ViewDidAppearCADisplayLink.shared.views.remove(object: self)
                }
            }
//            viewDidAppearCADisplayLink?.invalidate()
//            if newValue != nil {
//                viewDidAppearCADisplayLink = CADisplayLink(target: self, selector: #selector(onViewDidAppear))
//                viewDidAppearCADisplayLink?.add(to: .main, forMode: .common)
//                if #available(iOS 10.0, *) {
//                    viewDidAppearCADisplayLink?.preferredFramesPerSecond = 5
//                } else {
//                    viewDidAppearCADisplayLink?.frameInterval = 5
//                }
//            }
//            else {
//                viewDidAppearCADisplayLink = nil
//            }
        }
    }

//    private var viewDidDisappearCADisplayLink: CADisplayLink? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.viewDidDisappearCADisplayLink) as? CADisplayLink
//        }
//        set {
//            objc_setAssociatedObject ( self, &AssociatedKeys.viewDidDisappearCADisplayLink, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    @objc private func onViewDidDisappear() {
//        let windowRect = self.superview?.convert(self.frame, to: nil) ?? .zero
//        if windowRect == .zero {
//            self.viewDidDisappearCADisplayLink?.invalidate()
//            self.viewDidDisappearCADisplayLink = nil
//            return
//        }
//
//        if self.isVisible == false {
//            self.viewDidDisappearCADisplayLink?.invalidate()
//            self.viewDidDisappearCADisplayLink = nil
//            self.viewDidDisappear?()
//        }
//    }
//
//    public var viewDidDisappear: VoidClosure? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.viewDidDisappear) as? VoidClosure
//        }
//        set {
//            objc_setAssociatedObject ( self, &AssociatedKeys.viewDidDisappear, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//            viewDidDisappearCADisplayLink?.invalidate()
//            if newValue != nil {
//                viewDidDisappearCADisplayLink = CADisplayLink(target: self, selector: #selector(onViewDidDisappear))
//                viewDidDisappearCADisplayLink?.add(to: .main, forMode: .common)
//                if #available(iOS 10.0, *) {
//                    viewDidDisappearCADisplayLink?.preferredFramesPerSecond = 5
//                } else {
//                    viewDidDisappearCADisplayLink?.frameInterval = 5
//                }
//            }
//            else {
//                viewDidDisappearCADisplayLink = nil
//            }
//        }
//    }

    public var windowFrame: CGRect {
        return superview?.convert(frame, to: nil) ?? .zero
    }

    public var isVisible: Bool {
        guard let window = self.window else { return false }

        var currentView: UIView = self
        while let superview = currentView.superview {
            if window.bounds.intersects(currentView.windowFrame) == false {
                return false
            }

            if (superview.bounds).intersects(currentView.frame) == false {
                return false
            }

            if currentView.isHidden {
                return false
            }

            if currentView.alpha == 0 {
                return false
            }

            currentView = superview
        }

        return true
    }

    public var gone: Bool {
        get {
            fatalError("You cannot read from this object.")
        }
        set {
            if newValue {
               gone()
            }
            else {
                goneRemove()
            }
        }
    }

    /// only widht gone
    public var goneWidth: Bool {
        get {
            fatalError("You cannot read from this object.")
        }
        set {
            if newValue {
                gone(.width)
            }
            else {
                goneRemove(.width)
            }
        }
    }

    /// only height gone
    public var goneHeight: Bool {
        get {
            fatalError("You cannot read from this object.")
        }
        set {
            if newValue {
                gone(.height)
            }
            else {
                goneRemove(.height)
            }
        }
    }

    /// gone
    ///
    ///
    ///  GontType
    ///
    ///  leading = GoneType(rawValue: 1 << 0)
    ///  trailing = GoneType(rawValue: 1 << 1)
    ///  top = GoneType(rawValue: 1 << 2)
    ///  bottom = GoneType(rawValue: 1 << 3)
    ///  width = GoneType(rawValue: 1 << 4)
    ///  height = GoneType(rawValue: 1 << 5)
    ///
    ///  size: GoneType = [.width, .height]
    ///
    ///  widthLeading: GoneType = [.width, .leading]
    ///  widthTrailing: GoneType = [.width, .trailing]
    ///  widthPadding: GoneType = [.width, .leading, .trailing]
    ///
    ///  heightTop: GoneType = [.height, .top]
    ///  heightBottom: GoneType = [.height, .bottom]
    ///  heightPadding: GoneType = [.height, .top, .bottom]
    ///
    ///  padding: GoneType = [.leading, .trailing, .top, .bottom]
    ///  all: GoneType = [.leading, .trailing, .top, .bottom, .width, .height]
    ///
    ///
    /// - Parameter type: GoneType
    public func gone(_ type: GoneType = .all) {
        guard type.isEmpty == false else { return }
        isHidden = true

        if type.contains(.width) {
            if isWidthConstraint {
                widthConstraint = 0
            }
            else {
                if let c = self.goneInfo.widthEmptyConstraint {
                    c.constant = 0
                }
                else {
                    let constraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
                    addConstraint(constraint)
                    self.goneInfo.widthEmptyConstraint = constraint
                }
            }
        }
        if type.contains(.height) {
            if isHeightConstraint {
                heightConstraint = 0
            }
            else {
                if let c = self.goneInfo.heightEmptyConstraint {
                    c.constant = 0
                }
                else {
                    let constraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                    addConstraint(constraint)
                    self.goneInfo.heightEmptyConstraint = constraint
                }
            }
        }
        if type.contains(.leading) {
            if isLeadingConstraint {
                leadingConstraint = 0
            }
        }
        if type.contains(.trailing) {
            if isTrailingConstraint {
                trailingConstraint = 0
            }
        }
        if type.contains(.top) {
            if isTopConstraint {
                topConstraint = 0
            }
        }
        if type.contains(.bottom) {
            if isBottomConstraint {
                bottomConstraint = 0
            }
        }
    }

    public func goneRemove(_ type: GoneType = .all) {
        isHidden = false

        if type.contains(.width) {
            if let c: NSLayoutConstraint = self.goneInfo.widthEmptyConstraint {
                removeConstraint(c)
                self.goneInfo.widthEmptyConstraint = nil
            }
            else if isWidthConstraint {
                widthConstraint = widthDefaultConstraint
            }
        }
        if type.contains(.height) {
            if let c: NSLayoutConstraint = self.goneInfo.heightEmptyConstraint {
                removeConstraint(c)
                self.goneInfo.heightEmptyConstraint = nil
            }
            else if isHeightConstraint {
                heightConstraint = heightDefaultConstraint
            }
        }
        if type.contains(.leading) {
            if isLeadingConstraint {
                leadingConstraint = leadingDefaultConstraint
            }
        }
        if type.contains(.trailing) {
            if isTrailingConstraint {
                trailingConstraint = trailingDefaultConstraint
            }
        }
        if type.contains(.top) {
            if isTopConstraint {
                topConstraint = topDefaultConstraint
            }
        }
        if type.contains(.bottom) {
            if isBottomConstraint {
                bottomConstraint = bottomDefaultConstraint
            }
        }
    }
}

// MARK: Custom UIView Initilizers
extension UIView {
    ///   convenience contructor to define a view based on width, height and base coordinates.
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
    }

    ///   puts padding around the view
    public convenience init(superView: UIView, padding: CGFloat) {
        self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.w - padding * 2, height: superView.h - padding * 2))
    }

    public convenience init(superView: UIView) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: superView.size))
    }
}

// MARK: Frame Extensions
extension UIView {
    /// AutoLayout을 사용하지 않고 add를 하는경우에만 사용..... 🧨 Autolayout을 쓰는 경우는 addSubViewAutoLayout 함수를 이용해주세요
    /// - Parameters:
    ///   - view: 타켓 뷰
    ///   - resizingMask: UIView.AutoresizingMask
    ///   - frame: CGRect
    public func addSubviewResizingMask(_ view: UIView, resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight], frame: CGRect = CGRect.zero) {
        if frame == CGRect.zero {
            view.frame = self.bounds
        }
        else {
            view.frame = frame
        }

        view.autoresizingMask = resizingMask
        self.addSubview(view)
    }

    ///   add multiple subviews
    public func addSubviews(_ views: [UIView]) {
        views.forEach { [weak self] eachView in
            self?.addSubview(eachView)
        }
    }

    ///   resizes this view so it fits the largest subview
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView: UIView in self.subviews {
            let aView: UIView = someView
            let newWidth: CGFloat = aView.x + aView.w
            let newHeight: CGFloat = aView.y + aView.h
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    ///   resizes this view so it fits the largest subview
    public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView: UIView in self.subviews {
            let aView: UIView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth: CGFloat = aView.x + aView.w
                let newHeight: CGFloat = aView.y + aView.h
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    ///   resizes this view so as to fit its width.
    public func resizeToFitWidth() {
        let currentHeight = self.h
        self.sizeToFit()
        self.h = currentHeight
    }

    ///   resizes this view so as to fit its height.
    public func resizeToFitHeight() {
        let currentWidth = self.w
        self.sizeToFit()
        self.w = currentWidth
    }

    ///   resizes this view so as to fit its height.
    public func resizeToFitHeight(_ height: CGFloat) {
        var rt: CGRect = frame
        rt.size.height = height
        frame = rt
    }

    ///   getter and setter for the x coordinate of the frame's origin for the view.
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    public var minX: CGFloat {
        get {
            return self.frame.minX
        }
    }

    public var midX: CGFloat {
        get {
            return self.frame.midX
        }
    }

    public var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            self.frame.x = newValue - self.w
        }
    }
    ///   getter and setter for the y coordinate of the frame's origin for the view.
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    public var minY: CGFloat {
        get {
            return self.frame.minY
        }
    }

    public var midY: CGFloat {
        get {
            return self.frame.midY
        }
    }

    public var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
        set {
            self.frame.y = newValue - self.h
        }
    }

    ///   variable to get the width of the view.
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    ///   variable to get the height of the view.
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }

    ///   getter and setter for the x coordinate of leftmost edge of the view.
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    ///   getter and setter for the x coordinate of the rightmost edge of the view.
    public var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }

    ///   getter and setter for the y coordinate for the topmost edge of the view.
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    ///   getter and setter for the y coordinate of the bottom most edge of the view.
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }

    ///   getter and setter the frame's origin point of the view.
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    ///   getter and setter for the X coordinate of the center of a view.
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    ///   getter and setter for the Y coordinate for the center of a view.
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    ///   getter and setter for frame size for the view.
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    ///   getter for an leftwards offset position from the leftmost edge.
    public func leftOffset(_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }

    ///   getter for an rightwards offset position from the rightmost edge.
    public func rightOffset(_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }

    ///   aligns the view to the top by a given offset.
    public func topOffset(_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }

    ///   align the view to the bottom by a given offset.
    public func bottomOffset(_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }

    ///   align the view widthwise to the right by a given offset.
    public func alignRight(_ offset: CGFloat) -> CGFloat {
        return self.w - offset
    }

    public func reorderSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView: UIView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                if reorder {
                    let aView: UIView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }

    public func removeSubviews() {
        for subview: UIView in subviews {
            subview.removeFromSuperview()
        }
    }

    public func removeSubviews(_ tag: Int) {
        for subview: UIView in subviews {
            if subview.tag == tag {
                subview.removeFromSuperview()
            }
        }
    }

    public func viewWithTagName(_ name: String) -> UIView? {
        var sv: UIView? = self.superview
        while true {
            guard sv?.superview != nil else { break }
            sv = sv?.superview
        }
        if sv == nil {
            sv = self
        }
        let viewList: [UIView] = UIView.subViewAllList(sv!)
        return viewList.lazy.filter({ view -> Bool in
            return view.tag_name == name
        }).first

    }

    public class func subViewAllList(_ view: UIView) -> [UIView] {
        var result: [UIView] = [UIView]()
        for sv: UIView in view.subviews {
            if sv.subviews.count > 0 {
                result += subViewAllList(sv)
            }
            result.append(sv)
        }

        return result
    }

    public var topParentView: UIView? {
        var superView: UIView? = self.superview
        while superView != nil {
            superView = superView?.superview
        }
        return superView
    }

    ///   Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
//            assertionFailure("SwiftExtensions Error: The view \(String(describing: type(of: self.parentViewController))) doesn't have a superview")
            return
        }

        self.x = (parentView.w / 2.0) - (self.w / 2.0)
    }

    ///   Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
//            assertionFailure("SwiftExtensions Error: The view \(String(describing: type(of: self.parentViewController))) doesn't have a superview")
            return
        }

        self.y = (parentView.h / 2.0) - (self.h / 2.0)
    }

    ///   Centers view in superview horizontally & vertically
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }

}

// MARK: Transform Extensions
extension UIView {
    public func setRotationX(_ x: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        self.layer.transform = transform
    }

    public func setRotationY(_ y: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }

    public func setRotationZ(_ z: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    public func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    public func setScale(x: CGFloat, y: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
}

// MARK: Layer Extensions
extension UIView {
    @IBInspectable public var tagName: String? {
        get {
            return self.tag_name
        }
        set {
            self.tag_name = newValue
        }
    }

    @IBInspectable public var rotationDegrees: CGFloat {
        get {
            return atan2(self.transform.b, self.transform.a)
        }
        set {
            let radians: CGFloat = CGFloat(Double.pi) * newValue / 180.0
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }

    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            guard self.layer.borderColor != newValue?.cgColor else { return }
            self.layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            guard self.layer.borderWidth != newValue else { return }
            self.layer.borderWidth = newValue
            self.layer.masksToBounds = true
            setNeedsDisplay()
        }
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            guard self.layer.cornerRadius != newValue else { return }
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            self.clipsToBounds = true
            setNeedsDisplay()
        }
    }

    public func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }

    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }

    public func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }

    public func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding * 2, height: size, color: color)
    }

    public func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }

    public func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }

    public func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }

    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border: CALayer = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    public func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let path: UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w / 2)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        self.layer.addSublayer(shapeLayer)
    }
    public func drawStroke(width: CGFloat, color: UIColor) {
        let path: UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w / 2)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }

    public func showRectLine() {
        func subViewList(_ view: UIView) -> [UIView] {
            var result: [UIView] = [UIView]()
            for sv: UIView in view.subviews {
                if sv.subviews.count > 0 && (sv is UIButton) == false {
                    result += subViewList(sv)
                }
                result.append(sv)
            }
            return result
        }

        for view: UIView in subViewList(self) {
            if view is UILabel {
                view.borderColor = UIColor(hex: 0xace1af, alpha: 1)
                view.borderWidth = 1
            }
            else if view is UIImageView {
                view.borderColor = UIColor(hex: 0xFF0000, alpha: 1)
                view.borderWidth = 2
            }
            else if view is UITextField {
                view.borderColor = UIColor(hex: 0xA661FF, alpha: 1)
                view.borderWidth = 1
            }
//            else if view is UIScrollView {
//                view.borderColor = UIColor(hex: 0xFF7D5A, alpha: 0.6)
//                view.borderWidth = 1
//            }
            else if view is UIStackView {
                view.borderColor = UIColor(hex: 0xCACF00, alpha: 1)
                view.borderWidth = 1
            }
            else if view is UIButton {
                view.borderColor = UIColor(hex: 0x005295, alpha: 1)
                view.borderWidth = 1
            }
            else if view is UICollectionViewCell {
                view.borderColor = UIColor(hex: 0xe750f4, alpha: 1)
                view.borderWidth = 0.5
            }
            else if view is UICollectionReusableView {
                view.borderColor = UIColor(hex: 0x26004c, alpha: 1)
                view.borderWidth = 0.5
            }
            else if view is UITableViewCell {
                view.borderColor = UIColor(hex: 0xe750f4, alpha: 1)
                view.borderWidth = 0.5
            }
            else {
                view.borderColor = UIColor(hex: 0xf8e7a8, alpha: 1)
                view.borderWidth = 0.5
            }
        }
    }
}

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

// MARK: Animation Extensions
extension UIView {
    public func clickAnimation(scaleX: CGFloat = 0.8, usingSpringWithDamping: CGFloat = 0.3, initialSpringVelocity: CGFloat = 10.0, completion: VoidClosure? = nil) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)

        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       },
                       completion: { _ in completion?() }
        )
    }

    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0

        layer.add(pulse, forKey: "pulse")
    }

    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3

        layer.add(flash, forKey: nil)
    }

    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true

        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)

        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)

        shake.fromValue = fromValue
        shake.toValue = toValue

        layer.add(shake, forKey: "position")
    }

    public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIView.AnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }

    public func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }

    public func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [weak self] () -> Void in
            guard let `self` = self else { return }
            self.setScale(x: 1, y: 1)
        })
    }

    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [weak self] () -> Void in
            guard let `self` = self else { return }
            self.setScale(x: 1, y: 1)
        })
    }

}

// MARK: Render Extensions
extension UIView {
    public func toImage () -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

// MARK: Gesture Extensions

private var TapGesture_Key: UInt8 = 0
private var SwipeGesture_Key: UInt8 = 0
private var PanGesture_Key: UInt8 = 0
private var PinchGesture_Key: UInt8 = 0
private var LongPressGesture_Key: UInt8 = 0

private class ClosureSleeve {
    let closure: (_ recognizer: UIGestureRecognizer) -> Void

    init (_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) {
        self.closure = closure
    }

    @objc func invoke (recognizer: UIGestureRecognizer) {
        closure(recognizer)
    }
}

extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    @discardableResult
    public func addTapGesture(tapNumber: Int = 1, _ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &TapGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return tap
    }

    @discardableResult
    public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, _ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        swipe.direction = direction

        #if os(iOS)
        swipe.numberOfTouchesRequired = numberOfTouches
        #endif

        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &SwipeGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return swipe
    }

    @discardableResult
    public func addPanGesture(_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &PanGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return pan
    }
    #if os(iOS)

    @discardableResult
    public func addPinchGesture(_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let pinch: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &PinchGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return pinch
    }

    #endif

    @discardableResult
    public func addLongPressGesture(_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &LongPressGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return longPress
    }
}

extension UIView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.layoutIfNeeded()
        let path: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask: CAShapeLayer = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    public func roundView(withBorderColor color: UIColor? = nil, withBorderWidth width: CGFloat? = nil) {
        self.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
        self.layer.borderWidth = width ?? 0
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
    }

    public func nakedView() {
        self.layer.mask = nil
        self.layer.borderWidth = 0
    }
}

extension UIView {
    ///  Shakes the view for as many number of times as given in the argument.
    public func shakeViewForTimes(_ times: Int) {
        let anim: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7 / 100

        self.layer.add(anim, forKey: nil)
    }
}

extension UIView {
    public func allButtonSelect(_ select: Bool) {
        for view: UIView in self.subviews {
            if let button: UIButton = view as? UIButton {
                button.isSelected = select
            }
            else {
                view.allButtonSelect(select)
            }
        }
    }

    public func allButtonEnalbe(_ enable: Bool) {
        for view: UIView in self.subviews {
            if let button: UIButton = view as? UIButton {
                button.isEnabled = enable
            }
            else {
                view.allButtonEnalbe(enable)
            }
        }
    }

    public func disableScrollsToTopPropertyOnAllSubviewsOf() {
        for view in self.subviews {
            if let scrollView: UIScrollView = view as? UIScrollView {
                scrollView.scrollsToTop = false
            }
            else {
                view.disableScrollsToTopPropertyOnAllSubviewsOf()
            }
        }
    }

    public class func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private class func fromXib<T: UIView>(cache: Bool = false, as type: T.Type) -> T {
        if cache, let view = cacheViewNibs.object(forKey: self.className as NSString) {
            return view as! T
        }
        else if let nib = cacheNibs.object(forKey: self.className as NSString) {
            return nib.instantiate(withOwner: nil, options: nil).first as! T
        }
        else if let path: String = Bundle.main.path(forResource: className, ofType: "nib") {
            if FileManager.default.fileExists(atPath: path) {
                let nib = UINib(nibName: self.className, bundle: nil)
                let view = nib.instantiate(withOwner: nil, options: nil).first as! T

                cacheNibs.countLimit = 100
                cacheNibs.setObject(nib, forKey: self.className as NSString)
                //                let view: UIView = Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)!.first as! UIView
                cacheViewNibs.countLimit = 100
                cacheViewNibs.setObject(view, forKey: self.className as NSString)
                view.cache = cache
                return view
            }
        }

        fatalError("\(className) XIB File Not Exist")
    }

    public class func fromXibSize() -> CGSize {
        return fromXib(cache: true).frame.size
    }

}
extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.topAnchor
    }

    var safeLeftAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.leftAnchor
    }

    var safeRightAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.rightAnchor
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.bottomAnchor
    }
}

extension UIView {
    @discardableResult
    public func visibleViewByData(_ value: String?, _ gone: GoneType? = nil) -> Bool {
        if let label = self as? UILabel {
            label.text = value
        }
        if let gone = gone {
            if let value = value, value.isValid {
                self.goneRemove()
                return true
            }
            else {
                self.gone(gone)
                return false
            }
        }
        else {
            if let value = value, value.isValid {
                self.isHidden = false
                return true
            }
            else {
                self.isHidden = true
                return false
            }
        }
    }
}

extension UIResponder {
    public func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UIView {
    public func getViewFromParent<T>(_ type: T.Type) -> T? {
        var view: UIView? = self
        while view != nil {
            view = view?.superview
            if let view = view as? T {
                return view
            }
        }
        return nil
    }
}


#endif
