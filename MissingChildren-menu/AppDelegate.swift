import UIKit
import SQLite3
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITextFieldDelegate
{
    //firebase設定
    var window: UIWindow?
    
    //宣告資料庫連線指標
    private var db:OpaquePointer?
    
    //提供其他頁面取得資料庫連線的方法
    func getDB() -> OpaquePointer
    {
        return db!
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        //取得應用程式正在使用的檔案管理員
        let filemanager = FileManager.default
        //取得資料庫檔案
        let sourceDB = Bundle.main.path(forResource: "ProjectData", ofType: "db3")!
        
        print("資料庫來源路徑:\(sourceDB)")
        print("App的家目錄:\(NSHomeDirectory())")
        
        //定義資料庫存放的目的地路徑在app的家目錄的Documents資料夾中，重新命名為mydb.db3
        let destinationDB = NSHomeDirectory() + "/Documents/mydb.db3"
        //當目的地資料庫檔案“不存在”時
        if !filemanager.fileExists(atPath: destinationDB)
        {
            //從來源資料庫將檔案複製進目的地資料庫
            try! filemanager.copyItem(atPath: sourceDB, toPath: destinationDB)
            print("OH!no")
        }
        
        //開啟資料庫連線，並且存入db所在的記憶體位置
        if sqlite3_open(destinationDB, &db) == SQLITE_OK
        {
            print("資料庫連線成功")
        }
        else
        {
            print("資料庫連線失敗")
        }
        
        //firebase設定
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        print("app終止")
        //關閉資料庫連線
        sqlite3_close_v2(db)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
   

}

