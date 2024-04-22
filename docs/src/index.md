# LinkedLists.jl Documentation

```@meta
CurrentModule = LinkedLists
```
# Overview
This module contains the structure for (Single) Linked Lists.
Additionally, public constructors as well as overloaded functions
to work with the interator protocol and push! and pop!.

The `Base::show` function has also been overloaded.

## Types

```@docs
LinkedList{T} 
```

## Alternative `LinkedList` Constructors

```@docs
LinkedList(::Type{T}) where T
LinkedList(l::LinkedList{T}) where T
LinkedList(v::T)  where T
```

## Index
```@index
```

