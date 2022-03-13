//
//  ViewController.swift
//  GithubRepo
//
//  Created by Leonardo Mello on 11/03/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

@IBOutlet weak var repoTableView: UITableView!

var fetchedRepo = [Repositorio]()
    
override func viewDidLoad() {
super.viewDidLoad()

repoTableView.dataSource = self
repoTableView.tableFooterView = UIView()

let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
view.addGestureRecognizer(tap)

// initializing the refreshControl
repoTableView.refreshControl = UIRefreshControl()
// add target to UIRefreshControl
repoTableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)

parseData()
searchBar()

}


override var prefersStatusBarHidden: Bool {
return true
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText == ""{
        parseData()
    } else {
        if searchBar.selectedScopeButtonIndex == 0 {
            
            fetchedRepo = fetchedRepo.filter({ (repositorio) in
                return repositorio.name.lowercased().contains(searchText.lowercased())
            })
        }

        repoTableView.reloadData()
    };
    repoTableView.reloadData()
}


func searchBar(){
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
    searchBar.delegate = self
    searchBar.showsScopeBar = true
    searchBar.tintColor = UIColor.lightGray
    searchBar.placeholder = "Search Repo"
    self.repoTableView.tableHeaderView = searchBar
}



func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return fetchedRepo.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cell = repoTableView.dequeueReusableCell(withIdentifier: "cell") as! RepositorioTableViewCell

let repositorio = fetchedRepo[indexPath.row]


cell.nome_autor?.text = repositorio.login
cell.nome_repositorio?.text = repositorio.name
cell.quantidade_estrelas?.text = NumberFormatter().string(from: NSNumber(value: repositorio.stargazers_count))
cell.foto_autor.loadFrom(URLAddress: repositorio.avatar_url)

return cell

}

func parseData(){

fetchedRepo = [Repositorio]()

let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars"
var request = URLRequest(url: URL(string: url)!)
request.httpMethod = "GET"

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)

let task = session.dataTask(with: request) { [self] (data ,response , error) in

if (error != nil) {
print("Error")
} else {

do {
let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
var nome_owner: String
var foto_owner: String
var nome_repo: String
var qntd_estrelas: Int

if let fetchedData = fetchedData as? Dictionary<String, AnyObject>, let repo = fetchedData["items"] as? [Any] {

for eachFetchedRepositorio in repo {

//pegando o owner
if let eachFetchedRepositorio = eachFetchedRepositorio as? AnyObject, let owner = eachFetchedRepositorio["owner"] as? NSDictionary {

nome_owner = owner["login"] as! String
foto_owner = owner["avatar_url"] as! String
//fim do owner

let eachRepositorio = eachFetchedRepositorio as! [String : Any]

nome_repo = eachRepositorio["name"] as! String
qntd_estrelas = eachRepositorio["stargazers_count"] as! Int

self.fetchedRepo.append(Repositorio(name: nome_repo, login: nome_owner, avatar_url: foto_owner, stargazers_count: qntd_estrelas))

}

self.repoTableView.reloadData()
}

}

} catch {
print("Error 2")
}
DispatchQueue.main.asyncAfter(deadline: .now() + 3){
               self.repoTableView.refreshControl?.endRefreshing()
               self.repoTableView.reloadData()
           }
}

}

task.resume()
}

@objc func callPullToRefresh(){
        self.parseData()
    }

@objc func dismissKeyboard() {
    view.endEditing(true)
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

class RepositorioTableViewCell: UITableViewCell {

@IBOutlet weak var foto_autor: UIImageView!

@IBOutlet weak var nome_repositorio: UILabel!

@IBOutlet weak var quantidade_estrelas: UILabel!

@IBOutlet weak var nome_autor: UILabel!

}


extension UIImageView {
func loadFrom(URLAddress: String) {
guard let url = URL(string: URLAddress) else {
return
}

DispatchQueue.main.async { [weak self] in
if let imageData = try? Data(contentsOf: url) {
    if let loadedImage = UIImage(data: imageData) {
            self?.image = loadedImage
    }
}
}
}
}

