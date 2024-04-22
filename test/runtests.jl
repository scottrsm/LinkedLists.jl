using LinkedLists
using Test


@testset "LinkedLists (Fidelity)" begin
    @test length(detect_ambiguities(LinkedLists)) == 0
end

@testset "Push/Pop" begin
	xs = LinkedList([10, 20, 30])
	#push!(xs, 40)
	#@test pop!(xs) == 40


	pop!(xs)
	pop!(xs)
	v = pop!(xs)

	@test v == 10

end

