import UIKit

class WelcomeViewController: UIViewController
{

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func back_To_Home_Page(_ sender: UIButton)
    {
       
        //從storyboard取得下一頁的執行實體
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as? ViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
   
}
