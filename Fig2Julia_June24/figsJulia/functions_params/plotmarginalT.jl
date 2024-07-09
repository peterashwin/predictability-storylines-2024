using OrderedCollections
using Plots

function plotmarginalT(mu,plot=true)

    # integrate out other vars than T

    # Assuming μ is your original OrderedDict
    # Initialize an empty dictionary for the sums
    sums = OrderedDict{Int64, Float64}()

    for ((T, x, y, z), value) in mu.vals
        # Accumulate the sum for each T value
        if haskey(sums, T)
            sums[T] += value
        else
            sums[T] = value
        end
    end

    # Extracting x values and their corresponding sums
    x_values = mu.partition.left[1].+collect(keys(sums))./mu.partition.scale[1]
    sum_values = collect(values(sums))./(mu.partition.scale[1]*mu.partition.scale[2]*mu.partition.scale[3]*mu.partition.scale[4])

    # Create a bar plot
    if plot
        bar(x_values, sum_values, xlabel="T (K)", ylabel="μ", legend=false)
    else
        return (x_values, sum_values)
    end

end
