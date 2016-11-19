/*:
 # Observable
 
 Is a subject which **emits events**
 
 When does an Observable begin emitting events? There are two types of Observables:
 
 ## Hot Observable
 May begin emitting events **as soon as it is created**
 
 So any `Observer` who later subscribes to it, may start observing the sequence somewhere in the middle
 
 ## Cold Observable
 Waits until an `Observer` subscribes to it, before it begins to emit events
 
 ----
 # Observer
 Is a subject that reacts to **events received** from an `Observable`
 
 ![Observable Legend](observable_legend.png)
 
 ----
 > There are different ways of subscribing to an Observable, in this playground I'll be using two:
 >
 > `.subscribe { }`
 >
 > Deals with the encapsulating `Event<Element>`
 > * *`.next(Element)`*
 > * *`.error(Error)`*
 > * *`.completed`*
 >
 > `.subscribe(onNext: { }, onError: { }, onCompleted: { })`
 >
 > Deals with the Element directly, separating each event to it's own closure
 
 > Another thing you'll notice is the DisposeBag
 >
 > Everytime there is a subscription to an *Observable*, it will generate a *Disposable* which contains all closures you just created when subscribed
 >
 > This is why after subscribing, it should be put onto a DisposableBag *(or it could cause a **memory leak**)*
 >
 > When a DisposeBag is deinitialized, it will also remove all of its content with it
 >
 > And make sure it is deinitialized later (avoid memory retaining cycles)
 
 */
