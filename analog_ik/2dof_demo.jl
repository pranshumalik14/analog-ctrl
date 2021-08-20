using Javis
using Colors
using LaTeXStrings

nframes = 1000
η = 25

function ground(args...)
    background(colorant"#FFFBF0") # canvas background
    sethue("black") # pen color
end

function joint(p, color)
    sethue(color)
    circle(p, 20, :fill)
    return p
end

function end_effector(p1, p2, color="gray32")
    sethue(color)
    pr = perpendicular(p2, p1, 10)
    pl = perpendicular(p2, p1, -10)
    setline(3)
    setlinecap("square")
    line(pr, pl, :stroke)
    f1 = perpendicular(pr, pl, -15)
    f2 = perpendicular(pl, pr, 15)
    line(pr, f1, :stroke)
    line(pl, f2, :stroke)
    return p1
end

function base(x, y, color=colorant"rgba(0,0,0,0.6)")
    setcolor(color)
    setmode("atop")
    star(x, y, 20, 3, 0.35, -π/2, :fill)
    return O
end

function path!(points, pos, color)
    sethue(color)
    push!(points, pos) # add pos to points
    circle.(points, 2, :fill) # draws a circle for each point using broadcasting
end

function link(p1, p2, color)
    setcolor(color)
    setmode("atop")
    setline(10)
    setlinecap("round")
    line(p1, p2, :stroke)
end

function draw_end_effector_latex(p1, p2)
    pl = perpendicular(p2, p1, -10)
    p = perpendicular(pl, p2, -15)
    fontsize(15)
    latex(
        L"""E""",
        p,
        :middle,
        :center
    )
end

function draw_arm_config_latex(p1, p2, p3)
    pelb = perpendicular(p2, p3, -10)
    pq2 = perpendicular(pelb, p2, -20)
    pbas = perpendicular(p1, p2, -10)
    pq1 = perpendicular(pbas, p1, -20)
    fontsize(15)
    latex(
        L"""q_2""",
        pq2,
        :middle,
        :center
    )
    latex(
        L"""q_1""",
        pq1,
        :middle,
        :center
    )
end

function info_box_and_goal_pt(video, object, frame)
    fontsize(12)
    sethue("black")
    box(Point(160, 200), Point(240, 230), :stroke)
    circle(Point(185, -125), 5, :fill)
end

function draw_environment_latex(video, action, frame)
    fontsize(15)
    latex(
        L"""B""",
        Point(0, 38),
        :middle,
        :center
    )

    fontsize(20)
    latex(
        L"""\xi_E^*""",
        Point(205, -125),
        :middle,
        :center
    )

    latex(
        L"""\eta=%$η""",
        Point(200, 215),
        :middle,
        :center
    )
end

robot = Video(500, 500)

hand_path = Point[]

Background(1:nframes, ground)
shoulder = Object(1:nframes, (args...)->joint(O, "deepskyblue"), O)
elbow = Object(1:nframes, (args...)->joint(O, "deepskyblue"), Point(150,-40))
act!(elbow, Action(anim_rotate_around(2π, O)))
wrist = Object(1:nframes, (args...)->Point(180,-100))
act!(wrist, Action(anim_rotate_around(η * 2π, 0.0, elbow)))
Object(1:nframes, (args...)->link(pos(elbow), pos(O), colorant"rgba(0,0,0,0.5)"))
Object(1:nframes, (args...)->link(pos(wrist), pos(elbow), colorant"rgba(0,0,0,0.5)"))
Object(1:nframes, (args...)->end_effector(pos(elbow), pos(wrist)))
Object(1:nframes, (args...)->draw_end_effector_latex(pos(elbow), pos(wrist)))
Object(1:nframes, (args...)->draw_arm_config_latex(pos(shoulder), pos(elbow), pos(wrist)))
Object(1:nframes, (args...)->path!(hand_path, pos(wrist), "lightblue"))
Object(1:nframes, (args...)->base(0, 17))
Object(info_box_and_goal_pt)
Object(draw_environment_latex)

render(robot; pathname="analog_ik/2dof_idea_overview.gif")
