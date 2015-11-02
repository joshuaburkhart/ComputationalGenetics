# usage: $ ruby | jruby oneDollarGenome.rb <x> <n>
# x = number of unique reads seen
# n = number of reads needed to cover genome
# returns average number of unique reads seen (assuming uniform distribution)

# example: $ jruby oneDollarGenome.rb 760 100

$x = Float(ARGV[0])
$n = Float(ARGV[1])


# recursive: (orig): overflows
def f(x)
    if x == 1
        return 1.0
    else
        cur_prob = f(x - 1)
        pre_prob = ($n - cur_prob)/$n
        return pre_prob + cur_prob
    end
end

# iterative (dev): should match orig
def f_iter(x)
    cur_prob = 1.0
    for i in 2..$x do
        cur_prob += ($n - cur_prob)/$n
    end
    return cur_prob
end

r_ret = 1#f($x)
i_ret = f_iter($x)
puts "Avg. Coverage = #{(100 * ($x/$n)).round() / 100.0}"
puts "R: #{(100 * r_ret).round() / 100.0} \
(#{(10000 * (r_ret/$n)).round() / 100.0}%)"
puts "I: #{(100 * i_ret).round() / 100.0} \
(#{(10000 * (i_ret/$n)).round() / 100.0}%) \
Error = #{(100 * (i_ret - r_ret))/100.0}"
