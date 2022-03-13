//
//  UITableViewCell.swift
//  GithubRepo
//
//  Created by Leonardo Mello on 13/03/22.
//

import Foundation

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
