using Gadfly
using DataFrames

### Id-Vg
#IdVg_draw = readtable("IdVg", separator=',', header=true)
inputIdVg = readtable("IdVg", separator=',', header=true)

### Concat
a = readtable("testa.csv", separator=',', header=false)
b = readtable("testb.csv", separator=',', header=false)
c = readtable("testc.csv", separator=',', header=false)
d = readtable("testd.csv", separator=',', header=false)


function jointwice(s1, s2)
    vcat(join(s1, s2, on = [:x1], kind = :anti), s2)
end


function myConcat(s1, s2, s3...)

    out = jointwice(s1, s2)
    if length(s3) <= 1
        out = jointwice(out, s3[1])
    else
        for i = 1:length(s3)
            out = jointwice(out, s3[i])
        end
    end
    return out
end
### RealTime
input_all = myConcat(a, b, c, d)

##### need input_time, input_val
input_v = input_all[:x2]
input_time = input_all[:x1]

F = fft(input_v)
F = fftshift(F)
input_f = ./(1, (input_time - middle(input_time)))
input = DataFrame(xf = input_f, xt = input_time, F = abs(F), T = input_v)




plot_f = plot(input, x = collect(1:length(input[:xf])), y = "F"
    , Geom.line, Geom.point
    , Scale.x_log10)

plot_IdVg = plot(x = inputIdVg[:Vgs], y = inputIdVg[:Id], Geom.point
    # ,Scale.y_log10
    )










#