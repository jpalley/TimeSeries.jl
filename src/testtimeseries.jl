macro timeseries()
  println("")
  reload(Pkg.dir("TimeSeries", "run_tests.jl"))
end


function read_csv_for_testing(dir::String, filename::String)
csv = string(dir, "/", filename)
df  = read_table(csv)

(n, kapadoolittle) = size(df)
calarray = CalendarTime[]

for i in 1:n
  push!(calarray, Calendar.parse("yyyy-MM-dd", df[i,1]))
end

within!(df, quote
        Date = $(calarray)
        end)
flipud(df)
end

########### time trial wrapper #####################################

function timetrial(f::Function, v::Any, n::Int)
  p = Float64[]
  for i in 1:n+1
    push!(p, @elapsed f(v))
  end
  mean(p[2:end]) # toss out the first execution from the average
end