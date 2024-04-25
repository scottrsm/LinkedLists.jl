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

# With a given list.
"""
	LinkedList(l::LinkedList{T})

Creates a `LinkedList` which **shares** the internal list of another `LinkedList`.

**Note:** This means that using `push!` or `pop!` on one `LinkedList` will
effect the other `LinkedList`.

**Note:** If `ys = LinkedList(xs)` where `xs` is a LinkedList, then if one 
`pop!`'s `xs` to exhaustion, `ys` will have one element. That is, `pop!` will 
leave one element left in `ys`.

# Arguments
- `l::LinkedList{T}` -- Shared `LinkedList`.

# Return
- `LinkedList` of type `T`.
"""
LinkedList(l::LinkedList{T}) where {T} = LinkedList{T}(l.head)

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

    vss = sort(vs, rev=true)
    il  = Cons{T}(vss[1])
    for i in 2:n
        il = Cons{T}(vss[i], il)
    end

    return LinkedList{T}(il)
end

# Need a way to get the "state" for "Cons" and "Nil" -- used for the implementation
# of the "iterate" protocol of LinkedList.
getIState(i::ILinkedList{T}) where {T} = nothing
getIState(i::Cons{T}) where {T} = (i.val, i.next)

# Implement the "iterate" protocol: How to go from one state to the next.
Base.iterate(l::LinkedList{T}) where {T} = getIState(l.head)
Base.iterate(l::LinkedList{T}, s::ILinkedList{T}) where {T} = nothing
Base.iterate(l::LinkedList{T}, s::Cons{T}) where {T} = (s.val, s.next)

# Implement the "iterate" protocol: Julia needs to know a "size" of a container.
Base.IteratorSize(i::LinkedList{T}) where {T} = Base.SizeUnknown()


function Base.show(io::IO, l::LinkedList{T}) where {T}
    print(io, "LinkedList{" * string(T) * "}")

    # We can compare against Nil{T} as it is a
	# Singleton for its "class" (LinkedList) as long as NIL{T} (<: ILinkedList{T}) is *NOT* mutable.
    if l.head == Nil{T}()
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

function Base.push!(l::LinkedList{T}, v::T) where {T}
    cur = l.head

    if cur == Nil{T}()
        l.head = Cons(v)
        return nothing
    end

    while cur.next != Nil{T}()
        cur = cur.next
    end

    cur.next = Cons(v)
    return nothing
end


# Implement pop! for LinkedList{T}.
function Base.pop!(l::LinkedList{T}) where {T}
    cur  = l.head
    last = l.head
    end_link = Nil{T}()

    # If we are pointing to Nil, return nothing.
    if l.head == end_link
        return nothing
    end

    # If list contains just one element.
    if cur.next == end_link
        l.head = end_link
        return cur.val
    end

    # Otherwise, get to the last item.
    while cur.next != end_link
        last = cur
        cur  = cur.next
    end

    # Point the second-to-last element's next field to Nil.
    last.next = end_link

    # Return the value of the last link (what was the last link).
    return cur.val
end


end # module


