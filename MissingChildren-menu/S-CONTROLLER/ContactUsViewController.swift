import WebKit

class ContactUsViewController: UIViewController
{

    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let url = URL(string: "https://thmr.wda.gov.tw/cp.aspx?n=EA49F59ED5EDCFE9")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        //設定導覽列標題
        self.navigationItem.title = "聯絡我們"
    }
    


}
