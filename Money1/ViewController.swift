//
//  ViewController.swift
//  Money1
//
//  Created by ruru on 2017/7/24.
//  Copyright © 2017年 ruru. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate{
    
    struct Record {
        var item:String = ""
        var date:String = ""
        var time:String = ""
        var image:String = ""
        var amount:Int = 0
        
    }
    
    
    
    @IBOutlet weak var isTodayLabel: UILabel!
    @IBOutlet weak var dateTextField:myUITextField!
    @IBOutlet weak var selectedItemLabel: UILabel!
    @IBOutlet weak var dayAmount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    var record = Record()
    var myDatePicker :UIDatePicker!     //時間選擇器
    let YMDformatter = DateFormatter()    //初始化日期格式
    let MDformatter = DateFormatter()   //初始化日期格式
    let Yformatter = DateFormatter()
    let timeformater = DateFormatter()
    let now = Date()
    
    
    
    
    //caculator
    var isFirstKeyIn = true
    var firstNumber = 0
    var sum = 0
//    let tapGestureRecognizer = UITapGestureRecognizer()
    
    
    
    //使用者花費資料
    
    
    
    //假資料

    //花費類別
    var consumptionCategory:[ConsumptionCategory] = [
        ConsumptionCategory(name: "早餐", image:"serve"),ConsumptionCategory(name: "午餐", image:"serve"),
        ConsumptionCategory(name: "交通", image:"serve"),ConsumptionCategory(name: "娛樂", image:"serve"),
        ConsumptionCategory(name: "雜貨", image:"serve"),ConsumptionCategory(name: "住家", image:"serve"),
        ConsumptionCategory(name: "早餐", image:"serve"),ConsumptionCategory(name: "早餐", image:"serve")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isTodayLabel.text = "" 
        selectedItemLabel.text = "" //選擇類別後要顯示的文字，預設空
        tableView.tableFooterView = UIView(frame: CGRect.zero) //消除多餘的分隔線
        
        //加入觸控空白區域時關閉時間選擇器
//        tapGestureRecognizer.cancelsTouchesInView = false
//        tapGestureRecognizer.addTarget(self, action: #selector(keyboardHide))
//        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        //ToolBar
        let ToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let SpaceLeft = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: #selector(keyboardHide), action: nil)
//        let okButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        okButton.layer.cornerRadius = 15
//        okButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let doneButton = UIBarButtonItem.init(title: "確定", style: .done, target: self, action: #selector(keyboardHide))
        doneButton.tintColor = #colorLiteral(red: 0.2296798229, green: 0.347343564, blue: 0.596832037, alpha: 1)
        ToolBar.setItems([SpaceLeft,doneButton], animated: true)
        
        //日期選擇器
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.locale = Locale(identifier: "zh_TW")
//        myDatePicker.addTarget(self, action:  #selector(changeDateValue), for: UIControlEvents.valueChanged)
        myDatePicker.window?.makeKey()
        myDatePicker.backgroundColor = #colorLiteral(red: 0.2121357918, green: 0.9065322876, blue: 0.6393124461, alpha: 1)
        dateTextField.inputView = myDatePicker
        dateTextField.inputAccessoryView = ToolBar
        
        
//        dateTextField.inputAccessoryView = chickToolBar

        
        
        //日期顯示
        MDformatter.dateFormat = "MM/dd"
        YMDformatter.dateFormat = "YY-MM-dd"
        dateTextField.text = MDformatter.string(from: now)
        if YMDformatter.string(from: now) == YMDformatter.string(from: myDatePicker.date) {
            isTodayLabel.text = "今天"
        } else {
            dateTextField.text = MDformatter.string(from: myDatePicker.date)
            isTodayLabel.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numbers(_ sender: FancyButton) {
        let digit = sender.currentTitle
        if isFirstKeyIn {
            amountLabel.text = digit
            firstNumber = Int(amountLabel.text!)!
            isFirstKeyIn = false
        } else {
            amountLabel.text = amountLabel.text! + digit!
            firstNumber = Int(amountLabel.text!)!
        }
    }
    
   
    @IBAction func operate(_ sender: FancyButton) {
        let operater = sender.currentTitle!
        
        switch operater {
        case "+":
            sum = firstNumber + sum
            amountLabel.text = String(sum)
        case "−":
            sum = firstNumber - sum
            amountLabel.text = String(sum)
        default:
            break
        }
    }
    

    
    
    @IBAction func chickButton(_ sender: FancyButton) {
    }
    
    @IBAction func clearButton(_ sender: FancyButton) {
        amountLabel.text = "0"
        isFirstKeyIn = true
        firstNumber = 0
        sum = 0
    }
    
    //MARK: UICollectionViewDataSource
    //顯示列的時候呼叫
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell

        
        cell.CategoryName.text = consumptionCategory[indexPath.row].name
        cell.categoryImage.image =  UIImage(named: consumptionCategory[indexPath.row].image)
        
        cell.layer.cornerRadius = 15
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        return cell
        
    }
    
    //collectionView中有個item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consumptionCategory.count
        
    }
    
    //MARK: UICollectionViewDelegate
    //選取item後會呼叫
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = consumptionCategory[indexPath.row].name
        record.item = category
        selectedItemLabel.text = category
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DayRecordTableViewCell
        timeformater.dateFormat = "HH:mm"
        let time = timeformater.string(from: now)
        cell.timeLabel.text = time
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
        
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dateTextField.resignFirstResponder()
//    }
    
    
    //自製方法
    
    func keyboardHide() {
        if YMDformatter.string(from: now) == YMDformatter.string(from: myDatePicker.date) {
            isTodayLabel.text = "今天"
            dateTextField.text = MDformatter.string(from: myDatePicker.date)
        } else {
            Yformatter.dateFormat = "YYYY"
            isTodayLabel.text = Yformatter.string(from: myDatePicker.date)
            dateTextField.text = MDformatter.string(from: myDatePicker.date)
            
        }

        dateTextField.resignFirstResponder()
    }
    
    



}
