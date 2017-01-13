import "lib/enum" =~ [=> makeEnum]
import "unittest" =~ [=> unittest]
# exports (makeRESTApp, GET, POST, PUT, DELETE)
exports (Actions)

def [Actions :DeepFrozen,
    GET :DeepFrozen,
    POST :DeepFrozen,
    PUT :DeepFrozen,
    DELETE :DeepFrozen] := makeEnum(
        ["GET","POST", "PUT", "DELETE"]
    )

def makeRESTApp() as DeepFrozen:
    "Create a REST App object to manage/handle REST routing"
    # route to method map
    var routes := [].asMap().diverge()

    return object RESTApp:
        to getRoutes():
            return routes

        to addRoute(url :Str, actions :List[Actions], meth):
            def actionMethods := [].asMap().diverge()
            for action in (actions):
                actionMethods[action] := meth
            routes[url] := actionMethods

        to methodsFor(url):
            return routes[url].getKeys()


def testRESTApp(assert):
    var app := makeRESTApp()
    app.addRoute("/", [GET], fn { traceln("index reached")})
    assert.equal(app.methodsFor("/"), [GET])

unittest([
    testRESTApp,
])
