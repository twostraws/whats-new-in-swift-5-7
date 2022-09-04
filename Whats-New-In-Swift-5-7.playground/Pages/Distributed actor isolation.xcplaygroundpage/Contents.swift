/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Distributed actor isolation

[SE-0336](https://github.com/apple/swift-evolution/blob/main/proposals/0336-distributed-actor-isolation.md) and [SE-0344](https://github.com/apple/swift-evolution/blob/main/proposals/0344-distributed-actor-runtime.md) introduce the ability for actors to work in a distributed form – to read and write properties or call methods over a network using remote procedure calls (RPC).

This is every part as complicated a problem as you might imagine, but there are three things to make it easier:

1. Swift’s approach of *location transparency* effectively forces us to assume the actors are remote, and in fact provides no way of determining at compile time whether an actor is local or remote – we just use the same `await` calls we would no matter what, and if the actor happens to be local then the call is handled as a regular local actor function.
2. Rather than forcing us to build our own actor transport systems, Apple is providing a [ready-made implementation](https://github.com/apple/swift-distributed-actors) for us to use. Apple has [said](https://www.swift.org/blog/distributed-actors/) they “only expect a handful of mature implementations to take the stage eventually,” but helpfully all the distributed actor features in Swift are agnostic of whatever actor transport you use.
3. To move from an actor to a distributed actor we mostly just need to write `distributed actor` then `distributed func` as needed.

So, we can write code like this to simulate someone tracking a trading card system:
*/
// use Apple's ClusterSystem transport 
typealias DefaultDistributedActorSystem = ClusterSystem
    
distributed actor CardCollector {
    var deck: Set<String>
    
    init(deck: Set<String>) {
        self.deck = deck
    }
    
    distributed func send(card selected: String, to person: CardCollector) async -> Bool {
        guard deck.contains(selected) else { return false }
    
        do {
            try await person.transfer(card: selected)
            deck.remove(selected)
            return true
        } catch {
            return false
        }
    }
    
    distributed func transfer(card: String) {
        deck.insert(card)
    }
}
/*:
Because of the throwing nature of distributed actor calls, we can be sure it’s safe to remove the card from one collector if the call to `person.transfer(card:)` didn’t throw.

Swift’s goal is that you can transfer your knowledge of actors over to distributed actors very easily, but there are some important differences that might catch you out.

First, all distributed functions must be called using `try` as well as `await` even if the function isn’t marked as throwing, because it’s possible for a failure to happen as a result of the network call going awry.

Second, all parameters and return values for distributed methods must conform to a serialization process of your choosing, such as `Codable`. This gets checked at compile time, so Swift can guarantee it’s able to send and receive data from remote actors.

And third, you should consider adjusting your actor API to minimize data requests. For example, if you want to read the `username`, `firstName`, and `lastName` properties of a distributed actor, you should prefer to request all three with a single method call rather than requesting them as individual properties to avoid potentially having to go back and forward over the network several times.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/