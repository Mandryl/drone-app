//
// IncidentsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(Combine)
import Combine
#endif
#if canImport(AnyCodable)
import AnyCodable
#endif

open class IncidentsAPI {

    /**
     Create Incidents
     
     - parameter incident: (body)  
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: AnyPublisher<Void, Error>
     */
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func createIncidentsIncidentsPost(incident: Incident, apiResponseQueue: DispatchQueue = AggregateAPIClient.apiResponseQueue) -> AnyPublisher<Void, Error> {
        return Future<Void, Error>.init { promise in
            createIncidentsIncidentsPostWithRequestBuilder(incident: incident).execute(apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    #endif

    /**
     Create Incidents
     - POST /incidents
     - Create incident records
     - parameter incident: (body)  
     - returns: RequestBuilder<Void> 
     */
    open class func createIncidentsIncidentsPostWithRequestBuilder(incident: Incident) -> RequestBuilder<Void> {
        let path = "/incidents"
        let URLString = AggregateAPIClient.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: incident)

        let urlComponents = URLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            :
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = AggregateAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (urlComponents?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

    /**
     Create Incidents
     
     - parameter rawIncident: (body)  
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: AnyPublisher<Void, Error>
     */
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func createIncidentsRawIncidentsPost(rawIncident: RawIncident, apiResponseQueue: DispatchQueue = AggregateAPIClient.apiResponseQueue) -> AnyPublisher<Void, Error> {
        return Future<Void, Error>.init { promise in
            createIncidentsRawIncidentsPostWithRequestBuilder(rawIncident: rawIncident).execute(apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    #endif

    /**
     Create Incidents
     - POST /raw-incidents
     - Create incident records
     - parameter rawIncident: (body)  
     - returns: RequestBuilder<Void> 
     */
    open class func createIncidentsRawIncidentsPostWithRequestBuilder(rawIncident: RawIncident) -> RequestBuilder<Void> {
        let path = "/raw-incidents"
        let URLString = AggregateAPIClient.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: rawIncident)

        let urlComponents = URLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            :
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = AggregateAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (urlComponents?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }
}