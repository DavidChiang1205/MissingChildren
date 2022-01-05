import UIKit
import WebKit

class MessageViewController: UIViewController
{

    @IBOutlet weak var WKWebView: WKWebView!
    
  
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url = URL(string: "https://www.missingkids.org.tw/chinese/gbook.php?mode=add")
        let request = URLRequest(url: url!)
        WKWebView.load(request)
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
