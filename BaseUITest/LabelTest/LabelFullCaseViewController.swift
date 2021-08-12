//
//  ButtonFullCaseViewController.swift
//  BaseUITest
//
//  Created by pkh on 2021/08/11.
//

import UIKit


class LabelFullCaseViewController: UITableViewController, RouterProtocol {
    static var storyboardName: String = "Main"


    var dataList = [[UI_BaseLabel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataList.append(testDataMake(size: .L))
        dataList.append(testDataMake(size: .M))
        dataList.append(testDataMake(size: .S))

    }

    func testDataMake(size: BaseLabel.Size) -> [UI_BaseLabel] {
        return [
            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .left, rectStyle: .rect, text: "Test", image: nil, data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .left, rectStyle: .rect, text: "Test", image: nil, data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .left, rectStyle: .rect, text: "Test", image: nil, data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .left, rectStyle: .round, text: "Test", image: nil, data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .left, rectStyle: .round, text: "Test", image: nil, data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .left, rectStyle: .round, text: "Test", image: nil, data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .left, rectStyle: .oval, text: "Test", image: nil, data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .left, rectStyle: .oval, text: "Test", image: nil, data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .left, rectStyle: .oval, text: "Test", image: nil, data: nil),

            // image
            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .left, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .left, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .left, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .left, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .left, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .left, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .left, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .left, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .left, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .right, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .right, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .right, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .right, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .right, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .right, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseLabel(size: size, textAlignment: .left, imageAlignment: .right, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .center, imageAlignment: .right, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseLabel(size: size, textAlignment: .right, imageAlignment: .right, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            ]

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataList.map { $0[0].size.rawValue }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelFullCaseCell", for: indexPath) as! LabelFullCaseCell

        let data = dataList[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor.lightGray

        cell.label.baseSize = data.size
        cell.label.textAlignment = data.textAlignment
        cell.label.imageAlignment = data.imageAlignment
        cell.label.rectStyle = data.rectStyle
        cell.label.text = "width fixed" // data.text
        cell.label.image = data.image
        cell.label.fillColor = .green
        cell.label.borderColor = .red

        cell.label2.baseSize = data.size
        cell.label2.textAlignment = data.textAlignment
        cell.label2.imageAlignment = data.imageAlignment
        cell.label2.rectStyle = data.rectStyle
        cell.label2.text = "width flexible" // data.text
        cell.label2.image = data.image
        cell.label2.fillColor = .yellow
        cell.label2.borderColor = .blue

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataList[section][0].size.rawValue
    }
}

class LabelFullCaseCell: UITableViewCell {

    @IBOutlet weak var label: BaseLabel!
    @IBOutlet weak var label2: BaseLabel!
}

