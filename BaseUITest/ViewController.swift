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

class ViewController: UIViewController {

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


    @IBOutlet weak var LabelSizeButton: UIButton!
    @IBOutlet weak var LabelAlignmentButton: UIButton!
    @IBOutlet weak var LabelImageAlignmentButton: UIButton!
    @IBOutlet weak var LabelTextColorButton: UIButton!
    @IBOutlet weak var LabelFillColorButton: UIButton!
    @IBOutlet weak var LabelBorderColorButton: UIButton!
    @IBOutlet weak var LabelRectStyleButton: UIButton!
    @IBOutlet weak var LabelTextField: UITextField!
    @IBOutlet weak var LabelImageSwitch: UISwitch!
    @IBOutlet weak var resultLabel: BaseLabel!
    @IBOutlet weak var resultLabel2: BaseLabel!


    let LabelsizeList: [DropDownData] = [ DropDownData(title: "Large", value: BaseLabel.Size.L),
                                          DropDownData(title: "Medium", value: BaseLabel.Size.M),
                                          DropDownData(title: "Small", value: BaseLabel.Size.S),
    ]
    let LabelAlignmentList: [DropDownData] = [ DropDownData(title: "left", value: NSTextAlignment.left),
                                               DropDownData(title: "center", value: NSTextAlignment.center),
                                               DropDownData(title: "right", value: NSTextAlignment.right),
    ]
    let LabelImageAlignmentList: [DropDownData] = [ DropDownData(title: "left", value: BaseLabel.ImageAlignment.left),
                                                    DropDownData(title: "right", value: BaseLabel.ImageAlignment.right),
    ]
    let LabelRectStyleList: [DropDownData] = [ DropDownData(title: "rect", value: BaseLabel.RectStyle.rect),
                                               DropDownData(title: "round", value: BaseLabel.RectStyle.round),
                                               DropDownData(title: "oval", value: BaseLabel.RectStyle.oval),
    ]
    //-------------------------------------------------------------------------------------------------------


    var dropDown: DropDown?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultButton.baseSize = .XL
        self.resultButton2.baseSize = .XL

        self.resultLabel.baseSize = .L
        self.resultLabel2.baseSize = .L
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


    // MARK: - BaseLabel
    @IBAction func onLabeSizeButton(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: LabelsizeList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.LabelsizeList[safe: index], let value = item.value as? BaseLabel.Size {
                sender.setTitle("Size.\(value.rawValue)", for: .normal)
                self.resultLabel.baseSize = value
                self.resultLabel2.baseSize = value
            }
        }
    }


    @IBAction func onLabeAlignmentButton(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: LabelAlignmentList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.LabelAlignmentList[safe: index], let value = item.value as? NSTextAlignment {
                sender.setTitle("Content.\(value.rawValue)", for: .normal)
                self.resultLabel.textAlignment = value
            }
        }
    }

    @IBAction func onLabeImageAlignmentButon(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: LabelImageAlignmentList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.LabelImageAlignmentList[safe: index], let value = item.value as? BaseLabel.ImageAlignment {
                sender.setTitle("Image.\(value.rawValue)", for: .normal)
                self.resultLabel.imageAlignment = value
                self.resultLabel2.imageAlignment = value
            }
        }
    }

    @IBAction func onLabeRectStyle(_ sender: UIButton) {
        showDropDown(anchorView: sender, dataList: LabelRectStyleList, selectedIndex: sender.tag) { [weak self] index, title in
            guard let self = self else { return }
            sender.tag = index
            if let item = self.LabelRectStyleList[safe: index], let value = item.value as? BaseLabel.RectStyle {
                sender.setTitle("rect.\(value.rawValue)", for: .normal)
                self.resultLabel.rectStyle = value
                self.resultLabel2.rectStyle = value
            }
        }
    }

    @IBAction func onLabeTextColorButton(_ sender: UIButton) {
        ColorPickerView(frame: .zero).show { [weak self] color in
            guard let self = self else { return }
            sender.backgroundColor = color
            self.resultLabel.textColor = color
            self.resultLabel2.textColor = color
        }
    }

    @IBAction func onLabeFillColorButton(_ sender: UIButton) {
        ColorPickerView(frame: .zero).show { [weak self] color in
            guard let self = self else { return }
            sender.backgroundColor = color
            self.resultLabel.backgroundColor = color
            self.resultLabel2.backgroundColor = color
        }
    }

    @IBAction func LabeBordColor(_ sender: UIButton) {
        ColorPickerView(frame: .zero).show { [weak self] color in
            guard let self = self else { return }
            sender.backgroundColor = color
            self.resultLabel.borderColor = color
            self.resultLabel.borderWidth = 1
            self.resultLabel2.borderColor = color
            self.resultLabel2.borderWidth = 1
        }
    }

    @IBAction func onLabeImageSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.resultLabel.image = UIImage(named: "view_big")
            self.resultLabel2.image = UIImage(named: "view_big")
        }
        else {
            self.resultLabel.image = nil
            self.resultLabel2.image = nil
        }
    }

    @IBAction func onLabeTextFielddidChange(_ sender: UITextField) {
        resultLabel.text = sender.text
        resultLabel2.text = sender.text
    }
}



