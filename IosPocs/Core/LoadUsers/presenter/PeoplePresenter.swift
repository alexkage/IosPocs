//
//  PeoplePresenter.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import Foundation

struct PeopleViewData{
    let name: String
    let email: String
}

protocol PeopleView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setPeople(people: [PeopleViewData])
    func setEmptyPeople()
}

class PeoplePresenter {
//    private let peopleService:PeopleService
    weak private var peopleView : PeopleView?
    let peopleRepo:PeopleRepository?
    
    init(peopleRepo:PeopleRepository){
        self.peopleRepo = peopleRepo
    }
    
    
    func attachView(view:PeopleView){
        peopleView = view
    }
    
    func detachView() {
        peopleView = nil
    }
    
    func getPeople(){
        self.peopleView?.startLoading()
        self.peopleRepo?.getPeople(
            onSuccess: { (people) in
                self.peopleView?.finishLoading()
                if (people.count == 0){
                    self.peopleView?.setEmptyPeople()
                } else {
                    let mappedUsers = people.map {
                        return PeopleViewData(name: "\($0.name!)", email: "\($0.email!)")
                    }
                    self.peopleView?.setPeople(people: mappedUsers)
                }
        }, onFailure: { (errorMessage) in
            self.peopleView?.finishLoading()
        })
        
        

    }
}
