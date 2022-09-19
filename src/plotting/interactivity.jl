function enable_cursor!(fig, plot)
    cursor1 = GLFW.CreateStandardCursor(GLFW.CROSSHAIR_CURSOR)
    screen = display(fig)
    window = GLMakie.to_native(screen)
    # set to crosshair cursor when hovering over scatterplot point
    on(events(fig).mouseposition; priority=2) do event
        if mouseover(fig, plot)
            GLFW.SetCursor(window, cursor1)
        else 
            GLFW.SetCursor(window, nothing)
        end
        return Consume(false)
    end
end

function add_controls!(fig, observables)
    sg = SliderGrid(fig[2, 1],
        (label = "σ, covariance scale", range = 0.01:0.01:5, startvalue = observables.σ[]),
        (label = "ℓ, length scale", range = 0.01:0.01:5, startvalue = observables.ℓ[])
    )

    on(sg.sliders[1].value) do val
        observables.σ[] = val
    end

    on(sg.sliders[2].value) do val
        observables.ℓ[] = val
    end

    # change mean function with textbox
    # tb = Textbox(fig[3,1], placeholder = "Specify a mean function", width=500)
    # colsize!(fig.layout, 1, Relative(1))
    # on(tb.stored_string) do s
    #     if isnothing(s)
    #         observables.mean[] = nothing
    #     else
    #         observables.mean[] = Meta.parse(s)
    #     end
    #     notify(observables.mean)
    # end
end

function enable_interactivity!(fig, ax, plot, observables)
    Makie.deactivate_interaction!(ax, :rectanglezoom)
    enable_cursor!(fig, plot)
    add_controls!(fig, observables)
    on(events(fig).keyboardbutton; priority=1) do event
        if mouseover(fig, plot)
            plt, i = pick(fig)
            # delete marker
            if event.key == Keyboard.d
                deleteat!(observables.positions[], i)
                notify(observables.positions)
                return Consume(true)
            # widen error bar
            elseif event.key == Keyboard.w
                val = observables.positions[][i][2] |> value 
                err = observables.positions[][i][2] |> uncertainty
                observables.positions[][i] = Point2(observables.positions[][i][1], measurement(val, 0.005+err*1.02))
                notify(observables.positions)
                return Consume(true)
            # narrow error bar
            elseif event.key == Keyboard.s
                val = observables.positions[][i][2] |> value 
                err = observables.positions[][i][2] |> uncertainty
                observables.positions[][i] = Point2(observables.positions[][i][1], measurement(val, err*0.95))
                notify(observables.positions)
                return Consume(true)
            end
        # Add marker
        elseif event.key == Keyboard.a
            push!(observables.positions[], mouseposition(ax))
            notify(observables.positions)
            return Consume(true)
        end
        return Consume(false)
    end
end