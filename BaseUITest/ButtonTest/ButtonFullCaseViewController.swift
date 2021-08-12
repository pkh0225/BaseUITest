//
//  ButtonFullCaseViewController.swift
//  BaseUITest
//
//  Created by pkh on 2021/08/11.
//

import UIKit


class ButtonFullCaseViewController: UITableViewController, RouterProtocol {
    static var storyboardName: String = "Main"


    var dataList = [[UI_BaseButton]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataList.append(testDataMake(size: .XL))
        dataList.append(testDataMake(size: .L))
        dataList.append(testDataMake(size: .M))
        dataList.append(testDataMake(size: .S))
        dataList.append(testDataMake(size: .XS))


    }

    func testDataMake(size: BaseButton.Size) -> [UI_BaseButton] {
        return [
            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .left, rectStyle: .rect, text: "Test", image: nil, data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .left, rectStyle: .rect, text: "Test", image: nil, data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .left, rectStyle: .rect, text: "Test", image: nil, data: nil),

            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .left, rectStyle: .round, text: "Test", image: nil, data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .left, rectStyle: .round, text: "Test", image: nil, data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .left, rectStyle: .round, text: "Test", image: nil, data: nil),

            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .left, rectStyle: .oval, text: "Test", image: nil, data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .left, rectStyle: .oval, text: "Test", image: nil, data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .left, rectStyle: .oval, text: "Test", image: nil, data: nil),


            // image
            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .left, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .left, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .left, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),


            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .left, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .left, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .left, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .left, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .left, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .left, rectStyle: .oval, text: "Test", image: UIImage(named: "arrow_right"), data: nil),


            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .right, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .right, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .right, rectStyle: .rect, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .right, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .right, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .right, rectStyle: .round, text: "Test", image: UIImage(named: "view_big"), data: nil),

            UI_BaseButton(size: size, contentAlignment: .left, imageAlignment: .right, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .center, imageAlignment: .right, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
            UI_BaseButton(size: size, contentAlignment: .right, imageAlignment: .right, rectStyle: .oval, text: "Test", image: UIImage(named: "view_big"), data: nil),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonFullCaseCell", for: indexPath) as! ButtonFullCaseCell

        let data = dataList[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor.lightGray

        // width fixed test
        cell.button.baseSize = data.size
        cell.button.contentAlignment = data.contentAlignment
        cell.button.imageAlignment = data.imageAlignment
        cell.button.rectStyle = data.rectStyle
        cell.button.setTitle("width fixed"/*data.text*/, for: .normal)
        cell.button.setImage(data.image, for: .normal)
        cell.button.fillColor = .yellow
        cell.button.borderColor = .blue

        // width flexible test
        cell.button2.baseSize = data.size
        cell.button2.contentAlignment = data.contentAlignment
        cell.button2.imageAlignment = data.imageAlignment
        cell.button2.rectStyle = data.rectStyle
        cell.button2.setTitle("width flexible"/*data.text*/, for: .normal)
        cell.button2.setImage(data.image, for: .normal)
        cell.button2.fillColor = .green
        cell.button2.borderColor = .red

        // image only test
        cell.button3.baseSize = data.size
        cell.button3.contentAlignment = data.contentAlignment
        cell.button3.imageAlignment = data.imageAlignment
        cell.button3.rectStyle = data.rectStyle
//        cell.button3.setTitle(data.text, for: .normal)
//        cell.button3.setImage(data.image, for: .normal)
        cell.button3.fillColor = .green
        cell.button3.borderColor = .red

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataList[section][0].size.rawValue
    }
}

class ButtonFullCaseCell: UITableViewCell {

    @IBOutlet weak var button: BaseButton!
    @IBOutlet weak var button2: BaseButton!
    @IBOutlet weak var button3: BaseButton!
}

