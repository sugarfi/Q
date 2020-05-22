# Q
This is the beta version of the Q language. Q is written in Crystal, so you can
run it like so:
```
crystal run main.cr -- file.q
```
Note that this is still in beta.

## What is Q?
Q is a functional-ish esoteric-ish language. It is based around the concept of
streams/queues, hence the name. There are four main types in Q:

- A blob, which is just a bunch of raw numbers.
- A queue, which is just a list of any of the other types.
- A promise, which is a command to push a blob to a queue.
- A handler, which is a command to execute a certain promise whenever a certain queue changes.

### Blobs
Blobs are just raw blobs of numbers. To declare a blob, use the syntax:
```
[1 2 3]
```
The brackets are mandatory.

### Queues
A queue is just a list of any of the other data types. All programs are simply queues. To
"execute" a queue, the interpreter simply pops items off of it. If the item popped is a promise,
it is resolved. Otherwise, it is pushed again. This keeps going until the queue is empty.

### Promises
A promise is like a JS promise: the interpreter "promises" to execute a bit of code, but gives
you no guarantee when (so maybe it's not *exactly* like a JS promise, whatever). To declare a
promise, use the format:
```
(queue <- [1 2 3])
```
A promise currently must be made up of a queue name followed by a `<-` followed by a blob.
All programs are simply sequences of promises and handlers. If the queue referenced by a promise
does not exist, it is created.

### Handlers
Handlers are not really a type - they are declared before runtime. A handler simply sets up
an event handler of sorts, which will trigger whenever a certain queue is pushed to. To
declare a handler, use the syntax:
```
(queue -> (queue2 <- [1 2 3]))
```
A handler must be made up of a queue name followed by a `->` followed by a promise. Since handlers
are set up before runtime, they can be declared anywhere in the program, even before their
queue is pushed to.

## Roadmap

Q is far from finished, and I plan to add quite a few features, including:

- An stdlib
- The ability to push promises to a queue
- Syntatic sugar for strings and numbers
- More flexible handlers

## License and Credits

This code is licensed under GNU GPL v3.0. It was all written by me, sugarfi.
