import UIKit

class TextFiedEdit: NSObject, UITextFieldDelegate
{
    var connecting_controller:Register!

    
    init(_ controller:Register)
    {
        connecting_controller = controller
       
    }
   
    
   
    //===============按下enter的反應===============
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let you_input:String = textField.text
        {
            //如果不滿8字
            if you_input.count < 8
            {
                var popup_controller:UIAlertController
                popup_controller = UIAlertController(
                    title: "通知",
                    message: "帳號或密碼不足8字元以上",
                    preferredStyle: UIAlertController.Style.alert
                )
                
                let button:UIAlertAction = UIAlertAction(
                    title: "確定",
                    style: UIAlertAction.Style.default,
                    handler: nil
                )
                
                popup_controller.addAction(button)
                connecting_controller.present(popup_controller, animated: true, completion: nil)
                //不能離開此行
                textField.becomeFirstResponder()
            }
            //如果滿8字
            else
            {
                textField.resignFirstResponder()
                connecting_controller.密碼.becomeFirstResponder()
            }
        }
        return true
    }
    
//    //===============要離開的反應===============
//    func textFieldDidEndEditing(_ textField: UITextField)
//    {
//        if let you_input:String = textField.text
//        {
//            //如果不滿8字
//            if you_input.count < 8
//            {
//                var popup_controller:UIAlertController
//                popup_controller = UIAlertController(
//                    title: "通知",
//                    message: "帳號或密碼不足8字元以上",
//                    preferredStyle: UIAlertController.Style.alert
//                )
//
//                let button:UIAlertAction = UIAlertAction(
//                    title: "確定",
//                    style: UIAlertAction.Style.default,
//                    handler: nil
//                )
//
//                popup_controller.addAction(button)
//                connecting_controller.present(popup_controller, animated: true, completion: nil)
//                //不能離開此行
//                textField.becomeFirstResponder()
//            }
//            //如果滿8字
//            else
//            {
//                textField.resignFirstResponder()
//                connecting_controller.密碼.becomeFirstResponder()
//            }
//        }
//    }
//
//
    //===============合法字元過濾===============
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard string.count != 0
        else
        {
            self.connecting_controller.密碼.textContentType = .oneTimeCode
            self.connecting_controller.密碼.isSecureTextEntry = true
            return true
        }
        //原型態為Character會fetal error，改為string後不會，但不知兩者互改有無差異與影響
        let user_input_char:String = String(string)
        var character_ok:Bool = false
        if user_input_char >= "A" && user_input_char <= "Z"
        {
            character_ok = true
        }
        
        else if user_input_char >= "a" && user_input_char <= "z"
        {
            character_ok = true
        }
        
        else if user_input_char >= "0" && user_input_char <= "9"
        {
            character_ok = true
        }
        
        else if user_input_char >= ":" && user_input_char <= "@"
        {
            character_ok = true
        }
        else if user_input_char == "."
        {
            character_ok = true
        }
        else if user_input_char == "\n"
        {
            character_ok = true
        }
        if character_ok
        {
       return character_ok
        }
        else
        {
            print("CHARACTER NOT LEGGEAL!!")
            var popup_controller:UIAlertController
            popup_controller = UIAlertController(
                title: "通知",
                message: "帳號或密碼內不可包含空白及特殊字元!\"#$%&'()*+,-/{}|~[]/^_`",
                preferredStyle: UIAlertController.Style.alert
            )
            
            let button:UIAlertAction = UIAlertAction(
                title: "確定",
                style: UIAlertAction.Style.default,
                handler: nil
            )
            popup_controller.addAction(button)
            connecting_controller.present(popup_controller, animated: true, completion: nil)
            return false
        }
        
       
      
    }
}
