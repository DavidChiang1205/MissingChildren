import UIKit


class LogoutViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    @IBAction func back_To_Home_Page(_ sender: UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    

}
