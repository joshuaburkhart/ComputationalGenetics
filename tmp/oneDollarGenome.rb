#usage: $ jruby oneDollarGenome.rb 760 100

$x = Float(ARGV[0])
$n = Float(ARGV[1])

#x: number of unique reads seen
#n: number of reads needed to cover genome
def f(x)
    if x == 1
        return 1
    else
        cur_prob = f(x - 1)
        pre_prob = ($n - cur_prob)/$n
        return pre_prob + cur_prob
    end
end

def f_iter(x)
    cur_prob = 0
    0..$n.each{|i|
        pre_prob = 0
        0..i.each{
            pre_prob += ($n - cur_prob) / $n
        }
        cur_prob 
    }
end

puts f($x)
