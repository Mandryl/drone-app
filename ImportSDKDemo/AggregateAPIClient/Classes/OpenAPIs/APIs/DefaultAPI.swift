//
// DefaultAPI.swift
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

open class DefaultAPI {

    /**

     - parameter postIncidentsRequest: (body)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: AnyPublisher<Void, Error>
     */
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func postIncidents(postIncidentsRequest: PostIncidentsRequest? = nil, apiResponseQueue: DispatchQueue = AggregateAPIClient.apiResponseQueue) -> AnyPublisher<Void, Error> {
        return Future<Void, Error>.init { promise in
            postIncidentsWithRequestBuilder(postIncidentsRequest: postIncidentsRequest).execute(apiResponseQueue) { result -> Void in
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
     - POST /incidents
     - Create new incident information
     - parameter postIncidentsRequest: (body)  (optional)
     - returns: RequestBuilder<Void> 
     */
    open class func postIncidentsWithRequestBuilder(postIncidentsRequest: PostIncidentsRequest? = nil) -> RequestBuilder<Void> {
        let path = "/incidents"
        let URLString = AggregateAPIClient.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: postIncidentsRequest)

        let urlComponents = URLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            :
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = AggregateAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (urlComponents?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }
}