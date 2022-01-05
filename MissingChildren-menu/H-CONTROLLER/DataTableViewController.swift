import UIKit
import SQLite3

//定義失蹤人口結構
struct MissingPerson
{
    var no = ""
    var name = ""       //2
    var picture:Data?   //1
    var gender = ""     //3
    var age = ""        //4
    var nAge = ""       //5
    var time = ""       //6
    var place = ""      //7
    var reason = ""     //8
    var other = ""      //9
}


class DataTableViewController: UITableViewController
{
    //滑動返回上一頁
  
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    //宣告資料庫連線指標
    var db:OpaquePointer?
    //接收上一頁的執行實體。埋設接收屬性，在兩個類別之間傳遞資料
    weak var filterTableVC:filterViewController!
    
    //記錄單一資料行
    var structRow = MissingPerson()
    //宣告失蹤人口陣列，存放從資料庫查詢到的資料（此陣列即『離線資料集』）
    var arrTable = [MissingPerson]()
    
    //取得filterVC的genderTextField.text
    var filter_Gender:String = ""
    //取得filterVC的ageTextField.text
    var filterAge:String = ""
    
    var filterPlace:String = ""
    
    
    //MARK: - 自訂函式
    //查詢資料庫，存放到離線資料集
    func getDataFromTable()
    {
        //先清空陣列再執行
        arrTable.removeAll()
        //準備查詢用的sql指令
        let sql = "select no,name,picture,gender,age,nAge,time,place,reason,other from projectdata where gender = '\(filter_Gender)'and age = '\(filterAge)'and place = '\(filterPlace)'"
        //let sql = "select no,name,picture,gender,age,nAge,time,place,reason,other from projectdata order by no;" //勿使用"*"
        //將sql指令轉換成c語言的字元陣列
        let cSql = sql.cString(using: .utf8)!
        //宣告儲存查詢結果的指標
        var statement:OpaquePointer?
        //準備查詢（第三個參數若為正數，則限定資料庫指定的長度。負數則不限sql指令的長度。第四個和第六個參數為預留參數，目前沒有作用。）
        if sqlite3_prepare_v3(db, cSql, -1, 0, &statement, nil) == SQLITE_OK
        {
            print("資料庫查詢指令執行成功")
            //往下讀取『連線資料集』(statement)中的一筆資料
            while sqlite3_step(statement) == SQLITE_ROW
            {
                //讀取當筆資料的每一欄
                let no = sqlite3_column_text(statement!, 0)!
                let strNO = String(cString: no)
                structRow.no = strNO
                
                let name = sqlite3_column_text(statement!, 1)!
                let strName = String(cString: name)
                structRow.name = strName
                
               
                //準備當筆的圖檔資料而埋設以下屬性
                var imgData:Data!
                //若有讀取到檔案位元資料，
                if let totalBytes = sqlite3_column_blob(statement!, 2)
                {
                    //讀取檔案長度
                    let fileLength = Int(sqlite3_column_bytes(statement!, 2))
                    //將檔案的位元資料和檔案長度初始化成為Data
                    imgData = Data(bytes: totalBytes, count: fileLength)
                }
                else    //當照片欄位為null
                {
                    //以預設大頭照來產生Data
                    //需要轉型為jpegData
                    imgData = UIImage(named: "Dexter")!.jpegData(compressionQuality: 0.8)
                }
                //將大頭照的Data存入結構成員
                structRow.picture = imgData
                
                
                let gender = sqlite3_column_text(statement!, 3)!
                let strGender = String(cString: gender)
                structRow.gender = strGender

                let age = sqlite3_column_text(statement!, 4)!
                let strAge = String(cString: age)
                structRow.age = strAge

                let nAge = sqlite3_column_text(statement!, 5)!
                let strnAge = String(cString: nAge)
                structRow.nAge = strnAge

                let time = sqlite3_column_text(statement!, 6)!
                let strTime = String(cString:time)
                structRow.time = strTime

                let place = sqlite3_column_text(statement!, 7)!
                let strPlace = String(cString: place)
                structRow.place = strPlace

                let reason = sqlite3_column_text(statement!, 8)!
                let strReason = String(cString: reason)
                structRow.reason = strReason

                let other = sqlite3_column_text(statement!, 9)!
                let strOther = String(cString: other)
                structRow.other = strOther
                
                //將整筆資料加入陣列
                arrTable.append(structRow)
                
            }
            //如果有取得資料
            if statement != nil
            {
                //則關閉SQL連線資料集
                sqlite3_finalize(statement!)
                print("YEss")
            }
        }
        if arrTable.count == 0
        {
            print("No Data")
            
            
            var popup_controller:UIAlertController
            popup_controller = UIAlertController(
                title: "查無資料",
                message: "請重新確認內容",
                preferredStyle:UIAlertController.Style.alert)
            
            let button:UIAlertAction = UIAlertAction(
                title: "好的",
                style: UIAlertAction.Style.default,
                handler:
                    {
                    (UIAlertAction)->Void
                    in
                        self.navigationController?.popViewController(animated: true)
                    }


            )
            
            popup_controller.addAction(button)
            self.present(popup_controller, animated: true, completion: nil)

        }
        
        //使用main佇列
        DispatchQueue.main.async {
            //重整表格資料
            self.tableView.reloadData()
        }
        
    }
    
    //由下拉更新元件呼叫的觸發事件
    @objc func handleRefresh()
    {
        //Step1.重新讀取實際資料庫的資料，並且填入離線資料集(arrTable)
        getDataFromTable()

        //Step2.執行表格資料更新（重新執行tableview,datasource三個事件）
        self.tableView.reloadData()
        
        //Steo3.停止下拉後的動畫特效並復原表格位置
        self.tableView.refreshControl?.endRefreshing()
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //取得資料庫連線
        db = (UIApplication.shared.delegate as! AppDelegate).getDB()
        //取得global佇列
        let global = DispatchQueue.global()
        global.async{
            //執行資料庫查詢
            self.getDataFromTable()
        }
       
        //準備下拉更新元件
        self.tableView.refreshControl = UIRefreshControl()
        //當下拉更新元件出現時，(觸發valuechanged事件)，綁定執行事件
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //提供下拉更新元件的提示文字
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return arrTable.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        //print("詢問第\(indexPath.section)段,第\(indexPath.row)列的儲存格")
        
        //注意：使用自定義儲存格，必須完成自定儲存格類別的轉型
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellTableViewCell", for: indexPath) as! MyCellTableViewCell
        cell.imgPicture.image = UIImage(data: arrTable[indexPath.row].picture!)
        cell.lblName.text = arrTable[indexPath.row].name
        cell.lblGender.text = arrTable[indexPath.row].gender
        cell.lblTime.text = arrTable[indexPath.row].time

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("即將由導覽線換頁時")
        //由導覽線取得下一頁的執行實體
        let detailVC = segue.destination as! DetailView
        //通知下一頁目前本頁的執行實體所在位置
        detailVC.DataTableVC = self
    }

  
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

