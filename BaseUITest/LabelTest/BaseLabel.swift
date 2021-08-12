import UIKit

struct UI_BaseLabel {
    var size: BaseLabel.Size
    var textAlignment: NSTextAlignment
    var imageAlignment: BaseLabel.ImageAlignment
    var rectStyle: BaseLabel.RectStyle
    var text: String?
    var image: UIImage?
    var data: Any?
}

class BaseLabel: UILabel {
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
        case L
        case M
        case S

        var height: CGFloat {
            switch self {
            case .L:
                return 24
            case .M:
                return 20
            case .S:
                return 16
            }
        }

        var font: UIFont {
            var fontName: String = ""
            var size: CGFloat = 0
            switch self {
            case .L:
                fontName = "Roboto-Bold"
                size = 12
            case .M:
                fontName = "Roboto-Medium"
                size = 12
            case .S:
                fontName = "Roboto-Bold"
                size = 10
            }

            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        }

        var imageSize: CGFloat {
            switch self {
            case .L:
                return 16
            case .M:
                return 16
            case .S:
                return 16
            }
        }

        var imageGap: CGFloat {
            switch self {
            case .L:
                return 1
            case .M:
                return 1
            case .S:
                return 1
            }
        }

        var inset: UIEdgeInsets {
            switch self {
            case .L:
                return UIEdgeInsets(top: 0.5, left: 8, bottom: -0.5, right: 8)
            case .M:
                return UIEdgeInsets(top: 0.5, left: 6, bottom: -0.5, right: 6)
            case .S:
                return UIEdgeInsets(top: 0.1, left: 4, bottom: -0.1, right: 4)
            }
        }

        func cornerRadius(rectStyle: RectStyle) -> CGFloat {
            switch rectStyle {
            case .rect:
                return 0
            case .round:
                switch self {
                case .L:
                    return 6
                case .M:
                    return 4
                case .S:
                    return 2
                }
            case .oval:
                return self.height / 2.0
            }
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


    private var widthConst: NSLayoutConstraint? = nil
    private var heightConst: NSLayoutConstraint? = nil

    var baseSize: Size = .M {
        didSet {
            font = baseSize.font
            updateImageSize()
            updateHeight()
            updateWidth()
            updateRectStyle()
            updateUI()

        }
    }

    var rectStyle: RectStyle = .rect {
        didSet {
            updateRectStyle()
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            updateUI()
        }
    }

    var imageAlignment: ImageAlignment = .left {
        didSet {
            updateUI()
        }
    }

    override var text: String? {
        didSet {
            updateWidth()
            updateUI()
        }
    }

    var image: UIImage? = nil {
        didSet {
            if let image = image {
                imageView.isHidden = false
                imageView.image = image
                updateImageSize()
            }
            else {
                imageView.isHidden = true
            }
            updateWidth()
            updateUI()
        }
    }

    lazy var imageView: UIImageView = {
        let v = UIImageView()
        addSubview(v)
        return v
    }()

    var textInset: UIEdgeInsets = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        
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
        if let image = image {
            imageView.size = image.size.ratioSize(setWidth: baseSize.imageSize)
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
            }
        }
        frame.size.height = baseSize.height
    }

    func updateWidth() {
        var strlen: CGFloat = 0
        if let text = text, text.isValid {
            strlen = text.size(font).w
        }
        var imageWidth: CGFloat = 0
        if imageView.isHidden == false {
            imageWidth = baseSize.imageSize + baseSize.imageGap
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
        var defaultInset = baseSize.inset
        var strlen: CGFloat = 0
        if let text = text, text.isValid {
            strlen = text.size(font).w
        }

        if let _ = image, imageView.isHidden == false {
            switch textAlignment {
            case .left, .natural:
                switch imageAlignment {
                case .left:
                    imageView.x = baseSize.inset.left
                    defaultInset.left = imageView.maxX + baseSize.imageGap
                case .right:
                    imageView.x = baseSize.inset.left + strlen + baseSize.imageGap
                    defaultInset.left = baseSize.inset.left
                }
            case .center:
                let imageViewhalf = (imageView.w + baseSize.imageGap) / 2
                switch imageAlignment {
                case .left:
                    imageView.x = ((w - strlen) / 2) - imageViewhalf
                    defaultInset.left = imageViewhalf
                    defaultInset.right = -defaultInset.left
                case .right:
                    imageView.x = (w / 2) + (strlen / 2) - imageViewhalf + baseSize.imageGap
                    defaultInset.left = -imageViewhalf
                    defaultInset.right = imageViewhalf
                }
            case .right:
                switch imageAlignment {
                case .left:
                    imageView.x = w - baseSize.inset.right - strlen - baseSize.imageGap - imageView.w
                    defaultInset.right = baseSize.inset.right
                case .right:
                    imageView.x = w - imageView.w - baseSize.inset.right
                    defaultInset.right = imageView.w + baseSize.inset.right + baseSize.imageGap
                }
            case .justified:
                break
            @unknown default:
                break
            }
        }

        textInset = defaultInset
        imageView.centerYInSuperView()
        setNeedsLayout()
        setNeedsDisplay()
    }

    override func drawText(in rect: CGRect) {
        if textInset != .zero {
            super.drawText(in: rect.inset(by: textInset))
        }
        else {
            super.drawText(in: rect)
        }
    }


}

