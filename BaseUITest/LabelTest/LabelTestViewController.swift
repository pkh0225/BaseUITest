//
//  ViewController.swift
//  BaseUITest
//
//  Created by pkh on 2021/07/27.
//

import UIKit
//
//struct DropDownData {
//    var title: String
//    var value: Any?
//}

class LabelTestViewController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"

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

    @IBAction func onFullCaseShow(_ sender: UIButton) {
        LabelFullCaseViewController.pushViewController()
    }
}



