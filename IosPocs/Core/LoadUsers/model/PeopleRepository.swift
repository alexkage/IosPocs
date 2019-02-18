//
//  PeopleRepository.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/11/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import Foundation

protocol PeopleRepository {
    func getPeople(onSuccess successCallback: ((_ people: [PeopleModel]) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?)

}

protocol UsersRepository {
    func getUsers(dataTask:UnsafeMutablePointer<URLSessionDataTask?>,completionHandler: @escaping ((_ responseState: WebServicesResponseState, _ responseObject: Any?) -> Void))
}


