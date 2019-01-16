
-- arc

-- Use this function to perform your initial setup
function setup()
    ar = arc(WIDTH/4,HEIGHT/2,400,350,0,180)
    et=0
    shape = Arc{ x = 3* WIDTH/4,
                 y = HEIGHT/2 }
    
    startAngle = 0 
    targetAngle = 0
    parameter.watch( "startAngle" )
    parameter.watch( "targetAngle" )
end

function touched(t)
    fill(t.x,(t.y*t.x)/HEIGHT,t.x-t.y)
    targetAngle = math.atan( t.x-WIDTH/2, t.y-HEIGHT/2 )
end
-- r = radius, mr = radius of inner arc, ang1, ang2 = start/end angles of arc.
function arc(x,y,r,mr,ang1,ang2)
    local arcshader = shader("Documents:Arc Smooth")
    local minr = (mr/r)
    local m = mesh()
    m.shader = arcshader
    m.shader.u_a1 = (ang1)
    m.shader.u_a2 = (ang2)
    local col = color(fill())
    m.shader.u_color = vec4(col.r/255,col.g/255,col.b/255,col.a/255)
    m.shader.u_innerRadius = minr
    m.shader.u_smooth = 1/r
    local rct = m:addRect(x,y,r,r,0)
    return m
end
function draw()
    background(255, 255, 255, 255)
    et=et+0.05
    -- if target and start are more than 180deg apart
    if targetAngle - startAngle > math.pi then
        -- rotate start around the circle
        startAngle = startAngle + 2 * math.pi
    elseif startAngle - targetAngle > math.pi then
        startAngle = startAngle - 2 * math.pi
    end
    
    startAngle = (targetAngle - startAngle)/5 + startAngle
    endAngle = 1 + 5* ( math.cos(ElapsedTime*0.9) + 1)/2 
    thiccness = 100 + 200 * ( math.cos(ElapsedTime*0.9) + 1) / 2
    
    ar = arc(WIDTH/4,HEIGHT/2,400, 200, startAngle, endAngle)
    ar:draw()
    
    shape.arcStart = startAngle
    shape.arcLength = endAngle
    shape.radius = 250 + thiccness/2
    shape.innerRadius = 250 - thiccness/2
    shape:draw()
end