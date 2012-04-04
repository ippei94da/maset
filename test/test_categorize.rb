#! /usr/bin/ruby

require 'test/unit'
require 'maset/categorize.rb'

#assert_equal(correctVal, @f.bar)

class TC_Categorize < Test::Unit::TestCase
	#Array への extend として機能するか？
	def test_module_extend
		arr = [ -2, -1, 0, 1, 2, 1]
		arr.extend( Categorize )
		assert_equal( [ [-2], [-1], [0], [1, 1], [2] ], arr.categorize )

		#ブロック渡しが機能するか？
		assert_equal( [ [-2, 2], [-1, 1, 1], [0] ],
			arr.categorize{ |a, b| a.abs == b.abs }
		)

		##push してできるか
		#arr.push( 0 )
		#assert_equal( [ [-2], [-1], [0, 0], [1, 1], [2] ], arr.categorize )
	end

end

