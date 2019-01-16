Arc = class()
-- Creates an adjustable arc shape on the screen
-- uses mesh() and addRect() to create canvas, 
-- a shader is used to render the arc

function Arc:init (propTable)
    -- Arguments 
    -- x : center of circle                 -- default: WIDTH/2
    -- y : center of circle                 -- default: HEIGHT/2
    -- radius : radius of arc/circle        -- default: ( WIDTH + HEIGHT )/4
    -- innerRadius : inner radius of arc    -- default: ( radius/2 )
    -- arcStart : 0 and 2pi = 12 noon c.w.  -- default: 0
    -- arcLength : 2 pi = full circle       -- default: 0
    -- color :                              -- default: red
    
    -- load passed table
    for key, value in pairs( propTable ) do
        self[ key ] = value
    end

    -- back-fill defaults
    self.x = self.x or WIDTH/2
    self.y = self.y or HEIGHT/2
    self.radius = self.radius or ( WIDTH + HEIGHT )/4
    self.innerRadius = self.innerRadius or self.radius/2
    if self.innerRadius > self.radius then
        -- if innerRadius is larger than radius, shader will not work. 
        self.radius, self.innerRadius = self.innerRadius, self.radius
    end
    self.arcStart = self.arcStart or 0
    self.arcLength = self.arcLength or 0
    self.color = self.color or color( 255, 0, 0, 255 )
    
    -- Calculated Properties:
    -- Create mesh
    self.arcMesh = mesh()
    self.arcRect = self.arcMesh:addRect( self.x, self.y, self.radius * 2, self.radius * 2 )
    --self.arcMesh:setRectColor( self.arcRect, self.color ) -- redundant with u_color. pick one or the other.
    
    -- Define shader and shader properties
    self.arcMesh.shader = shader("Documents:Arc Smooth")
    --[[ is this section redundant? also called in :draw
    self.arcMesh.shader.u_innerRadius = self.innerRadius/self.radius
    self.arcMesh.shader.u_a1 = self.arcStart
    self.arcMesh.shader.u_a2 = self.arcLength
    self.arcMesh.shader.u_color = vec4( self.color.r/255,
                                        self.color.g/255,
                                        self.color.b/255,
                                        self.color.a/255 )
    self.arcMesh.shader.u_smooth = 0 --0.1/self.radius
    --]]
end

function Arc:draw()
    -- Codea does not automatically call this method
    
    -- update shader values 
    self.arcMesh:setRect( self.arcRect, self.x, self.y, self.radius * 2, self.radius * 2 )
    self.arcMesh.shader.u_innerRadius = self.innerRadius/self.radius
    self.arcMesh.shader.u_a1 = self.arcStart
    self.arcMesh.shader.u_a2 = self.arcLength -- can this be negative? define shader params better
    self.arcMesh.shader.u_color = vec4( self.color.r/255,
                                        self.color.g/255,
                                        self.color.b/255,
                                        self.color.a/255 )
    self.arcMesh.shader.u_smooth = 0.9/self.radius 
    
    -- Draw the arc
    self.arcMesh:draw()

end

function Arc:touched(touch)
    -- Codea does not automatically call this method
end

--[[

-- arc

-- Use this function to perform your initial setup
function setup()
    ar = arc(WIDTH/2,HEIGHT/2,400,350,0,180)
    et=0
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
    m.shader.a1 = (ang1)
    m.shader.a2 = (ang2)
    local col = color(fill())
    m.shader.color = vec4(col.r/255,col.g/255,col.b/255,col.a/255)
    m.shader.size = minr
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
    ar = arc(WIDTH/2,HEIGHT/2,400, 200, startAngle, endAngle)
    ar:draw()
end


--]]