import UIKit

class DevelopeTableViewController: UITableViewController
{
    
    //接收第一頁的執行實體
    //weak var viewVC:ViewController?
    
    //MARK: - 滑動手勢
  
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var list = [
         ("羅煒棠", "納美人"),
         ("江世中", "鋼鐵人"),
         ("彭方谷", "腳踏車達人")
          ]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //設定導覽列標題
        self.navigationItem.title = "開發人員"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    //MARK: - Table View Delegate
    //提供每一段每一列的儲存格樣式
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //print("詢問第\(indexPath.section)段，第\(indexPath.row)列的儲存格")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
    
        //宣告儲存格內容設定的物件
        var content = cell.defaultContentConfiguration()
        //逐一設定儲存格物件的內容
        content.text = list[indexPath.row].0
        content.secondaryText = list[indexPath.row].1
        //將儲存格物件設定給儲存格
        cell.contentConfiguration = content
        
        return cell
    }

}
