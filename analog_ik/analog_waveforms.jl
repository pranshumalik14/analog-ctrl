using Plots
using Colors

x = collect(1:0.1:30)
df = 2

# sine
y = sin.(x)
anim = @animate for i = 15:df:length(x)
    plot(x[1:i], y[1:i], legend=false; showaxis=false, grid=false, ticks=false,
        background_color=colorant"#FFFBF0")
end
gif(anim, "analog_ik/sine.gif"; fps=30);

# sawtooth
p = 6
y = 2/p .* x .- 2 .* floor.(1/2 .+ (1/p .* x))
anim = @animate for i = 50:df:length(x)
    plot(x[1:i], y[1:i], legend=false; showaxis=false, grid=false, ticks=false,
        background_color=colorant"#FFFBF0")
end
gif(anim, "analog_ik/sawtooth.gif"; fps=30);

# triangle
p = 6
y = 2 .* abs.(2/p .* x .- 2 .* floor.(1/2 .+ (1/p .* x))) .- 1
anim = @animate for i = 50:df:length(x)
    plot(x[1:i], y[1:i], legend=false; showaxis=false, grid=false, ticks=false,
        background_color=colorant"#FFFBF0")
end
gif(anim, "analog_ik/triangle.gif"; fps=30);
