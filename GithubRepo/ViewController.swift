//
//  ViewController.swift
//  GithubRepo
//
//  Created by Leonardo Mello on 11/03/22.
//

import UIKit

class ViewController: UIViewController {

override func viewDidLoad() {
super.viewDidLoad()

parseData()
}

func parseData(){

let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars"
var request = URLRequest(url: URL(string: url)!)
request.httpMethod = "GET"

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)

let task = session.dataTask(with: request) { (data ,response , error) in

if (error != nil) {
print("Error")
} else {

do {
let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)

if let fetchedData = fetchedData as? Dictionary<String, AnyObject>, let repo = fetchedData["items"] as? [Any] {
    
        for eachFetchedRepositorio in repo {
            
            //pegando o owner
            if let eachFetchedRepositorio = eachFetchedRepositorio as? AnyObject, let owner = eachFetchedRepositorio["owner"] as? NSDictionary {
    
                let nome_owner = owner["login"] as! String
                let foto_owner = owner["avatar_url"] as! String
                print(nome_owner)
                print(foto_owner)
                
            }
            //fim do owner
            
        let eachRepositorio = eachFetchedRepositorio as! [String : Any]
            
        let nome_repo = eachRepositorio["name"] as! String
        let qntd_estrelas = eachRepositorio["stargazers_count"] as! Int
            
            print(nome_repo)
            print(qntd_estrelas)
            print(" ")
        }
    
    
}

} catch {
print("Error 2")
}
}

}

task.resume()
}


}
