#要素を分類する。
#
#USAGE:
#	基本的に、対象の Array に extend して使う。e.g.,
#		arr = [ -2, -1, 0, 1, 2, 1]
#		arr.extend( Categorize )
#		arr.categorize #=> [ [-2], [-1], [0], [1, 1], [2] ],
#		arr.categorize{ |a, b| a.abs == b.abs } #=> [ [-2, 2], [-1, 1, 1], [0] ]
#
#対象とするオブジェクトは、
#「AとBが等価 かつ BとCが等価」と判定されたなら「AとCが等価」であることを前提としている。
#たとえば、Float の近似判定のような場合にはうまくいかない可能性がある。
#	a = 0.01
#	b = 0.03
#	c = 0.05
#	a.equal_in_delta?( b, 0.03 ) => true
#	b.equal_in_delta?( c, 0.03 ) => true
#	c.equal_in_delta?( a, 0.03 ) => false
#
#生の配列で持っておいて必要なときに条件を渡されれば分類されたデータを返すという方式を採用。
#	条件設定が柔軟で、オブジェクトの状態がシンプルで開発し易い。
#	データが追加( initialize, push ) されるたびに適切なところに入れるという方式は、( push が速いかも？ )不適と判断した。
#
module Categorize
	#分類する。
	#等価判定が真になるもの同士で Array にまとめ、それらをまとめた 2重配列として返す。
	#ブロックを渡された場合には、ブロックの条件で等価判定する。
	#返り値の2重配列は、各カテゴリ内で元データの最も先頭に近かったデータの順番でソートされたものになる。
	#e.g., [ 0, 1, 2, 1] ならば、[ [0], [1, 1], [2] ] のようになる。
	def categorize
		result = []
		self.each do |item|
			contained = nil #該当する category の Array 内 id
			result.each_with_index do |category, i|
				#category[0] と比較。
				if block_given? #ブロックを渡されていたら
					#そのブロックで等価判定
					contained = i if yield( category[0], item )
				else
					#uniq と同じように eql? を使う
					contained = i if category[0].eql?( item )
				end
				if contained
					break
				end
			end
			if contained
				result[contained] << item
			else
				result << [item]
			end
		end
		return result
	end
end

