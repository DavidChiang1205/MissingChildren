import UIKit
import SQLite3
import MessageUI

class DetailView: UIViewController,UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate
{
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblnAge: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblOther: UITextView!
    
   
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //宣告資料庫連線指標
    var db:OpaquePointer?
    //接收上一頁的執行實體。埋設接收屬性，在兩個類別之間傳遞資料
    weak var DataTableVC:DataTableViewController!
    //記錄目前被點選的資料行
    var currentRow = 0
    //記錄目前處理中的學生資料
    var currentData = MissingPerson()
    //記錄目前輸入元件的Y軸底緣位置
    var currentObjectBottomYPosition:CGFloat = 0
    
    
    //MARK: - 導覽列更多按鈕
    @objc func buttonMoreAction(_ sender:UIBarButtonItem)
    {
        print ("更多按鈕被按下")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "撥號", style: .default, handler: {
            action
            in
            let url = URL(string: "tel://110")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "傳送SMS", style: .default, handler: {
            action
            in
           self.SMS()
        }))
        
        let alertCancel = UIAlertAction(title: "取消", style: .default) {
            (UIAlertAction) -> Void
            in
        }
        alert.addAction(alertCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //取得資料庫連線
        db = (UIApplication.shared.delegate as! AppDelegate).getDB()
        //哪一個儲存格被點選
        currentRow = DataTableVC.tableView.indexPathForSelectedRow!.row
        //由上一頁的陣列紀錄當筆資料
        currentData = DataTableVC.arrTable[currentRow]
        //將資料顯示在介面上:
        //顯示圖片：使用選擇性綁定語法
        if let dataPic = currentData.picture
        {
            imgPicture.image = UIImage(data: dataPic)
        }
        //顯示姓名
        lblName.text = currentData.name
        //顯示性別
        lblGender.text = currentData.gender
        //顯示年齡
        lblAge.text = currentData.age
        //顯示失蹤年齡
        lblnAge.text = currentData.nAge
        //顯示失蹤時間
        lblTime.text = currentData.time
        //顯示失蹤地區
        lblPlace.text = currentData.place
        //顯示失蹤原因
        lblReason.text = currentData.reason
        //顯示其他說明
        lblOther.text = currentData.other
        
        
        //在導覽列新增左右側按鈕
        let strMore = NSLocalizedString("更多", tableName: "InfoPlist", bundle: Bundle.main, value: "", comment: "")
        //右側按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: strMore, style: .plain, target: self, action: #selector(buttonMoreAction(_:)))
    }
    
    
    //MARK: - 自訂函式
    
    //傳送簡訊的自訂函式
    func SMS()
    {
        let MessageSender = MFMessageComposeViewController()
        MessageSender.delegate = self
        //首先要判斷裝置具不具備傳送簡訊功能
        if MFMessageComposeViewController.canSendText()
            {
            let controller = MFMessageComposeViewController()
                //設定簡訊內容
            controller.body = "我找到失蹤兒童\(currentData.name)！！"
                //設定收件人列表
                controller.recipients = ["0938181521"]
                    //設定代理
                controller.messageComposeDelegate = self
                    //開啟介面
            self.present(controller, animated: true, completion: { () -> Void in }) }
        else
        {
            print("本裝置不能傳送簡訊")
            
        }
        
    }
    //傳送簡訊代理
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        controller.dismiss(animated: true, completion: nil)
        switch result.rawValue
        {
        case MessageComposeResult.sent.rawValue: print("簡訊已傳送")
        case MessageComposeResult.cancelled.rawValue: print("簡訊取消傳送")
        case MessageComposeResult.failed.rawValue:print("簡訊傳送失敗")
            
        default: break
            
        }
        
    }
    //MARK: - 觸摸其它地方關閉編輯
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

