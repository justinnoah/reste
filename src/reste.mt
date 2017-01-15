import "lib/enum" =~ [=> makeEnum]
import "unittest" =~ [=> unittest]
# exports (makeApp, GET, POST, PUT, DELETE)
exports (Actions)

### Possible Actions ###

def [Actions :DeepFrozen,
    GET :DeepFrozen,
    POST :DeepFrozen,
    PUT :DeepFrozen,
    DELETE :DeepFrozen] := makeEnum(
        ["GET","POST", "PUT", "DELETE"]
    )

### Create an object that manages the routes of the webapp ###

def makeApp() as DeepFrozen:
    "Create an App object to manage routing"
    # route to method map
    var routes := [].asMap().diverge()

    return object App:
        to getRoutes():
            return routes

        to route(url :Str, actions :List[Actions], meth):
            def actionMethods := [].asMap().diverge()
            for action in (actions):
                actionMethods[action] := meth
            routes[url] := actionMethods

        to delete(url :Str, meth):
            App.route(url, [DELETE], meth)

        to get(url :Str, meth):
            App.route(url, [GET], meth)

        to post(url :Str, meth):
            App.route(url, [POST], meth)

        to put(url :Str, meth):
            App.route(url, [PUT], meth)

        to methodsFor(url):
            return routes[url].getKeys()

### Tests ###

def testApp(assert):
    def app := makeApp()
    app.route("/", [GET], fn { traceln("index reached")})
    assert.equal(app.methodsFor("/"), [GET])

def testAnotherApp(assert):
    def app := makeApp()
    app.post("/x", fn { traceln("x posted")})
    assert.equal(app.methodsFor("/x"), [POST])

unittest([
    testApp,
    testAnotherApp,
])
