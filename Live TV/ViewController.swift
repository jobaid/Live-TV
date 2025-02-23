

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
     
    var refreshControl: UIRefreshControl!
    var arrRes = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the refresh control
        tblView.dataSource = self
        tblView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tblView.addSubview(refreshControl) // Adding refresh control to table view
        
        // Fetch data initially
        getData()
    }

    // Table view delegate and data source methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jcell")!
        let dict = arrRes[indexPath.row]
        
        if let textLabel = cell.viewWithTag(9) as? UILabel {
            textLabel.text = dict["n"] as? String
        }
        
        if let imageView = cell.viewWithTag(10) as? UIImageView, let imageURLString = dict["i"] as? String, let url = URL(string: imageURLString) {
            imageView.af.setImage(withURL: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
   // Player View
  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if segue.identifier == "id", let indexPath = self.tblView.indexPathForSelectedRow //{
          //  let controller = segue.destination as! PlayerViewController
            //let value = arrRes[indexPath.row]
            //controller.ID = value["link"] as! String
       // }
    //}

    // Fetch data from the API
    func getData() {
       var apis = "https://movies-c9ff5.firebaseio.com/.json"
        AF.request(apis).responseJSON { responseData in
            switch responseData.result {
            case .success(let value):
                let swiftyJsonVar = JSON(value)
                
                if let resData = swiftyJsonVar["animation"].arrayObject {
                    self.arrRes = resData as! [[String: AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    self.tblView.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    //Sending Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "id" {
            
            if let indexPath = self.tblView.indexPathForSelectedRow {
                let controller = segue.destination as! Trends
                let value = arrRes[indexPath.row]
                controller.ID = value["videoId"] as? String
                controller.cat = value["n"] as? String
            }
            
            
        }
        
    }

    // Refresh control action
    @objc func refresh(sender: AnyObject) {
        getData()
        
        // End refresh control animation after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }
    
    // Show alert if no internet connection
    func showEventsAccessDeniedAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please Connect Your Mobile Data or WIFI Connection", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
