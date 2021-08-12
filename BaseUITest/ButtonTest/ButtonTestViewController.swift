//
//  ViewController.swift
//  BaseUITest
//
//  Created by pkh on 2021/07/27.
//

import UIKit

struct DropDownData {
    var title: String
    var value: Any?
}

class ButtonTestViewController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"

    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var contenAlignmentButton: UIButton!
    @IBOutlet weak var imageAlignmentButton: UIButton!
    @IBOutlet weak var textColorButton: UIButton!
    @IBOutlet weak var fillColorButton: UIButton!
    @IBOutlet weak var borderColorButton: UIButton!
    @IBOutlet weak var rectStyleButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageSwitch: UISwitch!
    @IBOutlet weak var resultButton: BaseButton!
    @IBOutlet weak var resultButton2: BaseButton!


    let sizeList: [DropDownData] = [
        DropDownData(title: "XLarge", value: BaseButton.Size.XL),
        DropDownData(title: "Large", value: BaseButton.Size.L),
        DropDownData(title: "Medium", value: BaseButton.Size.M),
        DropDownData(title: "Small", value: BaseButton.Size.S),
        DropDownData(title: "XSmall", value: BaseButton.Size.XS),
    ]
    let contentAlignmentList: [DropDownData] = [
        DropDownData(title: "left", value: UIControl.ContentHorizontalAlignment.left),
        DropDownData(title: "center", value: UIControl.ContentHorizontalAlignment.center),
        DropDownData(title: "right", value: UIControl.ContentHorizontalAlignment.right),
    ]
    let imageAlignmentList: [DropDownData] = [
        DropDownData(title: "left", value: BaseButton.ImageAlignment.left),
        DropDownData(title: "right", value: BaseButton.ImageAlignment.right),
    ]
    let rectStyleList: [DropDownData] = [
        DropDownData(title: "rect", value: BaseButton.RectStyle.rect),
        DropDownData(title: "round", value: BaseButton.RectStyle.round),
        DropDownData(title: "oval", value: BaseButton.RectStyle.oval),
    ]
    //-------------------------------------------------------------------------------------------------------

    var dropDown: DropDown?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultButton.baseSize = .XL
        self.resultButton2.baseSize = .XL

    }

    func showDropDown(anchorView: UIView, dataList: [DropDownData], selectedIndex: Int, selectionAction: SelectionClosure?) {
        self.dropDown = DropDown()
        self.dropDown?.dataSource = dataList.map({ $0.title })
        self.dropDown?.anchorView = anchorView
        self.dropDown?.cornerRadius = 4
        self.dropDown?.bottomOffset = CGPoint(x: 0, y: anchorView.maxY + 5)
        self.dropDown?.selectRow(at: selectedIndex)
        self.dropDown?.selectionAction = selectionAction
        self.dropDown?.selectedTextColor = UIColor.black
        self.dropDown?.selectionBackgroundColor = .darkGray
        //        self.dropDown?.cancelAction = { [weak self] () in
        //            guard let self = self else { return }
        //        }
        self.dropDown?.show()

    }
    //MARK:- BaseButton
    @IBAction func onSizeButton(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: sizeList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.sizeList[safe: index], let value = item.value as? BaseButton.Size {
                sender.setTitle("Size.\(value.rawValue)", for: .normal)
                self.resultButton.baseSize = value
                self.resultButton2.baseSize = value
            }
        }
    }


    @IBAction func onContentAlignmentButton(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: contentAlignmentList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.contentAlignmentList[safe: index], let value = item.value as? UIControl.ContentHorizontalAlignment {
                sender.setTitle("Content.\(value.rawValue)", for: .normal)
                self.resultButton.contentAlignment = value
                self.resultButton2.contentAlignment = value
            }
        }
    }

    @IBAction func onImageAlignmentButon(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: imageAlignmentList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.imageAlignmentList[safe: index], let value = item.value as? BaseButton.ImageAlignment {
                sender.setTitle("Image.\(value.rawValue)", for: .normal)
                self.resultButton.imageAlignment = value
                self.resultButton2.imageAlignment = value
            }
        }
    }

    @IBAction func onRectStyle(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: rectStyleList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.rectStyleList[safe: index], let value = item.value as? BaseButton.RectStyle {
                sender.setTitle("rect.\(value.rawValue)", for: .normal)
                self.resultButton.rectStyle = value
                self.resultButton2.rectStyle = value
            }
        }
    }

    @IBAction func onTextColorButton(_ sender: UIButton) {
        ColorPickerView(frame: .zero).show { [weak self] color in
            guard let self = self else { return }
            sender.backgroundColor = color
            self.resultButton.titleLabel?.textColor = color
            self.resultButton2.titleLabel?.textColor = color
        }
    }

    @IBAction func onFillColorButton(_ sender: UIButton) {
        ColorPickerView(frame: .zero).show { [weak self] color in
            guard let self = self else { return }
            sender.backgroundColor = color
            self.resultButton.backgroundColor = color
            self.resultButton2.backgroundColor = color
        }
    }

    @IBAction func onBordColor(_ sender: UIButton) {
        ColorPickerView(frame: .zero).show { [weak self] color in
            guard let self = self else { return }
            sender.backgroundColor = color
            self.resultButton.borderColor = color
            self.resultButton.borderWidth = 1
            self.resultButton2.borderColor = color
            self.resultButton2.borderWidth = 1
        }
    }

    @IBAction func onImageSwitch(_ sender: UISwitch) {
        if sender.isOn {
            resultButton.setImage(UIImage(named: "view_big"), for: .normal)
            resultButton2.setImage(UIImage(named: "view_big"), for: .normal)
        }
        else {
            resultButton.setImage(nil, for: .normal)
            resultButton2.setImage(nil, for: .normal)
        }
    }

    @IBAction func onTextFielddidChange(_ sender: UITextField) {
        resultButton.setTitle(textField.text, for: .normal)
        resultButton2.setTitle(textField.text, for: .normal)
    }
    
    @IBAction func onRestultButton(_ sender: BaseButton) {
        alert(title: "버튼")
    }
    
    @IBAction func onFullCaseShow(_ sender: UIButton) {
        ButtonFullCaseViewController.pushViewController()
    }
}



