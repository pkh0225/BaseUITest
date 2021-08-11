import UIKit

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


        var imageSize: CGFloat {
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

            titleLabel?.font = baseSize.font
            if let image = image(for: .normal) {
                setImage(image, for: .normal)
            }

            titleLabel?.font = baseSize.font
            if let image = image(for: .normal) {
                let imageChange = image.toSize(image.size.ratioSize(setWidth: baseSize.imageSize))
                setImage(imageChange, for: .normal)
            }
            self.cornerRadius = baseSize.cornerRadius(rectStyle: rectStyle)
            updateUI()
        }
    }

    var rectStyle: RectStyle = .rect {
        didSet {
            self.cornerRadius = baseSize.cornerRadius(rectStyle: rectStyle)
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

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        if let image = image {
            let imageChange = image.toSize(image.size.ratioSize(setWidth: baseSize.imageSize))
            super.setImage(imageChange, for: state)
        }
        else {
            super.setImage(nil, for: state)
        }

        updateUI()
    }

    func updateUI() {
        switch contentAlignment {
        case .center:
            contentEdgeInsets = .zero
        case .left, .leading:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.inset.left, bottom: 0, right: 0)
        case .right, .trailing:
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.inset.right)
        case .fill:
            break
        @unknown default:
            break
        }

        if let image = self.image(for: .normal) {
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
            switch contentAlignment {
            case .center:
                imageEdgeInsets = .zero
                titleEdgeInsets = .zero
            case .left, .leading:
                switch imageAlignment {
                case .left:
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap, bottom: 0, right: 0)

                case .right:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: baseSize.imageGap, bottom: 0, right: 0)
                }

            case .right, .trailing:
                switch imageAlignment {
                case .left:
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap)

                case .right:
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseSize.imageGap)
                }

            case .fill:
                break
            @unknown default:
                break
            }

            let strlen = self.title(for: .normal)?.size(self.titleLabel?.font ?? UIFont()).w ?? 0
            let maxWidth = ceilUI(baseSize.inset.left + image.w + baseSize.imageGap + strlen + baseSize.inset.right)
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
            let strlen = self.title(for: .normal)?.size(self.titleLabel?.font ?? UIFont()).w ?? 0
            let maxWidth = ceilUI(baseSize.inset.left + strlen + baseSize.inset.right)
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

        setNeedsLayout()
    }
}

