using LinkedLists
using Test


@testset "LinkedLists (Fidelity)" begin
    @test length(detect_ambiguities(LinkedLists)) == 0
end

@testset "Empty constructor      " begin
    xs = LinkedList(Int)
    @test isempty(xs)
    @test length(xs) == 0
    @test collect(xs) == Int[]
end

@testset "Single-value constructor" begin
    xs = LinkedList(42)
    @test !isempty(xs)
    @test length(xs) == 1
    @test collect(xs) == [42]
end

@testset "Vector constructor     " begin
    xs = LinkedList([10, 20, 30])
    @test collect(xs) == [10, 20, 30]
    @test length(xs) == 3

    # Preserves insertion order (not sorted).
    ys = LinkedList([30, 10, 20])
    @test collect(ys) == [30, 10, 20]

    # Empty vector.
    zs = LinkedList(Int[])
    @test isempty(zs)
end

@testset "Copy constructor       " begin
    xs = LinkedList([1, 2, 3])
    ys = LinkedList(xs)

    # Same contents.
    @test collect(ys) == [1, 2, 3]

    # Deep copy: mutating one does not affect the other.
    push!(ys, 4)
    @test collect(xs) == [1, 2, 3]
    @test collect(ys) == [1, 2, 3, 4]

    # Copy of empty list.
    zs = LinkedList(LinkedList(Int))
    @test isempty(zs)
end

@testset "push! (append)         " begin
    xs = LinkedList(Int)
    ret = push!(xs, 1)
    @test ret === xs              # Returns the collection.
    push!(xs, 2)
    push!(xs, 3)
    @test collect(xs) == [1, 2, 3]
end

@testset "pop! (remove last)     " begin
    xs = LinkedList([10, 20, 30])
    @test pop!(xs) == 30
    @test pop!(xs) == 20
    @test pop!(xs) == 10
    @test isempty(xs)

    # Throws on empty list.
    @test_throws ArgumentError pop!(xs)
end

@testset "pushfirst! (prepend)   " begin
    xs = LinkedList(Int)
    ret = pushfirst!(xs, 3)
    @test ret === xs              # Returns the collection.
    pushfirst!(xs, 2)
    pushfirst!(xs, 1)
    @test collect(xs) == [1, 2, 3]
end

@testset "popfirst! (remove first)" begin
    xs = LinkedList([10, 20, 30])
    @test popfirst!(xs) == 10
    @test popfirst!(xs) == 20
    @test popfirst!(xs) == 30
    @test isempty(xs)

    # Throws on empty list.
    @test_throws ArgumentError popfirst!(xs)
end

@testset "Iteration / eltype     " begin
    xs = LinkedList([1, 2, 3])
    @test eltype(LinkedList{Int}) == Int
    @test sum(x for x in xs) == 6
end

@testset "show                   " begin
    xs = LinkedList([1, 2])
    buf = IOBuffer()
    show(buf, xs)
    s = String(take!(buf))
    @test occursin("LinkedList{Int64}", s)
    @test occursin("1", s)
    @test occursin("2", s)

    # Empty list.
    ys = LinkedList(Int)
    buf = IOBuffer()
    show(buf, ys)
    s = String(take!(buf))
    @test occursin("(Empty)", s)
end

