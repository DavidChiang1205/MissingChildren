import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController
{

    @IBOutlet weak var loginOrRegister: UIButton!
    @IBOutlet weak var changedWord: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil
        {
            self.changedWord.text = "登出"
        }
        else if Auth.auth().currentUser == nil
        {
            self.changedWord.text = "登入/註冊"
        }
    }
    
    
    @IBAction func CamOrPicBtn(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "CameraViewController", sender: sender)
    }
    

    @IBAction func LoginOrRegisterBtn(_ sender: UIButton)
    {
        if self.changedWord.text == "登入/註冊"
        {
            self.performSegue(withIdentifier: "AcountViewController", sender: sender)
        }
        else if self.changedWord.text == "登出"
        {
            //如果當前帳戶不是空的（處於登入狀態）
            if Auth.auth().currentUser != nil
            {
                do{
                    //嘗試登出，並跳轉到成功登出頁面
                    try Auth.auth().signOut()
                    //如果未登出直接重啟app後，首頁會保持登入狀態，但按下登出後label文字不會改變，故在成功登出後需將label文字重新設定回來，即可解決重啟app按下登出卻不會改變label文字的問題
                    self.changedWord.text = "登入/註冊"
                    self.performSegue(withIdentifier: "GotoLogoutVC", sender: sender)
                    
                }catch let error as NSError{
                    
                    //後台列印錯誤（失效：此語法後台目前沒有列印錯誤，但也不影響執行！）
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    
    //使用導覽線傳遞資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //用選擇性拆封，轉型並取得要換頁頁面（destination）的實體
        if let infoVC = segue.destination as? InformationViewController
        {
            //通知第二頁，記錄第一頁
            infoVC.vc = self
        }
    }
    
}

