import Foundation

public protocol RequestDelegate {
	associatedtype RequestType: Request
	associatedtype ResponseType: Response = StandardResponse
	associatedtype ContentType = Void
	associatedtype ErrorType: Error = RequestError

	var name: String { get }

	func request (_ requestInfo: RequestInfo) throws -> RequestType

	func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession
	func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest

	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType

	func error (_ error: RequestError, _ requestInfo: RequestInfo) -> ErrorType
}

public extension RequestDelegate {
	var name: String { "\(Self.self)" }

	func urlSession (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLSession { try request.urlSession() }
	func urlRequest (_ request: RequestType, _ requestInfo: RequestInfo) throws -> URLRequest { try request.urlRequest() }
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try ResponseType(data, urlResponse) }
}

public extension RequestDelegate where ResponseType == StandardResponse {
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) -> (data: Data, urlResponse: URLResponse) {
        (response.data, response.urlResponse)
    }
}

public extension RequestDelegate where ContentType == Void {
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) { }
}

public extension RequestDelegate where ErrorType == RequestError {
	func error (_ error: RequestError, _ requestInfo: RequestInfo) -> ErrorType { error }
}
