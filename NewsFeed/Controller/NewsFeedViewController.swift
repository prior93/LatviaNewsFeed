//
//  ViewController.swift
//  NewsFeed
//
//  Created by parashar.r.adhikary on 12/02/2021.
//

import UIKit
import Gloss

class NewsFeedViewController: UIViewController {

    var  items:[Item] = []
    
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Latvia News Today"
        tableView.isHidden = false
    }

    @IBAction func getDataTapped(_ sender: Any) {
        
        handleGetData()
    }
    
    
    func handleGetData(){
        
        let jsonUrl = "http://newsapi.org/v2/top-headlines?country=lv&apiKey=2d1545dfd94e4a2c9de969541c46ddf3"
        
        guard let url = URL(string: jsonUrl) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) { (data , response, error) in
            
            if let err = error {
                print("error: \(err.localizedDescription)")
            }
            
            guard let data = data else {
                print("Data error!!!!")
                return
            }
            
            do{
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("dictData", dictData)
                    self.populateData(dictData)
                }
                
            }catch{
                print("err when converting JSON")
            }
            
            
        }
        task.resume()
    }
    
    func populateData(_ dict: [String: Any]){
        guard let responseDict = dict["articles"] as? [Gloss.JSON] else {
            return
        }
        
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
}

extension NewsFeedViewController :UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = items[indexPath.row].description
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DetailViewController") as? DetailViewController{
            vc.contentString = items[indexPath.row].description
            vc.titleString = items[indexPath.row].title
            vc.webURLString = items[indexPath.row].url
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

