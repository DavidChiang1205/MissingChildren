import UIKit
import PhotosUI     //引入iOS15之後使用的相簿UI框架


class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate
{

    @IBOutlet weak var camOrPicImg: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //MARK: - PHPicker（iOS15之後的相簿取用方法）
        //=================================設定挑選相簿時使用的組態=================================
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = PHPickerFilter.images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        
        let phpicker = PHPickerViewController(configuration: configuration)
        phpicker.delegate = self
        //======================================================================================
        
        
        //MARK: - UIImagePicker（取用相機方法）
        //===================================設定開啟相機時的組態===================================
        //檢查是否有相機
        guard UIImagePickerController.isSourceTypeAvailable(.camera)
        else
        {
            print("無法使用相機")
            return  //直接離開
        }
        //如果可以使用相機，即產生影像挑選控制器
        let imagePicker = UIImagePickerController()
        //將imagePicker相關的代理方法實作在此類別
        imagePicker.delegate = self
        //======================================================================================
        
        
        //彈出視窗
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //========================================我是相機========================================
        //添加彈出相機視窗選項反應
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: {
            action
            in
            //將影像挑選控制器呈現為相機
            imagePicker.sourceType = .camera
            //開啟拍照介面（使用UIImagePicker）
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        //========================================我是相簿========================================
        //添加彈出相簿視窗選項反應
        alert.addAction(UIAlertAction(title: "從相簿選取照片", style: .default, handler: {
            action
            in
            //開啟拍相簿（使用PHPicker）
            self.present(phpicker, animated: true, completion: nil)
        }))
        
        //========================================我是取消========================================
        let alertCancel = UIAlertAction(title: "取消", style: .default) {
            (UIAlertAction) -> Void
            in
            //按下按鈕後回到家目錄
            self.navigationController?.popViewController(animated: false)
        }
        //添加視窗反應
        alert.addAction(alertCancel)
        //呈現彈出視窗畫面
        self.present(alert, animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("info:\(info)")
        //從Info字典中取得相機拍到的照片
        let image = info[.originalImage] as! UIImage
        //將取得的照片直接套在imageView上
        self.camOrPicImg.image = image
        //存完照片退掉相機或相簿
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    
    //MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        //退出相機（放在開頭，取消才會作用）
        picker.dismiss(animated: true, completion: nil)
        
        if let itemProvider = results.first?.itemProvider
        {
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
            {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) {
                    data, error
                    in
                    //如果沒有取得照片資料就離開
                    guard let PicData = data
                    else
                    {
                        return
                    }
                    DispatchQueue.main.async {
                        self.camOrPicImg.image = UIImage(data: PicData)
                    }
                }
            }
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    

}
