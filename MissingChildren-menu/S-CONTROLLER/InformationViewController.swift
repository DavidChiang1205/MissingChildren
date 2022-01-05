import UIKit
import Firebase
import FirebaseAuth

class InformationViewController: UIViewController
{
    
    //由第二頁紀錄第一頁（第一頁導覽線也設定完畢後，此頁即可使用此變數來改變或引用第一頁的東西）
    weak var vc:ViewController!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //設定導覽列標題
        self.navigationItem.title = "關於"
        
        //預設如果目前帳號登入狀況是空的（沒登入）
        if Auth.auth().currentUser == nil
        {
            //隱藏按鈕
            self.logoutButton.isHidden = true
        }
        else
        {
            self.logoutButton.isHidden = false
        }
    }
    
    
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButton(_ sender: UIButton)
    {
        //如果當前帳戶不是空的（處於登入狀態）
        if Auth.auth().currentUser != nil
        {
            do{
                //嘗試登出，並跳轉到成功登出頁面
                try Auth.auth().signOut()
                
                //如果未登出直接重啟app後，首頁會保持登入狀態，但按下登出後首頁label文字不會改變，故在成功登出後需將label文字重新設定回來，即可解決重啟app按下登出卻不會改變label文字的問題
                //改變第一頁的changedWord的值
                vc.changedWord.text = "登入/註冊"
                
                self.performSegue(withIdentifier: "GotoLogoutVC", sender: sender)
                
            }catch let error as NSError{
                
                //後台列印錯誤（失效：此語法後台目前沒有列印錯誤，但也不影響執行！）
                print(error.localizedDescription)
                
                
            }
        }
        
    }
}
