using LinkedLists
import Pkg

Pkg.add("Documenter")
using Documenter

makedocs(
	sitename = "LinkedLists",
	format = Documenter.HTML(),
	modules = [LinkedLists]
	)

	# Documenter can also automatically deploy documentation to gh-pages.
	# See "Hosting Documentation" and deploydocs() in the Documenter manual
	# for more information.
	deploydocs(
		repo = "github.com/scottrsm/LinkedLists.jl.git"
	)
