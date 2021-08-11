import UIKit

class BaseLabel: UILabel {
    enum RectStyle: String {
        case rect
        case round
        case oval

        func cornerRadius(size: Size) -> CGFloat {
            switch self {
            case .rect:
                return 0
            case .round:
                switch size {
                case .Large:
                    return 6
                case .Medium:
                    return 4
                case .Small:
                    return 2
                }
            case .oval:
                return size.height() / 2.0
            }
        }
    }

    enum ImageAlignment: String {
        case left
        case right
    }

    enum Size: String {
        case Large
        case Medium
        case Small

        func height() -> CGFloat {
            switch self {
            case .Large:
                return 24
            case .Medium:
                return 20
            case .Small:
                return 16
            }
        }

        func font() -> UIFont {
            var fontName: String = ""
            var size: CGFloat = 0
            switch self {
            case .Large:
                fontName = "AppleSDGothicNeo-Bold"
                size = 12
            case .Medium:
                fontName = "AppleSDGothicNeo-Medium"
                size = 12
            case .Small:
                fontName = "AppleSDGothicNeo-Bold"
                size = 10
            }

            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        }

        func imageSize() -> CGFloat {
            switch self {
            case .Large:
                return 16
            case .Medium:
                return 12
            case .Small:
                return 8
            }
        }

        func imageGap() -> CGFloat {
            switch self {
            case .Large:
                return 1
            case .Medium:
                return 1
            case .Small:
                return 1
            }
        }

        func inset() -> UIEdgeInsets {
            switch self {
            case .Large:
                return UIEdgeInsets(top: 1.5, left: 8, bottom: -1.5, right: 8)
            case .Medium:
                return UIEdgeInsets(top: 1, left: 6, bottom: -1, right: 6)
            case .Small:
                return UIEdgeInsets(top: 0.5, left: 4, bottom: -0.5, right: 4)
            }
        }
    }
    private var widthConst: NSLayoutConstraint? = nil
    private var heightConst: NSLayoutConstraint? = nil

    var baseSize: Size = .Medium {
        didSet {
            if translatesAutoresizingMaskIntoConstraints == false {
                if isHeightConstraint {
                    heightConstraint = baseSize.height()
                }
                else {
                    if let heightConst = heightConst {
                        heightConst.constant = baseSize.height()
                    }
                    else {
                        heightConst = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: baseSize.height())
                        addConstraint(heightConst!)
                    }
                }
            }
            frame.size.height = baseSize.height()

            font = baseSize.font()
            if let image = image {
                imageView.isHidden = false
                imageView.image = image
                imageView.size = image.size.ratioSize(setWidth: baseSize.imageSize())
            }
            self.cornerRadius = rectStyle.cornerRadius(size: baseSize)
            updateUI()
        }
    }

    var rectStyle: RectStyle = .rect {
        didSet {
            self.cornerRadius = rectStyle.cornerRadius(size: baseSize)
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            updateUI()
        }
    }

    override var text: String? {
        didSet {
            updateUI()
        }
    }

    var imageAlignment: ImageAlignment = .left {
        didSet {
            updateUI()
        }
    }

    var image: UIImage? = nil {
        didSet {
            if let image = image {
                imageView.isHidden = false
                imageView.image = image
                imageView.size = image.size.ratioSize(setWidth: baseSize.imageSize())
            }
            else {
                imageView.isHidden = true
            }
            updateUI()
        }
    }

    lazy var imageView: UIImageView = {
        let v = UIImageView()
//        v.borderColor = .green
//        v.borderWidth = 1
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

    func updateUI() {
        var defaultInset = baseSize.inset()

        if let _ = image {
            let strlen = text?.size(font).w ?? 0

            switch textAlignment {
            case .left, .natural:
                switch imageAlignment {
                case .left:
                    imageView.x = baseSize.inset().left
                    defaultInset.left = imageView.maxX + baseSize.imageGap()
                case .right:
                    imageView.x = baseSize.inset().left + strlen + baseSize.imageGap()
                    defaultInset.left = baseSize.inset().left
                }
            case .center:
                let imageViewhalf = (imageView.w + baseSize.imageGap()) / 2
                switch imageAlignment {
                case .left:
                    imageView.x = ((w - strlen) / 2) - imageViewhalf
                    defaultInset.left = imageViewhalf
                    defaultInset.right = -defaultInset.left
                case .right:
                    imageView.x = (w / 2) + (strlen / 2) - imageViewhalf + baseSize.imageGap()
                    defaultInset.left = -imageViewhalf
                    defaultInset.right = imageViewhalf
                }
            case .right:
                switch imageAlignment {
                case .left:
                    imageView.x = w - baseSize.inset().right - strlen - baseSize.imageGap() - imageView.w
                    defaultInset.right = baseSize.inset().right
                case .right:
                    imageView.x = w - imageView.w - baseSize.inset().right
                    defaultInset.right = imageView.w + baseSize.inset().right + baseSize.imageGap()
                }
            case .justified:
                break
            @unknown default:
                break
            }

            let maxWidth = ceilUI(baseSize.inset().left + imageView.w + baseSize.imageGap() + strlen + baseSize.inset().right)
            if translatesAutoresizingMaskIntoConstraints == false {
                if isWidthConstraint == false {
                    if let widthConst = widthConst {
                        widthConst.constant = maxWidth
                    }
                    else {
                        widthConst = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: maxWidth)
                        addConstraint(widthConst!)
                    }
                }
            }
            w = maxWidth
        }
        else {
            let strlen = text?.size(font).w ?? 0
            let maxWidth = ceilUI(baseSize.inset().left + strlen + baseSize.inset().right)
            if translatesAutoresizingMaskIntoConstraints == false {
                if isWidthConstraint == false {
                    if let widthConst = widthConst {
                        widthConst.constant = maxWidth
                    }
                    else {
                        widthConst = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: maxWidth)
                        addConstraint(widthConst!)
                    }
                }
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

