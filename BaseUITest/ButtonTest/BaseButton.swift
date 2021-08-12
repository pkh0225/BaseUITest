import UIKit

struct UI_BaseButton {
    var size: BaseButton.Size
    var contentAlignment: UIControl.ContentHorizontalAlignment
    var imageAlignment: BaseButton.ImageAlignment
    var rectStyle: BaseButton.RectStyle
    var text: String?
    var image: UIImage?
    var data: Any?
}

class BaseButton: UIButton {
    enum RectStyle: String {
        case rect
        case round
        case oval
    }

    enum ImageAlignment: String {
        case left
        case right
    }

    enum Size: String {
        case XL
        case L
        case M
        case S
        case XS

        var height: CGFloat {
            switch self {
            case .XL:
                return 60
            case .L:
                return 52
            case .M:
                return 44
            case .S:
                return 32
            case .XS:
                return 24
            }
        }

        var font: UIFont {
            var fontName: String = ""
            var size: CGFloat = 0
            switch self {
            case .XL:
                fontName = "Roboto-Medium"
                size = 16
            case .L:
                fontName = "Roboto-Medium"
                size = 15
            case .M:
                fontName = "Roboto-Medium"
                size = 14
            case .S:
                fontName = "Roboto-Medium"
                size = 13
            case .XS:
                fontName = "Roboto-Medium"
                size = 12
            }

            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        }


        func imageSize(_ byText: Bool?) -> CGFloat {
            if byText ?? false {
                switch self {
                case .XL:
                    return 24
                case .L:
                    return 20
                case .M:
                    return 20
                case .S:
                    return 16
                case .XS:
                    return 16
                }
            }
            else {
                switch self {
                case .XL:
                    return 32
                case .L:
                    return 28
                case .M:
                    return 24
                case .S:
                    return 24
                case .XS:
                    return 16
                }
            }
        }

        var imageGap: CGFloat {
            switch self {
            case .XL:
                return 0
            case .L:
                return 0
            case .M:
                return 0
            case .S:
                return 0
            case .XS:
                return 0
            }
        }
        var inset: UIEdgeInsets {
            switch self {
            case .XL:
                return UIEdgeInsets(top: 21, left: 20, bottom: 21, right: 20)
            case .L:
                return UIEdgeInsets(top: 17, left: 16, bottom: 16, right: 16)
            case .M:
                return UIEdgeInsets(top: 14, left: 14, bottom: 13, right: 14)
            case .S:
                return UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            case .XS:
                return UIEdgeInsets(top: 5, left: 10, bottom: 4, right: 10)
            }
        }

        func cornerRadius(rectStyle: RectStyle) -> CGFloat {
            switch rectStyle {
            case .rect:
                return 0
            case .round:
                switch self {
                case .XL:
                    return 6
                case .L:
                    return 6
                case .M:
                    return 6
                case .S:
                    return 6
                case .XS:
                    return 4
                }
            case .oval:
                return self.height / 2.0
            }
        }
    }

    private var widthConst: NSLayoutConstraint? = nil
    private var heightConst: NSLayoutConstraint? = nil
    
    var baseSize: Size = .M {
        didSet {
            titleLabel?.font = baseSize.font
            updateImageSize()
            updateRectStyle()
            updateHeight()
            updateWidth()
            updateUI()
        }
    }

    var rectStyle: RectStyle = .rect {
        didSet {
            updateRectStyle()
        }
    }

    var contentAlignment: UIControl.ContentHorizontalAlignment = .center {
        didSet {
            contentHorizontalAlignment = contentAlignment
            updateUI()
        }
    }

    var imageAlignment: ImageAlignment = .left {
        didSet {
            switch imageAlignment {
            case .left:
                semanticContentAttribute = .forceLeftToRight
            case .right:
                semanticContentAttribute = .forceRightToLeft
            }

            updateUI()
        }
    }

    var fillColor: UIColor? {
        didSet {
            backgroundColor = fillColor
        }
    }

    override var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            guard self.layer.borderColor != newValue?.cgColor else { return }
            self.layer.borderColor = newValue?.cgColor
            self.borderWidth = 1
            setNeedsDisplay()
        }
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        updateImageSize()
        updateWidth()
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)

        updateImageSize()
        updateWidth()
    }

    override func sizeToFit() {
        updateHeight()
        updateWidth()
        updateUI()
    }

    func updateRectStyle() {
        self.cornerRadius = baseSize.cornerRadius(rectStyle: rectStyle)
    }

    func updateImageSize() {
        func updateImage(_ image: UIImage, for state: UIControl.State) {
            let isTitle = self.title(for: state)?.isValid ?? false
            let imageChange = image.toSize(image.size.ratioSize(setWidth: baseSize.imageSize(isTitle)))
            if image.size != imageChange?.size {
                setImage(imageChange, for: state)
            }
        }

        if let image = image(for: .normal) {
            updateImage(image, for: .normal)
        }
        if let image = image(for: .highlighted) {
            updateImage(image, for: .highlighted)
        }
        if let image = image(for: .disabled) {
            updateImage(image, for: .disabled)
        }
        if let image = image(for: .selected) {
            updateImage(image, for: .selected)
        }
        if let image = image(for: .focused) {
            updateImage(image, for: .focused)
        }
        if let image = image(for: .application) {
            updateImage(image, for: .application)
        }
        if let image = image(for: .reserved) {
            updateImage(image, for: .reserved)
        }

    }

    func updateHeight() {
        if translatesAutoresizingMaskIntoConstraints == false {
            if isHeightConstraint {
                heightConstraint = baseSize.height
            }
            else {
                if let heightConst = heightConst {
                    heightConst.constant = baseSize.height
                }
                else {
                    heightConst = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: baseSize.height)
                    addConstraint(heightConst!)
                }
                frame.size.height = baseSize.height
            }
        }
        else {
            frame.size.height = baseSize.height
        }
    }

    func updateWidth() {
        var strlen: CGFloat = 0
        if let title = self.title(for: state), title.isValid {
            strlen = title.size(self.titleLabel?.font ?? UIFont()).w
        }
        var imageWidth: CGFloat = 0
        if let image = self.image(for: state) {
            imageWidth = image.w + baseSize.imageGap
        }
        let maxWidth = ceilUI(baseSize.inset.left + imageWidth + strlen + baseSize.inset.right)
        if translatesAutoresizingMaskIntoConstraints == false {
            if isWidthConstraint == false {
                if let widthConst = widthConst {
                    widthConst.constant = maxWidth
                }
                else {
                    widthConst = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: maxWidth)
                    addConstraint(widthConst!)
                }
                frame.size.width = maxWidth
            }
        }
        else {
            frame.size.width = maxWidth
        }
    }

    func updateUI() {
        contentEdgeInsets = .zero
        imageEdgeInsets = .zero
        titleEdgeInsets = .zero
        
        switch contentAlignment {
        case .center:
            break
        case .left, .leading:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.inset.left, bottom: 0, right: 0)
            if let _ = self.image(for: state) {
                switch imageAlignment {
                case .left:
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap, bottom: 0, right: 0)
                    
                case .right:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap, bottom: 0, right: 0)
                }
            }
            
            
        case .right, .trailing:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.inset.right)
            if let _ = self.image(for: state) {
                switch imageAlignment {
                case .left:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap)
                    
                case .right:
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap)
                }
            }
        case .fill:
            break
        @unknown default:
            break
        }
    }
}

