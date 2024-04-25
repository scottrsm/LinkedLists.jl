# LinkedLists.jl Documentation

```@meta
CurrentModule = LinkedLists
```
# Overview
This module contains the structure for (Single) Linked Lists.
Additionally, public constructors as well as overloaded functions
to work with the iterator protocol, the show method, 
and the functions push! and pop!.

## Approach
- We use an internal linked List, *ILinkedList*, that is Abstract with two subtypes: Cons and Nil.
  `Cons{T}` is a container of value, while `Nil` marks the end of the list.
- Notice that the `Nil{T}` struct has no fields and is **NOT** mutable.
  This means that we get a singleton instance which we can compare against
  to test for the end of a given linked list.
- **NOTE:** `Nil{T}` is non-mutable while `Cons{T}` is mutable even though
  they are subtypes of the abstract type *ILinkedList*.
- Then a *LinkedList* struct is defined which has a head field that is the internal linked list, *ILinkedList*.
- We use type stability, the singleton nature of `Nil{T}`, multiple dispatch, and Base operator overloading
    to create a linked list that is performant with minimal code.

## Types

```@docs
LinkedList{T} 
```

## Outer `LinkedList` Constructors

```@docs
LinkedList(x::T) where T
```

## Index
```@index
```

