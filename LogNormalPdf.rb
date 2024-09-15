
class LogNormalPdf
    def initialize(ave, div)
        @div = div
        @ave = Math.log(ave) - @div * @div / 2

        @coef = 1.0 / (@div * Math.sqrt(2 * Math::PI))

        #puts @ave
    end

    def __prob(x)
        coefficient = @coef / x
        exponent = -((Math.log(x) - @ave)**2) / (2 * @div * @div)

        return coefficient * Math.exp(exponent) * 1000
    end

    def probability()
        @ha = []
        @xa = []
        total = 0
        1000.times do |i|
            x = 0.01 * (i + 1)
            @xa << x
            p = [self.__prob(x), 100000].min
            @ha << p
            total = total + p
        end
        
        @rng_l = 0
        @rng_u = 0
        mag = 400 / total
        @ha.map!.with_index { |h, i|
            v = (h * mag).floor
            if v > 0
                if @rng_l == 0
                    @rng_l = (i + 1) * 0.01
                end
                @rng_u = (i + 1) * 0.01
            end
            v
        }

        return @ha
    end

    def sample
        total = @ha.sum
        @smp = []
        ca = Array.new(@ha.length) {0}
        srand(1234)
        while ca.sum < total
            s = rand(@rng_l..(@rng_u + 0.01))
            i = (s / 0.01) - 1
            if  ca[i] < @ha[i]
                ca[i] = ca[i] + 1
                @smp << s
            end
            #puts "(%d: %f)" % [i, s]
            #p ca
            #sleep 0.1
        end

        return @smp
    end

end

#lpdf = LogNormalPdf.new(0.1, 0.001)
#lpdf.probability
#p lpdf.sample
