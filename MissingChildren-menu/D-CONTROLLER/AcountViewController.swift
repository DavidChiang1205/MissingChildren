import UIKit
import Firebase
import FirebaseAuth

class AcountViewController: UIViewController
{
    @IBOutlet weak var 帳號: UITextField!
    @IBOutlet weak var 密碼: UITextField!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Touch Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        print("點擊空白處收起鍵盤")
    }
    
    //MARK: - Swipe Back
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - return收起鍵盤
    @IBAction func Did_End_On_Exit(_ sender: UITextField)
    {
        print("return收起鍵盤")
    }
    
    //MARK: - 登入
    @IBAction func 登入(_ sender: UIButton)
    {
        //如果帳號和密碼為空
        if self.帳號.text == "" || self.密碼.text == ""
        {
            alertView(title: "通知", message: "請輸入電子郵件和密碼！")
        }
        //其餘狀況
        else
        {
            //呼叫firebase登入驗證方法
            Auth.auth().signIn(withEmail: self.帳號.text!, password: self.密碼.text!) {
                user, error
                in
                //如果沒有錯
                if error == nil
                {
                    print("成功登入！")
                    self.performSegue(withIdentifier: "WelcomeViewController", sender: sender)
                }
                //其餘狀況
                else
                {
                    self.alertView(title: "通知", message: "帳號或密碼有誤！或尚未註冊帳號！")
                    self.帳號.text = ""
                    self.密碼.text = ""
                }
            }
        }
    }
    
    //MARK: - 重設
    @IBAction func 重設(_ sender: UIButton)
    {
        self.帳號.text = ""
        self.密碼.text = ""
    }
    
    //MARK: - 申請
    @IBAction func 申請(_ sender: UIButton)
    {
        performSegue(withIdentifier: "Register", sender: sender)
    }
    
    
    //MARK: - 訪客登入
    @IBAction func guest_Login(_ sender: UIButton)
    {
       self.帳號.text! = "guest@gmail.com"
       self.密碼.text! = "12345678"
        
        //如果帳號和密碼為空
        if self.帳號.text == "" || self.密碼.text == ""
        {
            alertView(title: "通知", message: "請輸入電子郵件和密碼！")
        }
        //其餘狀況
        else
        {
            //呼叫firebase登入驗證方法
            Auth.auth().signIn(withEmail: self.帳號.text!, password: self.密碼.text!) {
                user, error
                in
                //如果沒有錯
                if error == nil
                {
                    print("成功登入！")
                    self.performSegue(withIdentifier: "WelcomeViewController", sender: sender)
                }
                //其餘狀況
                else
                {
                    self.alertView(title: "通知", message: "帳號或密碼有誤！或尚未註冊帳號！")
                }
            }
        }
    }
    
    
    
    //MARK: - Function Area
    private func alertView(title:String, message:String)
    {
        var popup_controller:UIAlertController
        popup_controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let button:UIAlertAction = UIAlertAction(
            title: "確定",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        
        popup_controller.addAction(button)
        self.present(popup_controller, animated: true, completion: nil)
    }
}
