import UIKit

class CoreImageViewController: UIViewController
{
    
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        var popup_controller:UIAlertController
        popup_controller = UIAlertController(
            title: "尚未開啟此服務",
            message: "欲使用此服務，請至櫃檯繳費。",
            preferredStyle:UIAlertController.Style.alert)
        
        let button:UIAlertAction = UIAlertAction(
            title: "確定",
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
        
        // Do any additional setup after loading the view.
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
