//
//  WebServicesManager.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/13/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import Foundation


/*************************************** VERSIONAMIENTO ***************************************/
//  Versión 2.1.1:
//  1. Se corrigió problema que no permitía consumir el servicio web con método "POST" cuando los parámetros era `nil`.
//
//  Versión 2.1.0:
//  1. Se modificó la implementación de los métodos para consumir los servicios web, de modo que soporten el caso en el que el "token" de inicio de sesión haya expirado.
//  Para hacer eso, se cambia la propiedad "state" de la respuesta parseada en función "status code" (403) de la respuesta del servidor.
//  2. Se agregó la propiedad saveLoginTokenIfFound para que el programador le delegue al WebServicesManager que guarde automaticamente el "token" de inicio de sesión en el servicio web correcto.
//  3. Se agregó el método saveLoginTokenFromHeaders: para guardar el "token" de inicio de sesión si la propiedad saveLoginTokenIfFound tiene el valor "true".
//
//  Versión 2.0.0:
//  1. Se hicieron los cambios para que soporte Swift 3.0.
//
//  Versión 1.3.0:
//  1. Se cambió el uso del OSPKeychain por NSUserDefaults para guardar el token de inicio de sesión.
//  2. Se agregó el método putWithURL:parameters:uploadTask:completionHandler: para el consumo de servicios web usando el método "PUT".
//
//  Versión 1.2.0:
//  1. Se creó el tipo de dato WebServicesErrorMessage, cuyos valores representan a los mensajes de error del servicio web.
//  2. Se agregó la propiedad "headers" a la clase WebServicesResponse, para tener una referencia a las cabeceras de la petición.
//
//  Versión 1.1.0:
//  1. Se creó el método formDataWithParameters:, que permite convertir los parámetros ubicados en un diccionario en un objeto binario para enviarlos vía form-data.
//  2. Se creó el tipo de dato WebServicesContentType, cuyos valores describen la naturaleza de los parámetros que se van a enviar en el cuerpo de la petición.
//  3. Se expone una variable del tipo WebServicesContentType y se agregó lógica que permite hacer la conversión de los parámetros en función a su valor al usar POST.
//
//  Versión 1.0.0:
//  1. Se crearon los métodos getWithURL:parameters:dataTask:completionHandler: y postWithURL:parameters:uploadTask:completionHandler: para el consumo de servicios web.
//  2. Se creó la clase WebServicesResponse, cuyas instancias representa a la respuesta del servicio web.
//  3. Se creó el tipo de dato WebServicesResponseState, cuyos valores representan a los estados de la respuesta del servicio web.
/**********************************************************************************************/



import UIKit

// MARK: - Enums

/**
 Tipo de dato que representa el estado para la respuesta del servicio web.
 Las constantes son:
 - success: Constante que representa el éxito en la respuesta del servicio web. Solo para este estado es que se hace el parseo necesario de la respuesta. En caso contrario, esta clase determina el tipo de estado y su respectivo mensaje.
 - failure: Constante que representa cualquier error que pudo ocurrir antes, durante o después del consumo de los servicios web.
 - cancelled: Constante que indica que se canceló el consumo de los servicios web.
 - timeout: Constante que indica que se excedió el tiempo de espera para el consumo de los servicios web.
 */
internal enum WebServicesResponseState: Int {
    /// El éxito en la respuesta del servicio web.
    case success = 0
    /// Cualquier error que pudo ocurrir antes, durante o después del consumo de los servicios web.
    case failure
    /// Se canceló el consumo de los servicios web.
    case cancelled
    /// Se excedió el tiempo de espera para el consumo de los servicios web.
    case timeout
    /// El token de inicio de sesión ha expirado.
    case tokenBlacklisted
}

/**
 Tipo de dato que representa a la naturaleza de los parámetros enviados en el cuerpo de la petición.
 Las constantes son:
 - None: Constante que indica que no se especifica cómo se envían los parámetros.
 - FormData: Constante que indica que los parámetros serán enviados vía form-data.
 - Raw: Constante que indica que los parámetros serán enviados vía raw.
 */
internal enum WebServicesContentType: String {
    /// No se especifica cómo se envían los parámetros.
    case None = ""
    /// Parámetros enviados vía form-data.
    case FormData = "multipart/form-data"
    /// Parámetros enviados vía raw.
    case Raw = "application/json"
}

/**
 Tipo de dato que representa a los posibles mensajes de error que se manejan directamente del servidor.
 Las constantes son:
 - General: El mensaje de error general. Este mensaje aparecerá cuando hay un error en el servidor.
 - Timeout: El mensaje de error que aparecerá cuando se terminé el tiempo de espera. El tiempo está definido por la propiedad `timeoutInterval`.
 */
private enum WebServicesErrorMessage: String {
    /// El mensaje de error general.
    case General = "Lo sentimos, ocurrió un error.\nPor favor, comuníquese con el proveedor"
    /// El mensaje de error por tiempo de espera.
    case Timeout = "Se terminó el tiempo de espera"
}


// MARK: - WebServicesManager classes

/**
 Clase que representa a la respuesta del servicio web.
 Todos los métodos para consumir servicios web de la clase `WebServicesManager` retornan un objeto de este tipo.
 Como mínimo, para que una instancia de esta clase sea válida para continuar con la operación, el valor de la variable `error` deberá ser `nil`; y el valor de `response`, diferente de `nil`.
 */
internal class WebServicesResponse: NSObject {
    
    // MARK: Properties
    
    /// La respuesta del servicio web en formato JSON.
    /// - Note: La respuesta puede ser un `Array`, `Dictionary` o `nil` si ocurrió un error.
    internal var response: Any? = nil
    
    /// La respuesta del servicio web en binario.
    /// - Note: El parseo de este objeto resulta en el valor para la variable `response`. `nil` si ocurrió un error en el servicio web.
    internal var data: Data? = nil
    
    /// El estado de la respuesta.
    internal var state: WebServicesResponseState = WebServicesResponseState.success
    
    /// El mensaje relacionado al estado de la respuesta.
    /// - Note: Este valor es `nil` para los estados `Success` y `Cancelled`.
    internal var message: String?
    
    /// El código HTTP de estado de la respuesta.
    internal var statusCode: Int = 0
    
    /// La cabecera de la respuesta.
    internal var headers: [String: Any]?
}

/**
 Clase que maneja la conexión entre la aplicación y los servicios web.
 Esta clase expone métodos que permiten consumir servicios web en POST, GET y PUT. Además, expone propiedades para manejar las credenciales de autorización, si es necesario, y de tiempo de espera.
 */
@objc internal class WebServicesManager: NSObject {
    
    // MARK: Properties
    
    /// La naturaleza de los datos envíados como parámetros en el cuerpo de la petición.
    /// - Note: El valor por defecto no especifica la naturaleza de los datos.
    internal static var contentType: WebServicesContentType = WebServicesContentType.None
    
    /// Variable que permite saber si el consumo de los servicios web necesitan autorización.
    /// - Note: El valor por defecto de la autorización es `false`.
    internal static var needsAuthorization = false
    
    /// Variable que permite saber si se desea guardar el "token" de inicio de sesión automaticamente.
    /// - Note: El valor por defecto de esta variable es `false`.
    internal static var saveLoginTokenIfFound = false
    
    /// El tiempo máximo de espera para el consumo de los servicios web en segundos.
    /// - Note: El valor por defecto del tiempo de espera es de 60 segundos.
    internal static var timeoutInterval = 40.0
    
    /// El nombre de usuario para la authorizacíon del consumo de los servicios web.
    internal static var user = "user"
    
    /// El contraseña para la authorizacíon del consumo de los servicios web.
    internal static var password = "password"
    
    /// El nombre para obtener el "token" de inicio de sesión desde el `NSUserDefaults`.
    @objc internal static var loginTokenKey = "WebServicesManagerLoginTokenKey"
    
    
    
    
    
    // MARK: - My own methods
    
    /**
     Método encargado de crear el "header" de la petición con credenciales o sin ellas.
     - Returns: El "header" de la petición.
     */
    private class func additionalHeaders() -> [String: Any]? {
        var headers = [String: Any]()
        
        /*
         Recordar que el valor del Content-Type va a depender en cómo se van a enviar los datos.
         Para mayor detalle, ver los comentarios del tipo de dato WebServicesContentType más arriba.
         */
        if self.contentType != .None { /* Si no se especifica cómo se envían los datos, entonces no se agrega el Content-Type a los headers adicionales. */
            headers["Content-Type"] = self.contentType.rawValue as Any?
        }
        
        if self.needsAuthorization == true { /* Si el consumo de los servicios web necesita autorización... */
            var authorization: String?
            
            if let token = UserDefaults.standard.object(forKey: self.loginTokenKey) as? String {
                //print("\(self) - \(#function) / Token: \(UserDefaults.standard.object(forKey: self.loginTokenKey))")
                authorization = "Bearer \(token)"
            }
            else if let credentialData = "\(self.user):\(self.password)".data(using: String.Encoding.utf8) {
                let credentials = credentialData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                authorization = "Basic \(credentials)"
            }
            else {
                print("\(self) - \(#function) / Error al intentar crear las credenciales para consumir los servicios web.")
            }
            
            headers["Authorization"] = authorization as Any?
        }
        
        return headers
    }
    
    /**
     Método encargado de guardar el "token" de sesión del usuario si la configuración lo permite.
     En caso no haya "token" de sesión, el método no ejecuta código.
     - Parameters headers:
     */
    private class func saveLoginTokenFromHeaders(_ headers: [String: Any]) -> Bool {
        let userDefaults = UserDefaults.standard
        let headerToken = headers["_token"] as? String
        userDefaults.set(headerToken, forKey: self.loginTokenKey)
        let headerTokenSaved = userDefaults.synchronize()
        
        return headerTokenSaved
    }
    
    /**
     Método que permite obtener un objeto `NSData` con los parámetros enviados. Este método es útil para enviar parámetros usando método "POST" y cuando el servidor espera recibirlos en "form-data".
     - Parameter parameters: Los parámetros enviados. Si los parámetros no están en un diccionario, entonces no se puede hacer la conversión.
     - Returns: El objeto `NSData` con los parámetros enviados o `nil` si no están en un diccionario.
     */
    private class func formDataWithParameters(_ parameters: Any) -> Data? {
        var formData: Data? = nil
        if parameters as? [String: Any] != nil {
            let parametersToParse = parameters as! [String: Any]
            var arrayWithParameters = [String]()
            for (key, value) in parametersToParse {
                arrayWithParameters.append("\(key)=\(value)")
            }
            
            let stringWithParameters = arrayWithParameters.joined(separator: "&")
            formData = stringWithParameters.data(using: String.Encoding.utf8)
        }
        
        return formData
    }
    
    /**
     Método que permite convertir el código de un error `NSError` de los servicios web en una tupla cuyos valores son el estado y su respectivo mensaje si es necesario.
     - Parameter error: El error del servicio web o `nil` si no hubo.
     - Returns: Una tupla cuyos valores son: la constante del tipo `WebServicesResponseState` y el respectivo mensaje si es necesario. Las posibles constantes de retorno son `Success` (valor por defecto), `Failure`, `Cancelled`, `Timeout`. Solo para el caso `Success` y `Cancelled` no habrá mensaje.
     */
    private class func webServicesResponseStateAndMessageForError(_ error: Error?) -> (WebServicesResponseState, String?) {
        var stateAndMessage: (state: WebServicesResponseState, message: String?) = (.success , nil) // Por defecto, el estado es exitoso y no hay mensaje.
        if let error = error as? NSError {
            print("\(self) - \(#function) / Error: \(error)")
            
            switch error.code {
            case -999 : stateAndMessage.state = WebServicesResponseState.cancelled; stateAndMessage.message = nil
            case -1001: stateAndMessage.state = WebServicesResponseState.timeout; stateAndMessage.message = WebServicesErrorMessage.Timeout.rawValue
            default: stateAndMessage.state = WebServicesResponseState.failure; stateAndMessage.message = WebServicesErrorMessage.General.rawValue
            }
        }
        return stateAndMessage
    }
    
    
    
    
    
    // MARK: - WebServicesManager's methods
    
    /**
     Método que se encarga de consumir un servicio de tipo POST. Este método recibe un objeto `NSURLSessionUploadTask`, el cual permitirá que se cancela la petición o se pause en cualquier momento fuera de esta clase.
     - Parameter URL: La URL del servicio.
     - Parameter uploadTask: El `NSURLSessionUploadTask` que permitirá empezar la petición.
     - Parameter completionHandler: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     */
    internal class func postWithURL(_ URL: Foundation.URL?, parameters: Any?, uploadTask: UnsafeMutablePointer<URLSessionUploadTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        
        // Armar los parámetros.
        var data: Data? = nil /* Por defecto, el valor es `nil` si no hay parámetros o no se hizo la conversión del objeto JSON a binario, pero recordar que la operación se cancela automaticamente cuando, al momento de crear la instancia `URLSessionUploadTask`, los parámetros son `nil`.  */
        if let parameters = parameters { /* Si hay parámetros... */
            if self.contentType == .Raw { /* Usando "raw"... */
                do { /* Convertir el objeto JSON en binario. */
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                }
                catch { /* Imprimir la excepción si no se logró la conversión. */
                    print("\(self) - \(#function) / Error al intentar convertir los parámetros en un objeto JSON.")
                }
            }
            else if self.contentType == .FormData || self.contentType == .None { /* Usando "form-data" o no se especifica... */
                data = self.formDataWithParameters(parameters)
            }
        }
        else { /* La operación se cancela automaticamente cuando los parámetros para crear una instancia de `URLSessiónUploadTask` son `nil`; por eso, se crea una instancia. */
            data = Data()
        }
        
        // Consumir el servicio web.
        var request = URLRequest(url: URL!)
        request.httpMethod = "POST"
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        uploadTask.pointee = session.uploadTask(with: request, from: data, completionHandler: { (data: Data?, URLResponse: URLResponse?, error: Error?) -> Void in
            var response: Any? = nil /* La respuesta del servicio web. `nil` si ocurrió un error o no se logró hacer el parseo. */
            if error == nil { /* Si no hay error en la respuesta, hay datos... */
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch { /* Imprimir la excepción si no se logró hacer el parseo. */
                    print("\(self) - \(#function) / Error al intentar parsear la respuesta del servicio web.")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                // Crear la entidad respuesta.
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state  /* `.success` si no hay error. */
                webServicesResponse.message = stateAndMessage.message /* El mensaje relacionado al estado. */
                webServicesResponse.response = response /* `nil` si ocurrió un error o no se hizo el parseo. */
                webServicesResponse.data = data /* `nil` si ocurrió un error. response es el data parseado. */
                
                // Obtener el status code y las cabeceras.
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.response = (webServicesResponse.statusCode == 403) ? nil : webServicesResponse.response
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                    
                    // Si el usuario ha configurado que el "token" de sesión se guarde automaticamente, se realiza la operación.
                    if self.saveLoginTokenIfFound == true {
                        let headerTokenSaved = self.saveLoginTokenFromHeaders(headers)
                        webServicesResponse.response = (headerTokenSaved == false) ? nil : webServicesResponse.response
                        webServicesResponse.state = (headerTokenSaved == false) ? .failure : stateAndMessage.state
                        
                        print("\(type(of: self)) - \(#function) / El token de sesión \((headerTokenSaved == true) ? "" : "NO") se guardó correctamente.")
                        self.saveLoginTokenIfFound = false /* Después de haber realizado la operación, el valor de la variable regresa a ser el inicial. De este modo, el desarrollador no tendrá que estar pendiente de esta variable a menos que tenga la intención de volver a realizar esta operación. */
                    }
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        uploadTask.pointee?.resume()
    }
    
    /**
     Método que se encarga de consumir un servicio de tipo GET. Este método recibe un objeto `NSURLSessionDataTask`, el cual permitirá que se cancela la petición o se pause en cualquier momento fuera de esta clase.
     - Parameter URL: La URL del servicio.
     - Parameter dataTask: El `NSURLSessionDataTask` que permitirá empezar la petición.
     - Parameter completionHandler: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     */
    internal class func getWithURL(_ URL: Foundation.URL?, parameters: Any?, dataTask: UnsafeMutablePointer<URLSessionDataTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        var data: Data? = nil
        if let parameters = parameters {
            do {
                data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
            catch {
                print("\(self) - \(#function) / Error al intentar convertir los parámetros en un objeto JSON.")
            }
        }
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "GET"
        request.httpBody = data
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        dataTask.pointee = session.dataTask(with: request, completionHandler: { (data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Void in
            var response: Any? = nil
            if error == nil {
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch {
                    print("\(self) - \(#function) / Error al intentar parsear la respuesta del servicio web.")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state
                webServicesResponse.message = stateAndMessage.message
                webServicesResponse.response = response
                webServicesResponse.data = data
                
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        dataTask.pointee?.resume()
    }
    
    /**
     Método que se encarga de consumir un servicio de tipo PUT. Este método recibe un objeto `NSURLSessionUploadTask`, el cual permitirá que se cancela la petición o se pause en cualquier momento fuera de esta clase.
     - Parameter URL: La URL del servicio.
     - Parameter uploadTask: El `NSURLSessionUploadTask` que permitirá empezar la petición.
     - Parameter completionHandler: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     */
    internal class func putWithURL(_ URL: Foundation.URL?, parameters: Any?, uploadTask: UnsafeMutablePointer<URLSessionUploadTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        var data: Data? = nil
        if let parameters = parameters {
            if self.contentType == .Raw {
                do {
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                }
                catch {
                    print("\(self) - \(#function) / Error al intentar convertir los parámetros en un objeto JSON.")
                }
            }
            else if self.contentType == .FormData || self.contentType == .None {
                data = self.formDataWithParameters(parameters)
            }
        }
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "PUT"
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        uploadTask.pointee = session.uploadTask(with: request, from: data, completionHandler: { (data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Void in
            var response: Any? = nil
            if error == nil {
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch {
                    print("\(self) - \(#function) / Error al intentar parsear la respuesta del servicio web.")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                // Crear la entidad respuesta.
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state
                webServicesResponse.message = stateAndMessage.message
                webServicesResponse.response = response
                webServicesResponse.data = data
                
                // Obtener el status code y las cabeceras..
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        uploadTask.pointee?.resume()
    }
    
    /**
     Método que se encarga de consumir un servicio de tipo DELETE. Este método recibe un objeto `NSURLSessionDataTask`, el cual permitirá que se cancela la petición o se pause en cualquier momento fuera de esta clase.
     - Parameter URL: La URL del servicio.
     - Parameter dataTask: El `NSURLSessionDataTask` que permitirá empezar la petición.
     - Parameter completionHandler: Bloque de código que recibe un objeto `WebServicesResponse`, el cual contiene los datos de la respuesta del servicio.
     */
    internal class func deleteWithURL(_ URL: Foundation.URL?, parameters: Any?, dataTask: UnsafeMutablePointer<URLSessionDataTask?>, completionHandler: @escaping (_ webServicesResponse: WebServicesResponse) -> Void) {
        var data: Data? = nil
        if let parameters = parameters {
            if self.contentType == .Raw {
                do {
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                }
                catch {
                    print("\(self) - \(#function) / Error al intentar convertir los parámetros en un objeto JSON.")
                }
            }
            else if self.contentType == .FormData || self.contentType == .None {
                data = self.formDataWithParameters(parameters)
            }
        }
        
        var request = URLRequest(url: URL!)
        request.httpMethod = "DELETE"
        request.httpBody = data
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = self.additionalHeaders()
        sessionConfiguration.timeoutIntervalForRequest = self.timeoutInterval
        
        let session = URLSession(configuration: sessionConfiguration)
        dataTask.pointee = session.dataTask(with: request, completionHandler: { (data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Void in
            var response: Any? = nil
            if error == nil {
                do {
                    response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                }
                catch {
                    print("\(self) - \(#function) / Error al intentar parsear la respuesta del servicio web.")
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let stateAndMessage: (state: WebServicesResponseState, message: String?) = self.webServicesResponseStateAndMessageForError(error)
                
                // Crear la entidad respuesta.
                let webServicesResponse = WebServicesResponse()
                webServicesResponse.state = stateAndMessage.state
                webServicesResponse.message = stateAndMessage.message
                webServicesResponse.response = response
                webServicesResponse.data = data
                
                // Obtener el status code y las cabeceras..
                if let HTTPURLResponse = URLResponse as? HTTPURLResponse, let headers = HTTPURLResponse.allHeaderFields as? [String: Any] {
                    webServicesResponse.statusCode = HTTPURLResponse.statusCode
                    webServicesResponse.state = (webServicesResponse.statusCode == 403) ? .tokenBlacklisted : stateAndMessage.state
                    webServicesResponse.headers = headers
                }
                
                completionHandler(webServicesResponse)
            })
        })
        
        dataTask.pointee?.resume()
    }
}
