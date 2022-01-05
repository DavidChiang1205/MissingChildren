
import UIKit

class VersionViewController: UIViewController
{

    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //設定導覽列標題
        self.navigationItem.title = "版本資訊"
    }
    
}
