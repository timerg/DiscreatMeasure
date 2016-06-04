using Gadfly
using DataFrames

### Id-Vg
#IdVg_draw = readtable("IdVg", separator=',', header=true)
inputIdVg = readtable("IdVg", separator=',', header=true)

### Concat
a  = readtable("./data/scope_0.csv", separator=',', header=true, skipstart=1)
b  = readtable("./data/scope_2.csv", separator=',', header=true, skipstart=1)
b2 = readtable("./data/scope_3.csv", separator=',', header=true, skipstart=1)
c1 = readtable("./data/scope_4.csv", separator=',', header=true, skipstart=1)
c2 = readtable("./data/scope_5.csv", separator=',', header=true, skipstart=1)
c3 = readtable("./data/scope_6.csv", separator=',', header=true, skipstart=1)
c4 = readtable("./data/scope_7.csv", separator=',', header=true, skipstart=1)
c5 = readtable("./data/scope_8.csv", separator=',', header=true, skipstart=1)
c6 = readtable("./data/scope_9.csv", separator=',', header=true, skipstart=1)
d1 = readtable("./data/scope_10.csv", separator=',', header=true, skipstart=1)
d2 = readtable("./data/scope_11.csv", separator=',', header=true, skipstart=1)
e1 = readtable("./data/scope_12.csv", separator=',', header=true, skipstart=1)
e2 = readtable("./data/scope_13.csv", separator=',', header=true, skipstart=1)

function jointwice(s1, s2)
    vcat(join(s1, s2, on = [:second], kind = :anti), s2)
end



function myConcat(s1, s2...)
    out = jointwice(s1, s2[1])
    if length(s2) <= 1
        return out
    else
        for i = 2:length(s2)
            out = jointwice(out, s2[i])
        end
        return out
    end
end

### RealTime

inpute_ = myConcat(e1, e2)
inpute = inpute_[800:1741, :]

##### need input_time, input_val
# input_v = input_all[:x2]
# input_time = input_all[:x1]
#
Fe = fft(inpute[:Volt])
Fe = fftshift(Fe)
# inpute_f = ./(1, (inpute[:second] - middle(inpute[:second])))
maxfe = round( 1/abs(inpute[:second][2] - inpute[:second][1]))
minfe = 1/(inpute[:second][end] - inpute[:second][1])
inpute_f = [minfe : round((maxfe - minfe)/(length(inpute[:second]) - 1),5) : maxfe]
inpute_all = DataFrame(xf = inpute_f, xt = inpute[:second], F = abs(Fe), T = inpute[:Volt])




plot_f = plot(inpute_all[length(inpute_all[:F])/2 : end, :]
    , x = "xf"
    , y = "F"
    , Geom.line
    # , Scale.x_log10
    , Scale.y_log10
    # , Guide.xticks(ticks = [0:4, 1.781])
    # , Guide.xticks(ticks = [[1, 10, 100, 200, 300, 400, 500], 60])
    )

# plot_IdVg = plot(x = inputIdVg[:Vgs], y = inputIdVg[:Id], Geom.point
#     # ,Scale.y_log10
#     )

plot(inpute, x = "second", y = "Volt", Geom.line)











#