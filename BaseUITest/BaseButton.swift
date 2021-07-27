import UIKit

class BaseButton: UIButton {
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
                case .XSmall:
                    return 2
                case .XXSmall:
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
        case XSmall
        case XXSmall

        func height() -> CGFloat {
            switch self {
            case .Large:
                return 60
            case .Medium:
                return 50
            case .Small:
                return 44
            case .XSmall:
                return 30
            case .XXSmall:
                return 24
            }
        }

        func font() -> UIFont {
            var fontName: String = ""
            var size: CGFloat = 0
            switch self {
            case .Large:
                fontName = "AppleSDGothicNeo-Bold"
                size = 18
            case .Medium:
                fontName = "AppleSDGothicNeo-Bold"
                size = 18
            case .Small:
                fontName = "AppleSDGothicNeo-Regular"
                size = 16
            case .XSmall:
                fontName = "AppleSDGothicNeo-Regular"
                size = 12
            case .XXSmall:
                fontName = "AppleSDGothicNeo-Regular"
                size = 12
            }

            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        }

        func imageSize() -> CGFloat {
            switch self {
            case .Large:
                return 24
            case .Medium:
                return 24
            case .Small:
                return 20
            case .XSmall:
                return 16
            case .XXSmall:
                return 16
            }
        }

        func imageGap() -> CGFloat {
            switch self {
            case .Large:
                return 4
            case .Medium:
                return 4
            case .Small:
                return 2
            case .XSmall:
                return 0
            case .XXSmall:
                return 0
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

            titleLabel?.font = baseSize.font()
            if let image = image(for: .normal) {
                setImage(image, for: .normal)
            }

            titleLabel?.font = baseSize.font()
            if let image = image(for: .normal) {
                let imageChange = image.toSize(image.size.ratioSize(setWidth: baseSize.imageSize()))
                setImage(imageChange, for: .normal)
            }
            self.cornerRadius = rectStyle.cornerRadius(size: baseSize)
        }
    }

    var rectStyle: RectStyle = .rect {
        didSet {
            self.cornerRadius = rectStyle.cornerRadius(size: baseSize)
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

            updateUI(image: image(for: .normal))
        }
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        if let image = image {
            let imageChange = image.toSize(image.size.ratioSize(setWidth: baseSize.imageSize()))
            super.setImage(imageChange, for: state)
        }
        else {
            super.setImage(nil, for: state)
        }
    }

    func updateUI(image: UIImage? = nil) {
        switch contentAlignment {
        case .center:
            break
        case .left, .leading:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        case .right, .trailing:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        case .fill:
            break
        @unknown default:
            break
        }

        if let _ = image {
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
            switch contentAlignment {
            case .center:
                switch imageAlignment {
                case .left:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap() / 2)
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap() / 2, bottom: 0, right: 0)

                case .right:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap() / 2, bottom: 0, right: 0)
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap() / 2)
                }
            case .left, .leading:
                switch imageAlignment {
                case .left:
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap(), bottom: 0, right: 0)

                case .right:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap(), bottom: 0, right: 0)
                }

            case .right, .trailing:
                switch imageAlignment {
                case .left:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap())

                case .right:
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap())
                }

            case .fill:
                break
            @unknown default:
                break
            }

//            let maxWidth = ceilUI(gap + imageView.w + baseSize.imageGap() + strlen + gap)
//            if translatesAutoresizingMaskIntoConstraints == false {
//                if isWidthConstraint == false {
//                    if let widthConst = widthConst {
//                        widthConst.constant = maxWidth
//                    }
//                    else {
//                        widthConst = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: maxWidth)
//                        addConstraint(widthConst!)
//                    }
//                }
//            }
//            w = maxWidth
        }

        setNeedsLayout()
    }
}

