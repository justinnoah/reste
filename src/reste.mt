import "lib/enum" =~ [=> makeEnum]
import "unittest" =~ [=> unittest]
# exports (makeApp, GET, POST, PUT, DELETE)
exports (Actions)

def [Actions :DeepFrozen,
    GET :DeepFrozen,
    POST :DeepFrozen,
    PUT :DeepFrozen,
    DELETE :DeepFrozen] := makeEnum(
        ["GET","POST", "PUT", "DELETE"]
    )

def makeApp() as DeepFrozen:
    "Create an App object to manage routing"
    # route to method map
    var routes := [].asMap().diverge()

    return object App:
        to getRoutes():
            return routes

        to addRoute(url :Str, actions :List[Actions], meth):
            def actionMethods := [].asMap().diverge()
            for action in (actions):
                actionMethods[action] := meth
            routes[url] := actionMethods

        to methodsFor(url):
            return routes[url].getKeys()


def testApp(assert):
    var app := makeApp()
    app.addRoute("/", [GET], fn { traceln("index reached")})
    assert.equal(app.methodsFor("/"), [GET])

unittest([
    testApp,
])
