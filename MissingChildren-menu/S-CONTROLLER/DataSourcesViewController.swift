import WebKit

class DataSourcesViewController: UIViewController
{

    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.missingkids.org.tw/")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        //設定導覽列標題
        self.navigationItem.title = "資料來源"
    }
    


}
