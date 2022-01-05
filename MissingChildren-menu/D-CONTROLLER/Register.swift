import UIKit
import Firebase
import FirebaseAuth

class Register: UIViewController
{
    @IBOutlet weak var 帳號: UITextField!
    @IBOutlet weak var 密碼: UITextField!
    
    var my_TF_delegator:TextFiedEdit!
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        my_TF_delegator = TextFiedEdit(self)
        帳號.delegate = my_TF_delegator
        密碼.delegate = my_TF_delegator
    }
    
    //MARK: - 點擊空白處收起鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        print("點擊空白處收起鍵盤")
    }
    
    
    //MARK: - return收起鍵盤
    @IBAction func Did_End_On_Exit(_ sender: UITextField)
    {
        print("return收起鍵盤")
    }
    
    
    //MARK: - 提交
    @IBAction func 提交(_ sender: UIButton)
    {
        if 帳號.text == ""
        {
            self.alertView(title: "通知", message: "請輸入電子郵件和密碼！")
        }
        else if self.密碼.text!.count >= 8
        {
            Auth.auth().createUser(withEmail: self.帳號.text!, password: self.密碼.text!) {
                user, error
                in
                if error == nil
                {
                    print("註冊成功！")
                    
                    var popup_controller:UIAlertController
                    popup_controller = UIAlertController(
                        title: "通知",
                        message: "註冊成功！",
                        preferredStyle: UIAlertController.Style.alert
                    )
                    
                    let button:UIAlertAction = UIAlertAction(
                        title: "確定",
                        style: UIAlertAction.Style.default,
                        handler:
                            {
                                (UIAlertAction)->Void
                                in
                                //因註冊成功後直接關掉app，currentUser會持續存在，重啟app還不用登入，首頁就會顯示維持已登入狀態，故註冊成功後需做登出動作再回到上一頁，關掉app重啟後，此狀況就可解決
                                if Auth.auth().currentUser != nil
                                {
                                    do{
                                        //嘗試登出，並跳轉頁面
                                        try Auth.auth().signOut()
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    }catch let error as NSError{
                                        
                                        //後台列印錯誤（失效：此語法後台目前沒有列印錯誤，但也不影響執行！）
                                        print(error.localizedDescription)
                                        
                                    }
                                }
                            }
                    )
                    popup_controller.addAction(button)
                    self.present(popup_controller, animated: true, completion: nil)
                   
                }
                else
                {
                    print("執行第一")
                    self.alertView(title: "通知", message: "電子郵件格式不符，或密碼不足8字元以上！")
                }
            }
        }
        else
        {
            print("執行第二")
            self.alertView(title: "通知", message: "電子郵件格式不符，或密碼不足8字元以上！")
        }
    }
    
    
    //MARK: - 重設
    @IBAction func 重設(_ sender: UIButton)
    {
        self.帳號.text = ""
        self.密碼.text = ""
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
