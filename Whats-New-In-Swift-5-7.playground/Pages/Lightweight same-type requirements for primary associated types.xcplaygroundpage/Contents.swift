/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Lightweight same-type requirements for primary associated types 

[SE-0346](https://github.com/apple/swift-evolution/blob/main/proposals/0346-light-weight-same-type-syntax.md) adds newer, simpler syntax for referring to protocols that have specific associated types. 

As an example, if we were writing code to cache different kinds of data in different kinds of ways, we might start like this:
*/
protocol Cache<Content> {
    associatedtype Content
    
    var items: [Content] { get set }
    
    init(items: [Content])
    mutating func add(item: Content)
}
/*:
Notice that the protocol now looks like both a protocol and a generic type – it has an associated type declaring some kind of hole that conforming types must fill, but also lists that type in angle brackets: `Cache<Content>`.

The part in angle brackets is what Swift calls its *primary associated type*, and it’s important to understand that not all associated types should be declared up there. Instead, you should list only the ones that calling code normally cares about specifically, e.g. the types of dictionary keys and values or the identifier type in the `Identifiable` protocol. In our case we’ve said that our cache’s content – strings, images, users, etc – is its primary associated type.

At this point, we can go ahead and use our protocol as before – we might create some kind of data we want to cache, and then create a concrete cache type conforming to the protocol, like this:
*/
struct File {
    let name: String
}
    
struct LocalFileCache: Cache {
    var items = [File]()
    
    mutating func add(item: File) {
        items.append(item)
    }
}
/*:
Now for the clever part: when it comes to creating a cache, we can obviously create a specific one directly, like this:
*/
func loadDefaultCache() -> LocalFileCache {
    LocalFileCache(items: [])
}
/*:
But very often we want to hide the specifics of what we’re doing, like this:
*/
func loadDefaultCacheOld() -> some Cache {
    LocalFileCache(items: [])
}
/*:
Using `some Cache` gives us the flexibility of changing our mind about what specific cache is sent back, but what SE-0346 lets us do is provide a middle ground between being absolutely specific with a concrete type, and being rather vague with an opaque return type. So, we can specialize the protocol, like this:
*/
func loadDefaultCacheNew() -> some Cache<File> {
    LocalFileCache(items: [])
}
/*:
So, we’re still retaining the ability to move to a different `Cache`-conforming type in the future, but we’ve made it clear that whatever is chosen here will store files internally.

This smarter syntax extends to other places too, including things like extensions:
*/
extension Cache<File> {
    func clean() {
        print("Deleting all cached files…")
    }
}
/*:
And generic constraints:
*/
func merge<C: Cache<File>>(_ lhs: C, _ rhs: C) -> C {
    print("Copying all files into a new location…")
    // now send back a new cache with items from both other caches
    return C(items: lhs.items + rhs.items)
}
/*:
But what will prove most helpful of all is that [SE-0358](https://github.com/apple/swift-evolution/blob/main/proposals/0358-primary-associated-types-in-stdlib.md) brings these primary associated types to Swift’s standard library too, so `Sequence`, `Collection`, and more will benefit – we can write `Sequence<String>` to write code that is agnostic of whatever exact sequence type is being used.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/