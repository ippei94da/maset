#! /usr/bin/ruby

require 'test/unit'
require 'maset/mapping.rb'

class TC_Array < Test::Unit::TestCase
	def setup
		@a0 = ['a', 'b', 'c', 'b', ]
		@a1 = [ 1, 2, 3, -2 ]
	end

	def test_find_all_indices
		assert_equal([0],   @a0.find_all_indices{|i| i == 'a' })
		assert_equal([1,3], @a0.find_all_indices{|i| i == 'b' })
		assert_equal([2],   @a0.find_all_indices{|i| i == 'c' })
		assert_equal([],    @a0.find_all_indices{|i| i == 'd' })

		assert_equal([0,3], @a1.find_all_indices{ |i| i < 2 } )
		assert_equal([0,1,3], @a1.find_all_indices{ |i| i <= 2 } )
		assert_equal([1, 3], @a1.find_all_indices{ |i| i.abs == 2 } )
	end

end

class Array
	include Mapping
end

class TC_Mapping < Test::Unit::TestCase
	def setup
		@a0 = ['a', 'b', 'c', 'd']
		@a1 = ['b', 'c', 'a', 'a']
		@a2 = ['b', 'c', 'a', 'd']
		@a3 = ['a', 'a', 'b', 'c']
		@a4 = ['a', 'b', 'c']
		@b0 = [  1,  2,  3 ]
		@b1 = [ -2, -3, -1 ]
		@b2 = [ -1,  2,  3 ]

		@c0 = [ 1, 2, 3, 3]
		@c1 = [-3,-3,-1,-2]
		@c2 = [-1,-3,-3,-3]
		@c3 = [-1,-4,-3,-3]
		@c4 = [-1,-1,-3,-3]
	end

	def test_self_map
		assert_equal( [[2,3],[0],[1],[]], Mapping::map(@a0, @a1){ |i, j| i == j } )
		assert_equal( [[0],[1],[2],[2]] , Mapping::map(@a1, @a2){ |i, j| i == j } )
		assert_equal( [[1],[2],[0],[3]] , Mapping::map(@a2, @a0){ |i, j| i == j } )
		assert_equal( [[1],[2],[0],[0]] , Mapping::map(@a1, @a0){ |i, j| i == j } )
		assert_equal( [[0],[1],[2,3],[]], Mapping::map(@a2, @a1){ |i, j| i == j } )
		assert_equal( [[2],[0],[1],[3]] , Mapping::map(@a0, @a2){ |i, j| i == j } )
		assert_equal( [[0],[1],[2],[]]  , Mapping::map(@a0, @a4){ |i, j| i == j } )
		assert_equal( [[2],[0],[1]]     , Mapping::map(@b0, @b1){ |i, j| i == -j } )
		assert_equal( [[0],[],[]]       , Mapping::map(@b0, @b2){ |i, j| i == -j } )
	end

	def test_self_map?
		assert_equal(true , Mapping::map?(@a0, @a0){ |i, j| i == j } )
		assert_equal(false, Mapping::map?(@a0, @a1){ |i, j| i == j } )
		assert_equal(true , Mapping::map?(@a0, @a2){ |i, j| i == j } )
		assert_equal(false, Mapping::map?(@a1, @a0){ |i, j| i == j } )
		assert_equal(false, Mapping::map?(@a1, @a1){ |i, j| i == j } )
		assert_equal(false, Mapping::map?(@a1, @a2){ |i, j| i == j } )
		assert_equal(true , Mapping::map?(@a2, @a0){ |i, j| i == j } )
		assert_equal(false, Mapping::map?(@a2, @a1){ |i, j| i == j } )
		assert_equal(true , Mapping::map?(@a2, @a2){ |i, j| i == j } )
		assert_equal(true , Mapping::map?([] , [] ){ |i, j| i == j } )
		assert_equal(false, Mapping::map?(@a0, [] ){ |i, j| i == j } )
		assert_equal(false, Mapping::map?([] , @a0){ |i, j| i == j } )

		assert_equal(true , Mapping::map?(@b0, @b1){ |i, j| i == -j })
		assert_equal(false, Mapping::map?(@b0, @b2){ |i, j| i == -j })
	end

	def test_self_correspond?
		assert_equal(true , Mapping::corresponding?(@a0, @a0){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a0, @a1){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a0, @a2){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a0, @a3){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a0, @a4){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a1, @a0){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a1, @a1){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a1, @a2){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a1, @a3){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a1, @a4){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a2, @a0){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a2, @a1){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a2, @a2){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a2, @a3){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a2, @a4){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a3, @a0){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a3, @a1){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a3, @a2){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@a3, @a3){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@a3, @a4){ |i, j| i == j })
		assert_equal(true , Mapping::corresponding?(@b0, @b1){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@b0, @b2){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c0, @c1){ |i, j| i == j })
		assert_equal(false, Mapping::corresponding?(@c0, @c0){ |i, j| i == -j })
		assert_equal(true , Mapping::corresponding?(@c0, @c1){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c0, @c2){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c0, @c3){ |i, j| i == -j })
		assert_equal(true , Mapping::corresponding?(@c1, @c0){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c1, @c1){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c1, @c2){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c1, @c3){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c2, @c0){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c2, @c1){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c2, @c2){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c2, @c3){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c3, @c0){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c3, @c1){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c3, @c2){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c3, @c3){ |i, j| i == -j })
		assert_equal(false, Mapping::corresponding?(@c2, @c4){ |i, j| i == -j })
	end

	def test_correspond?
		assert_equal(true , @a0.corresponding?( @a0){ |i, j| i == j })
		assert_equal(false, @a0.corresponding?( @a1){ |i, j| i == j })
		assert_equal(true , @a0.corresponding?( @a2){ |i, j| i == j })
		assert_equal(false, @a0.corresponding?( @a3){ |i, j| i == j })
		assert_equal(false, @a0.corresponding?( @a4){ |i, j| i == j })
		assert_equal(false, @a1.corresponding?( @a0){ |i, j| i == j })
		assert_equal(true , @a1.corresponding?( @a1){ |i, j| i == j })
		assert_equal(false, @a1.corresponding?( @a2){ |i, j| i == j })
		assert_equal(true , @a1.corresponding?( @a3){ |i, j| i == j })
		assert_equal(false, @a1.corresponding?( @a4){ |i, j| i == j })
		assert_equal(true , @a2.corresponding?( @a0){ |i, j| i == j })
		assert_equal(false, @a2.corresponding?( @a1){ |i, j| i == j })
		assert_equal(true , @a2.corresponding?( @a2){ |i, j| i == j })
		assert_equal(false, @a2.corresponding?( @a3){ |i, j| i == j })
		assert_equal(false, @a2.corresponding?( @a4){ |i, j| i == j })
		assert_equal(false, @a3.corresponding?( @a0){ |i, j| i == j })
		assert_equal(true , @a3.corresponding?( @a1){ |i, j| i == j })
		assert_equal(false, @a3.corresponding?( @a2){ |i, j| i == j })
		assert_equal(true , @a3.corresponding?( @a3){ |i, j| i == j })
		assert_equal(false, @a3.corresponding?( @a4){ |i, j| i == j })
		assert_equal(true , @b0.corresponding?( @b1){ |i, j| i == -j })
		assert_equal(false, @b0.corresponding?( @b2){ |i, j| i == -j })
		assert_equal(false, @c0.corresponding?( @c1){ |i, j| i == j })
		assert_equal(false, @c0.corresponding?( @c0){ |i, j| i == -j })
		assert_equal(true , @c0.corresponding?( @c1){ |i, j| i == -j })
		assert_equal(false, @c0.corresponding?( @c2){ |i, j| i == -j })
		assert_equal(false, @c0.corresponding?( @c3){ |i, j| i == -j })
		assert_equal(true , @c1.corresponding?( @c0){ |i, j| i == -j })
		assert_equal(false, @c1.corresponding?( @c1){ |i, j| i == -j })
		assert_equal(false, @c1.corresponding?( @c2){ |i, j| i == -j })
		assert_equal(false, @c1.corresponding?( @c3){ |i, j| i == -j })
		assert_equal(false, @c2.corresponding?( @c0){ |i, j| i == -j })
		assert_equal(false, @c2.corresponding?( @c1){ |i, j| i == -j })
		assert_equal(false, @c2.corresponding?( @c2){ |i, j| i == -j })
		assert_equal(false, @c2.corresponding?( @c3){ |i, j| i == -j })
		assert_equal(false, @c3.corresponding?( @c0){ |i, j| i == -j })
		assert_equal(false, @c3.corresponding?( @c1){ |i, j| i == -j })
		assert_equal(false, @c3.corresponding?( @c2){ |i, j| i == -j })
		assert_equal(false, @c3.corresponding?( @c3){ |i, j| i == -j })
		assert_equal(false, @c2.corresponding?( @c4){ |i, j| i == -j })
	end

	def test_map_to
		assert_equal([[2,3],[0],[1],[]], @a0.map_to(@a1){ |i, j| i == j })
		assert_equal([[0],[1],[2],[2]],  @a1.map_to(@a2){ |i, j| i == j })
		assert_equal([[1],[2],[0],[3]],  @a2.map_to(@a0){ |i, j| i == j })
		assert_equal([[1],[2],[0],[0]],  @a1.map_to(@a0){ |i, j| i == j })
		assert_equal([[0],[1],[2,3],[]], @a2.map_to(@a1){ |i, j| i == j })
		assert_equal([[2],[0],[1],[3]],  @a0.map_to(@a2){ |i, j| i == j })
		assert_equal( [[2], [0], [1]], @b0.map_to(@b1){ |i, j| i == -j })
		assert_equal( [[0], [], []]  , @b0.map_to(@b2){ |i, j| i == -j })
	end

	def test_map_from
		assert_equal([[2,3],[0],[1],[]], @a1.map_from(@a0){ |i, j| i == j })
		assert_equal([[0],[1],[2],[2]],  @a2.map_from(@a1){ |i, j| i == j })
		assert_equal([[1],[2],[0],[3]],  @a0.map_from(@a2){ |i, j| i == j })
		assert_equal([[1],[2],[0],[0]],  @a0.map_from(@a1){ |i, j| i == j })
		assert_equal([[0],[1],[2,3],[]], @a1.map_from(@a2){ |i, j| i == j })
		assert_equal([[2],[0],[1],[3]],  @a2.map_from(@a0){ |i, j| i == j })
		assert_equal( [[1], [2], [0]] ,  @b0.map_from(@b1){ |i, j| i == -j })
		assert_equal( [[0], [], []]   ,  @b0.map_from(@b2){ |i, j| i == -j })
	end

	def test_map?
		assert_equal(false, @a0.map?(@a1){ |i, j| i == j })
		assert_equal(false, @a1.map?(@a2){ |i, j| i == j })
		assert_equal(true , @a2.map?(@a0){ |i, j| i == j })
		assert_equal(false, @a1.map?(@a0){ |i, j| i == j })
		assert_equal(false, @a2.map?(@a1){ |i, j| i == j })
		assert_equal(true , @a0.map?(@a2){ |i, j| i == j })

		assert_equal( true , @b0.map?(@b1){ |i, j| i == -j })
		assert_equal( false, @b0.map?(@b2){ |i, j| i == -j })
	end

	def test_module_extend 
		a0 = ['a', 'b', 'c', 'd']
		a0.extend( Mapping )
		assert_equal(false, a0.map?( @a1 ){ |i, j| i == j })
		assert_equal(true , a0.map?( @a2 ){ |i, j| i == j })
	end

end

