//
//  RedgifsAPI.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-15.
//

import Alamofire
import Foundation

enum RedgifsAPI: URLRequestConvertible {
    case getRedgifsData(id: String)
    case getRedgifsTemporaryToken
    
    private var baseURL: String {
        return APIUtils.REDGIFS_API_BASE_URI
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getRedgifsData(let id):
            return "/v2/gifs/\(id)"
        case .getRedgifsTemporaryToken:
            return "/v2/auth/temporary"
        }
    }
    
    var parameters: [String: String]? {
        return nil
    }
    
    var queries: [String: String]? {
        switch self {
        case .getRedgifsData:
            return ["user-agent": APIUtils.USER_AGENT]
        case .getRedgifsTemporaryToken:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getRedgifsData:
            return APIUtils.getRedgifsOAuthHeader(redgifsAccessToken: TokenUserDefaultsUtils.redgifs)
        case .getRedgifsTemporaryToken:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL().appendingPathComponent(path)
        //Setup query params
        if let queries = queries {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = queries.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            if let updatedURL = urlComponents.url {
                url = updatedURL
            }
        }
        //Set up method and headers
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers ?? HTTPHeaders()
        
        //Setup URL encoded form data
        let formEncodedData = parameters?.map { key, value in
            "\(key)=\(value)"
        }.joined(separator: "&")
        request.httpBody = formEncodedData?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
