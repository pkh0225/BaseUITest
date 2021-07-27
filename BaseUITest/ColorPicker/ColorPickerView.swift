//
//  ColorPicker.swift
//  BaseUITest
//
//  Created by pkh on 2021/07/27.
//

import UIKit
private var isShow: Bool = false

class ColorPickerView: UIView {
    var imageView = UIImageView()
    var lastColor: UIColor?
    var pickeredColorClosure: ((UIColor) -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    deinit {
        print(#function)
    }

    func setup() {
        self.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.05)
        imageView.borderWidth = 1
        imageView.borderColor = .black
        imageView.image = UIImage(named: "palette")
        imageView.size = imageView.image?.size ?? .zero
        self.addSubview(imageView)


        addTapGesture { [weak self] gestureRecognizers in
            guard let self = self else { return }
            self.hide()
        }
        imageView.addTapGesture { [weak self] gestureRecognizers in
            guard let self = self else { return }
            defer {
                self.hide()
            }
            let point = gestureRecognizers.location(in: self.imageView)
            if let lastColor = self.getPixelColor(pos: point) {
                print("color \(lastColor)")
                self.pickeredColorClosure?(lastColor)
            }
        }
    }

    func hide() {
//        self.transform = self.transform.scaledBy(x: 1, y: 1)
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 0.01, y: 0.01)
        }, completion: { _ in
            self.removeFromSuperview()
            isShow = false
        })
    }

    func show(completion: ((UIColor) -> Void)?) {
        guard isShow == false else { return }
        isShow = true
        let visibleWindow = window != nil ? window : UIWindow.visibleWindow()
        visibleWindow?.addSubview(self)
        visibleWindow?.bringSubviewToFront(self)
        self.frame = visibleWindow?.bounds ?? .zero
        imageView.centerInSuperView()

        pickeredColorClosure = completion
        self.imageView.transform = self.imageView.transform.scaledBy(x: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 100, y: 100)
        })
    }

    func getPixelColor(pos: CGPoint) -> UIColor? {
        guard let pixelData = self.imageView.image?.cgImage?.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.imageView.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

