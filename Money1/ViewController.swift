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
        var image:UIImage!
        var amount:Int = 0
        
    }
    
    @IBOutlet weak var isTodayLabel: UILabel! //用來顯示今日或是年份
    @IBOutlet weak var dateTextField:myUITextField! //顯示日期
    @IBOutlet weak var selectedItemLabel: UILabel!  //顯示選擇的類別
    @IBOutlet weak var dayAmount: UILabel! //單日的總花費
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var SelectBoxImage: UIImageView! //collectionView上的框框
    
    var record = Record()
    var myDatePicker :UIDatePicker!      //時間選擇器
    let YMDformatter = DateFormatter()   //年月
    let MDformatter = DateFormatter()    //月日
    let Yformatter = DateFormatter()     //年
    let timeformater = DateFormatter()   //時間
    let now = Date() //現在時間
    let numFormatter = NumberFormatter() //格式化數字
    
    var newRow:IndexPath!  //儲存tableView新增的列
    var ItemRow:IndexPath! //儲存collectionView選擇的列
//    let tapGestureRecognizer = UITapGestureRecognizer()
    
    
    //計算機
    @IBOutlet fileprivate weak var display: UILabel!  //顯示機算幾輸入的金額
    @IBOutlet fileprivate weak var descriptionLabel: UILabel! //暫時不用
    
    fileprivate var brain = CalculatorBrain() //實體化機算幾內部處理的類別
    fileprivate var userIsInTheMiddleOfTyping = false //是否有輸入過，預設沒有輸入過
    fileprivate let DECIMAL_CHAR = "." //小數點
    fileprivate var displayValue: Int {
        get {
            return Int(display.text!)! //取值的時候會回傳displayg上的數字
        }
        
        set {
            display.text = String(newValue) //設值的時候會將數字轉成String，然後顯示到display上
        }
    }
    
    //假資料
    //使用者花費資料
    var userConsumptionInfo:[UserConsumptionInfo] = []

    //花費類別
    var consumptionCategory:[ConsumptionCategory] = [
        ConsumptionCategory(name: "早餐", image:UIImage(named: "serve")!),ConsumptionCategory(name: "早餐", image:UIImage(named: "food")!),ConsumptionCategory(name: "早餐", image:UIImage(named: "serve")!),ConsumptionCategory(name: "超級無敵好吃的晚餐喔！！！", image:UIImage(named: "serve")!),ConsumptionCategory(name: "早餐", image:UIImage(named: "serve")!),ConsumptionCategory(name: "早餐", image:UIImage(named: "serve")!),ConsumptionCategory(name: "早餐", image:UIImage(named: "serve")!),ConsumptionCategory(name: "早餐", image:UIImage(named: "serve")!)]
    
    //第一次顯示畫面時會呼叫
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "記帳" //navigationbar上的title
        
        selectedItemLabel.text = "請選擇類別"
        
        //選擇框圖片外觀
        SelectBoxImage.backgroundColor = UIColor.clear
        SelectBoxImage.layer.cornerRadius = 5
        SelectBoxImage.layer.borderWidth = 2
        SelectBoxImage.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6274509804, alpha: 1).cgColor

        //tableView 外觀
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
        tableView.tableFooterView = UIView(frame: CGRect.zero) //消除多餘的分隔線
        
        //格式化數字
        numFormatter.numberStyle = .decimal
   
        
        //ToolBar放在日期選擇器上，點擊日期標籤時會跟日期選擇器一起彈出
        let ToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let SpaceLeft = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: #selector(keyboardHide), action: nil)
        let doneButton = UIBarButtonItem.init(title: "確定", style: .done, target: self, action: #selector(keyboardHide))
        doneButton.tintColor = #colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6274509804, alpha: 1)
        ToolBar.setItems([SpaceLeft,doneButton], animated: true) //加上按鈕
        
        //日期選擇器
        myDatePicker = UIDatePicker() //實體化
        myDatePicker.datePickerMode = .date //設定時間選擇器的模式
        myDatePicker.locale = Locale(identifier: "zh_TW") //時區，台灣
        myDatePicker.window?.makeKey()
        myDatePicker.backgroundColor = UIColor.white
        myDatePicker.setValue(#colorLiteral(red: 0.03921568627, green: 0.7411764706, blue: 0.6274509804, alpha: 1), forKey: "textColor")
//        myDatePicker.layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        myDatePicker.layer.backgroundColor = UIColor.clear.cgColor
//        myDatePicker.layer.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.5, blue: 0.1, alpha: 0).cgColor
//        let touchToCloseView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - myDatePicker.frame.height))
//        touchToCloseView.backgroundColor = UIColor.clear
//        touchToCloseView.isHidden = true
//        myDatePicker.addSubview(touchToCloseView)
        
        
        
        dateTextField.inputView = myDatePicker
        dateTextField.inputAccessoryView = ToolBar
        
        //格式化日期字串
        timeformater.dateFormat = "HH:mm"
        MDformatter.dateFormat = "MM.dd"
        YMDformatter.dateFormat = "YY-MM-dd"
        //日期顯示
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
    
    //MARK: UICollectionViewDataSource
    //顯示列的時候呼叫
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell

        
        cell.CategoryName.text = consumptionCategory[indexPath.row].name
        cell.categoryImage.image = consumptionCategory[indexPath.row].image

        cell.CategoryName.adjustsFontSizeToFitWidth = true
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
        let categoryImage = consumptionCategory[indexPath.row].image
        record.item = category
        record.image = categoryImage
        selectedItemLabel.text = category
        
        ItemRow = indexPath
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row = \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DayRecordTableViewCell
        
        cell.categoryName.text = userConsumptionInfo[indexPath.row].item
        cell.amount.text = String(userConsumptionInfo[indexPath.row].amount)
        cell.timeLabel.text = userConsumptionInfo[indexPath.row].time
        cell.categoryImage.image = userConsumptionInfo[indexPath.row].image

        
        //把最新的列存到newIndexpath
        if indexPath.row == 0 {
            print("indexPath.row = \(indexPath.row)")
            newRow = indexPath
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userConsumptionInfo.count
        
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    //格式化數字方法
    func checkNumber(labelText: String) -> String {
        var stringOfNumber:NSNumber
        stringOfNumber = numFormatter.number(from: labelText)!
        return String(describing: stringOfNumber)
    }

    
    
    //MARK: Target Action
    
    
    //新增按鈕
    @IBAction func appendRecord(_ sender: FancyButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
            brain.performOperand("=")
            displayValue = brain.result
            descriptionLabel.text = brain.description

        if (selectedItemLabel.text == "請選擇類別" /*||  Int(display.text!)! <= 08*/) {
            
            let alertController = UIAlertController(title: "提醒！", message: "請輸入完整資訊", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else if (selectedItemLabel.text != "請選擇類別" &&  Int(display.text!)! >= 0) {
            
            record.amount = Int(display.text!)!
            record.date = YMDformatter.string(from: myDatePicker.date)
            record.image = record.image
            record.time = timeformater.string(from: myDatePicker.date)
            record.item = selectedItemLabel.text!
        
            userConsumptionInfo.insert(UserConsumptionInfo(item: record.item, date: record.date, time: record.time, image: record.image, amount: record.amount), at: 0)
            //執行清除
            brain.performOperand("C")
            displayValue = brain.result
            descriptionLabel.text = brain.description
        
        }
        
        if collectionView.indexPathsForSelectedItems! != [] {
            if let ItemRow = ItemRow {
                consumptionCategory.insert(consumptionCategory[ItemRow.row], at: 0)
                consumptionCategory.remove(at: ItemRow.row + 1)
                collectionView.reloadData()
                collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                
            }
        }
        
        //新增的列顯示在最上
        tableView.reloadData()
        if let newRow = newRow {
            tableView.scrollToRow(at: newRow, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
    }
    

    
    
    
    
    //計算機
    @IBAction fileprivate func touchDigit(_ sender: UIButton) { //點擊0~9、小數點
        let digit = sender.currentTitle! //取數字鍵上的值
        if userIsInTheMiddleOfTyping { //如果有輸入過（不是第一次輸入）就進入
            let textCurrentlyInDisplay = display.text!
            if digit != DECIMAL_CHAR || display.text!.range(of: DECIMAL_CHAR) == nil { //輸入的不是小數點或display上沒有小數點
                display.text = textCurrentlyInDisplay + digit   //
                display.text = checkNumber(labelText: display.text!)
                
            }
        } else {    //第一次按會執行這
            if digit == DECIMAL_CHAR { //如果是小數點
                display.text = "0\(digit)"
                display.text = checkNumber(labelText: display.text!)

                
            } else {
                display.text = digit
                display.text = checkNumber(labelText: display.text!)

            }
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathOperation = sender.currentTitle {
            brain.performOperand(mathOperation)
        }
        
        displayValue = brain.result
        
        descriptionLabel.text = brain.description
    }
    



}
