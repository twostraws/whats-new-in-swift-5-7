/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# if let shorthand for unwrapping optionals

[SE-0345](https://github.com/apple/swift-evolution/blob/main/proposals/0345-if-let-shorthand.md) introduces new shorthand syntax for unwrapping optionals into shadowed variables of the same name using `if let` and `guard let`. This means we can now write code like this:
*/
var name: String? = "Linda"
    
if let name {
    print("Hello, \(name)!")
}
/*:
Whereas previously we would have written code more like this:
*/
if let name = name {
    print("Hello, \(name)!")
}
    
if let unwrappedName = name {
    print("Hello, \(unwrappedName)!")
}        
/*:
This change *doesn’t* extend to properties inside objects, which means code like this will *not* work:
*/
struct User {
    var name: String
}
    
let user: User? = User(name: "Linda")
    
if let user.name {
    print("Welcome, \(user.name)!")
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/