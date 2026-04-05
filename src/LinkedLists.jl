module LinkedLists

export LinkedList

# Abstract internal linked list with subtypes: Nil and Cons.
abstract type ILinkedList{T} end

# Create the two concrete sub-types: Nil, and Cons.
struct Nil{T} <: ILinkedList{T} end

mutable struct Cons{T} <: ILinkedList{T}
    val::T
    next::ILinkedList{T}

    # Inner Constructors.
    Cons{T}(v::T) where {T} = new(v, Nil{T}())
    Cons{T}(v::T, n::ILinkedList{T}) where {T} = new(v, n)
end

# Outer Constructors.
Cons(v::T) where {T} = Cons{T}(v)
Cons(v::T, l::ILinkedList{T}) where {T} = Cons{T}(v, l)


# Create the visible (exported) LinkedList structure.
"""
LinkedList{T}

# Fields
- head::ILinkedList{T} -- An internal linked list.


"""
mutable struct LinkedList{T}
    head::ILinkedList{T}

    # Inner Constructor.
    LinkedList{T}(h::ILinkedList{T}) where {T} = new(h)
end

#---- Outer Constructors ----- 

# An empty LinkedList of type T.
"""
	LinkedList(::Type{T})

Creates an empty `LinkedList` of type `T`.

# Arguments
- `::Type{T}` -- The Type of the `LinkedList`.

# Return
- Empty `LinkedList` of type `T`.
"""
LinkedList(::Type{T}) where {T} = LinkedList{T}(Nil{T}())

# Copy constructor -- deep copies the internal list.
"""
	LinkedList(l::LinkedList{T})

Creates a new `LinkedList` which is a **deep copy** of another `LinkedList`.
Mutating the copy will not affect the original.

# Arguments
- `l::LinkedList{T}` -- `LinkedList` to copy.

# Return
- A new `LinkedList` of type `T`.
"""
function LinkedList(l::LinkedList{T}) where {T}
    vs = collect(l)
    return isempty(vs) ? LinkedList(T) : LinkedList(vs)
end

# A single value
"""
	LinkedList(v::T)

Creates a `LinkedList` containing a single element, `v`, of type `T`.

# Arguments
- `v::T` -- The sole element of this `LinkedList`.

# Return
- `LinkedList` of type `T`.
"""
LinkedList(v::T) where {T} = LinkedList{T}(Cons(v))

# A Vector of values
"""
	LinkedList(v::Vector{T})

Creates a `LinkedList` containing the elements from a Vector of type `T`.
The elements of the resulting `LinkedList` will be in the same order 
as the vector.

# Arguments
- `v::Vector{T}` -- The elements of this `LinkedList`.

# Return
- `LinkedList` of type `T`.
"""
function LinkedList(vs::Vector{T}) where {T}
    n = length(vs)
    if n == 0
        return LinkedList(T)
    end

    il = Cons{T}(vs[n])
    for i in (n-1):-1:1
        il = Cons{T}(vs[i], il)
    end

    return LinkedList{T}(il)
end

# Internal helper for the "iterate" protocol.
_istate(::ILinkedList) = nothing
_istate(i::Cons) = (i.val, i.next)

# Implement the "iterate" protocol: How to go from one state to the next.
Base.iterate(l::LinkedList) = _istate(l.head)
Base.iterate(::LinkedList, ::ILinkedList) = nothing
Base.iterate(::LinkedList, s::Cons) = (s.val, s.next)

# Implement the "iterate" protocol: Julia needs to know a "size" of a container.
Base.IteratorSize(::Type{<:LinkedList}) = Base.SizeUnknown()
Base.eltype(::Type{LinkedList{T}}) where {T} = T

# Collection query methods.
Base.isempty(l::LinkedList) = l.head isa Nil

function Base.length(l::LinkedList)
    n = 0
    for _ in l
        n += 1
    end
    return n
end


function Base.show(io::IO, l::LinkedList{T}) where {T}
    print(io, "LinkedList{$T}")

    if isempty(l)
        print(io, "--(Empty)")
    else
		for (x,i) in zip(l, 1:21)
			if i > 20
                print(io, "\n⋮")
				break
			end
			print(io, "\n$x")
        end
    end
    println(io, "")
end

# O(1) prepend.
function Base.pushfirst!(l::LinkedList{T}, v::T) where {T}
    l.head = Cons(v, l.head)
    return l
end

# O(1) pop from front.
function Base.popfirst!(l::LinkedList{T}) where {T}
    isempty(l) && throw(ArgumentError("list must be non-empty"))
    val = l.head.val
    l.head = l.head.next
    return val
end

# O(n) append.
function Base.push!(l::LinkedList{T}, v::T) where {T}
    if isempty(l)
        l.head = Cons(v)
        return l
    end

    cur = l.head
    while cur.next != Nil{T}()
        cur = cur.next
    end

    cur.next = Cons(v)
    return l
end

# O(n) pop from back.
function Base.pop!(l::LinkedList{T}) where {T}
    isempty(l) && throw(ArgumentError("list must be non-empty"))

    cur  = l.head
    end_link = Nil{T}()

    # If list contains just one element.
    if cur.next == end_link
        l.head = end_link
        return cur.val
    end

    # Otherwise, get to the last item.
    last = cur
    while cur.next != end_link
        last = cur
        cur  = cur.next
    end

    # Point the second-to-last element's next field to Nil.
    last.next = end_link

    # Return the value of the last link.
    return cur.val
end


end # module


