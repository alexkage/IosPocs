//
//  PeopleService.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import Foundation

class PeopleService: PeopleRepository {
    
    func getPeople(onSuccess successCallback: (([PeopleModel]) -> Void)?, onFailure failureCallback: ((String) -> Void)?) {
        ApiCallManager.callAPIGetPeople(onSuccess: {
            (people) in
            successCallback?(people)
        }, onFailure: {(errorMessage) in
            failureCallback?(errorMessage)
           })
      }

}
