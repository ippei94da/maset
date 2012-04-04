
class Array
	#引数と等価な全て要素のインデックスからなる配列を返す。
	#find_all は要素を返すが、これはインデックスを返す点が異なる。
	#e.g., [ 10, 20, 30 ].find_all_indices{ |i| i < 25 } #=> [ 0, 1 ]
	def find_all_indices
		results = []
		self.each_with_index do |elem, i|
			results << i if yield( elem )
		end
		results
	end

end

#
#要素同士の対応を扱うモジュール。
module Mapping

	#For module methods

	#左のコンテナに注目し、右のコンテナにある条件を満たすインデックス全てを
	#入れた配列を返す。
	#等価なものを探すことなどに使える。
	#右のコンテナに等価なものがなければ空配列が入る。
	#e.g., left  = ['a', 'b', 'c', 'd']
	#      right = ['b', 'c', 'a', 'a']
	#      のとき、
	#      self.left_to_right(left, right) #=> [ [2, 3], [0], [1], [] ]
	#必ずブロックが渡されることを前提とする。
	#ブロックをたとえば { |i, j| i == j } とすれば、
	#left, right それぞれに由来する要素 i, j を == 演算で等価判定していることになる。
	#ブロックに渡すのは等価判定でなくても構わない。
	def self.map( left, right )
		size = left.size
		results = Array.new( size, [] )
		size.times do |n|
			results[n] = right.find_all_indices{ |i| yield( i, left[n] )  }
		end
		results
	end

	#2つのコンテナが一対一対応していれば true、そうでなければ false
	#自分と自分でも多対多の対応になる可能性があり、その場合は false
	def self.map?(left, right)
		return true  if ((left.size == 0 ) && (right.size == 0))
		return false if ((left.size == 0 ) || (right.size == 0)) #どちらかが 0 でどちらかが非0

		l2r = self.map(left, right){ |i, j| yield( i, j ) }
		r2l = self.map(right, left){ |i, j| yield( i, j ) }
		result = true
		result = false if ( l2r.max_by{|i| i.size }.size != 1 )
		result = false if ( l2r.min_by{|i| i.size }.size != 1 )
		result = false if ( r2l.max_by{|i| i.size }.size != 1 )
		result = false if ( r2l.min_by{|i| i.size }.size != 1 )
		#max_by, min_by は要素を返すため、それに操作を改めて加えてサイズを出す。
		result
	end

	#map? よりもゆるく、多対多でも等しい要素の数が同じであれば true.
	#e.g.,
	#	a0 = ['b', 'c', 'a', 'a']
	#	a1 = ['a', 'a', 'b', 'c']
	#	のとき、Mapping::corresponding?( a0, a1 ) #=> true
	def self.corresponding?( left, right )
		return false if ( left.size != right.size )

		l_indices = Mapping::map( left , right ){ |a, b| yield( a, b ) }
		r_indices = Mapping::map( right, left  ){ |a, b| yield( a, b ) }
		#p r_indices; exit
		l_indices.size.times do |i|
			results = []
			return false if l_indices[i].empty? #対応が空のものがあれば false 確定。
			l_indices[i].each do |x| #左の i 番要素は 右へのインデックスの配列なので、それを each
				return false if l_indices[i].size != r_indices[x].size #対応の数が異なれば false。この条件には 右側が空であることも含まれる。
				r_indices[x].each do |y| #対応する右の要素は、左へのインデックスの配列なので、それを each
					results << l_indices[y] #さらに左の要素で、反射して対応する全てが得られる。
				end
			end
			#p results.flatten.uniq
			#p l_indices[i]
			#全部 [] のときも true になっちまう。
			#対応がない場合も考えないとなー。
			#どれか、どちらかが一つでも空対応のときは false でいいか。
			return false if ( results.flatten.uniq != l_indices[i] )
		end
		return true

		#l_hash = Hash.new
		#r_hash = Hash.new
		#left.uniq.each do |i|
		#	l_hash[ i ] = left .select{ |j| yield( i, j ) }.size
		#	r_hash[ i ] = right.select{ |j| yield( i, j ) }.size
		#end
		#p l_hash, r_hash
		#return l_hash == r_hash
	end

	#For instance methods

	#クラスに include されたときに Mapping::corresponding? をクラスメソッドとして使えるようにしたもの。
	def corresponding?( other )
		Mapping::corresponding?( self, other ){ |i, j| yield( i, j ) }
	end

	#自分から引数のコンテナへの写像と考えたときの、対応するインデックスを配列して返す。
	def map_to(other)
		Mapping::map(self, other){ |i, j| yield( i, j ) }
	end

	#引数のコンテナから自分数への写像と考えたときの、対応するインデックスを配列して返す。
	def map_from(other)
		Mapping::map(other, self){ |i, j| yield( i, j ) }
	end

	#引数のコンテナと一対一で対応すれば true, そうでなければ false。
	#自分と比較しても多対多の対応になる可能性があり、その場合は false
	def map?(other)
		Mapping::map?(self, other){ |i, j| yield( i, j ) }
	end

end
