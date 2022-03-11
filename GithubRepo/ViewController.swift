//
//  ViewController.swift
//  GithubRepo
//
//  Created by Leonardo Mello on 11/03/22.
//

import UIKit

class ViewController: UIViewController {

var fetchedNome = [Repositorio]()


override func viewDidLoad() {
super.viewDidLoad()

parseData()
}

func parseData(){

fetchedNome = [Repositorio]()

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
                let eachRepositorio = eachFetchedRepositorio as! [String : Any]
                    
                    //pegando o owner
                    
                    //fim do owner
        
                    
                    
                    let nome_autor = eachRepositorio["name"] as! String
                    let qntd_estrelas = eachRepositorio["stargazers_count"] as! Int
                    
                    print(nome_autor)
                    print(qntd_estrelas)
                }
            
            
        }
    
//            print(fetchedData)
        
    } catch {
        print("Error 2")
    }
}

}

task.resume()
}


}


class Repositorio {

var name : String
var login: String
var avatar_url: String
var stargazers_count: Int

init(name: String, login: String, avatar_url: String, stargazers_count: Int){
self.name = name
self.login = login
self.avatar_url = avatar_url
self.stargazers_count = stargazers_count
}

}


//class Ob {
//
//var items = [Repositorio]()
//
//init(items: [Repositorio]){
//    self.items = items
//}
//}
