import UIKit
import SQLite3


class filterViewController: UIViewController
{
    //MARK: - 陣列分別存 Picker View 的資料
    
    let gender = ["-空白-","男生","女生"]
    let age = [
        "-空白-","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"]
    let place = ["-空白-","台北市信義區","台北市士林區","新北市板橋區","新北市汐止區","台南市南化區","高雄市大寮區","高雄市三民區","百慕達三角洲","聖母峰","麥田圈"]
    
    
    //宣告資料庫連線指標
    var db:OpaquePointer?
    //記錄單一資料行
    var structRow = MissingPerson()
    //宣告失蹤人口陣列，存放從資料庫查詢到的資料（此陣列即『離線資料集』）
    var arrTable = [MissingPerson]()
    
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var placeTextField: UITextField!
    
    
    @IBAction func filterTable(_ sender: UIButton)
    {
       
    }
    
    var genderPickerView = UIPickerView()
    var agePickerView = UIPickerView()
    var nAgePickerView = UIPickerView()
    var placePickerView = UIPickerView()
    
    
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - 讓 Text Field 的輸入方式改為 Picker View。
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        agePickerView.dataSource = self
        agePickerView.delegate = self
        
        placePickerView.dataSource = self
        placePickerView.delegate = self
        
        
        
        genderTextField.inputView = genderPickerView
        ageTextField.inputView = agePickerView
        placeTextField.inputView = placePickerView
        
    }
    
    //MARK: - 觸摸其它地方關閉編輯
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    
}

//MARK: - Picker View 的三階段對話函數，以及選擇後填入對應 Text Field
extension filterViewController: UIPickerViewDataSource, UIPickerViewDelegate
{
    //詢問滾論有幾段
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    //每一段滾輪有幾行物件
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == genderPickerView
        {
            return gender.count
        }
        if pickerView == agePickerView
        {
            return age.count
        }
        if pickerView == placePickerView
        {
            return place.count
        }
       
        return 0
        
    }
    
    //詢問每一段每一列要呈現的文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == genderPickerView
        {
            return gender[row]
        }
        if pickerView == agePickerView
        {
            return age[row]
        }
        if pickerView == placePickerView
        {
            return place[row]
        }
      
        return nil
    }

    //pickerView被選定時，替換物件文字
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == genderPickerView
        {
            genderTextField.text = gender[row]
        }
        if pickerView == agePickerView
        {
            ageTextField.text = age[row]
        }
        if pickerView == placePickerView
        {
            placeTextField.text = place[row]
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let DataVC = segue.destination as? DataTableViewController
            {
            DataVC.filter_Gender = genderTextField.text!
            DataVC.filterAge = ageTextField.text!
            DataVC.filterPlace = placeTextField.text!
            }

    }
}

