
require './LogNormalPdf.rb'

LIM = 20
AVE = ARGV[0].to_f
DIV = ARGV[1].to_f

THR = 32
AVE2 = AVE * 32
DIV2 = ARGV[2].to_f

=begin
# 一様分布のテスト用
a = (LIM / AVE).ceil
r1 = []
srand(10)
(2*a).times do
    r1 << (rand(0.0..DIV) - DIV/2)
end

r2 = []
(2*a).times do
    r2 << (rand(0.0..DIV2) - DIV2/2)
end
#p r
=end

lpdf = LogNormalPdf.new(AVE, DIV)
lpdf.probability
r1 = lpdf.sample

lpdf2 = LogNormalPdf.new(AVE2, DIV2)
lpdf2.probability
r2 = lpdf2.sample

$res = THR
$ret = 0
$mut = Mutex.new
def m_prc(t, st)
    sleep t
    while $res == 0
        # wait
    end
    $ret = $ret + 1
    $mut.lock
    $res = $res - 1
    $mut.unlock
    Thread.new {
        s_thr(st)
    }
end

def s_thr(t)
    sleep(t)
    $mut.lock
    $res = $res + 1
    $mut.unlock
end

count = 0
start_time = Time.now
while (Time.now - start_time) < LIM
    m_prc(r1[count], r2[count])
    count = count + 1
end

puts count
puts $ret

=begin
$ruby main.rb 0.1 0.00 0.01

THR=32

LogNormal
0.01 0.01 189 189
0.10 0.01 189 189
0.01 0.10 185 185
0.10 0.10 184 184
0.20 0.10 178 178
0.10 0.20 183 183
0.20 0.20 178 178
=end
