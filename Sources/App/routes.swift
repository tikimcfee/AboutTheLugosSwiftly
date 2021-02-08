import Vapor


func _Vapor_routes(_ app: Application) throws {
    app.get { req -> Response in
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html")
        let html = BaseRenderer(vaporApp: app).renderRoute()
        return Response(status: .ok, headers: headers, body: .init(string: html))
    }
}
