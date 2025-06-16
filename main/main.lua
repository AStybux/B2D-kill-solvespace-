local display, timer = display, timer

display.setStatusBar( display.HiddenStatusBar )

local mg={}
mg.x = display.newGroup()
mg.x.x = display.contentCenterX
mg.x.y = display.contentCenterY

mg.y = display.newGroup()
mg.y.x = display.contentCenterX
mg.y.y = display.contentCenterY

mg.px = mg.x.parent
mg.py = mg.y.parent
mg.px.x=mg.x.x
mg.py.y=mg.y.y

mg.fp = display.newGroup()
mg.fp.x = 0
mg.fp.y = 0

mg.cp = display.newGroup()
mg.cp.x = 0
mg.cp.y = 0

local xy_w={}
xy_w.x1=-150
xy_w.x2=150
xy_w.y1=-250
xy_w.y2=250
xy_w.o=16
xy_w.t=8

-- функция для рисования прямой
local function drawLineX(k, b, n, c)
    local b = -b*xy_w.o
    local k = -k
    local x1 = xy_w.x1
    local x2 = xy_w.x2
    local y1 = k * x1 + b
    local y2 = k * x2 + b
    local line = display.newLine(mg.px, x1,y1,x2,y2)
    mg.px:insert(n,line)
    line:setStrokeColor(c[1]/256, c[2]/256, c[3]/256)
    line.strokeWidth = xy_w.t
end

local function drawLineY(k, b,n, c)
    local b = -b*xy_w.o
    local y1 = xy_w.y1
    local y2 = xy_w.y2
    local x1 = k * y1 + b
    local x2 = k * y2 + b
    local line = display.newLine(mg.y, x1,y1,x2,y2)
    line:setStrokeColor(c[1]/256, c[2]/256, c[3]/256)
    mg.py:insert(n,line)
    line.strokeWidth = xy_w.t
end

local function drawParabola(a, b, c, color)
    a,b,c=-a,b*xy_w.o,-c*xy_w.o
    local step = 0.1
    for x = xy_w.x1, xy_w.x2, step do
        local y = a * x^2 + b * x + c
        if y >= xy_w.y1 and y <= xy_w.y2 then
            local point = display.newCircle(mg.fp, x, y, 2)
            point.strokeWidth = xy_w.t
            point:setStrokeColor(color[1]/256, color[2]/256, color[3]/256)
        end
    end
end

local function drawCircle(a, b, r, color)
    b=b*xy_w.o
    local step = 0.1
    for angle = 0, 2 * math.pi, step do
        local x = r * math.cos(angle) + a
        local y = r * math.sin(angle) + b
        local point = display.newCircle(mg.cp, x, y, 2)
        point.strokeWidth = xy_w.t
        point:setStrokeColor(color[1]/256, color[2]/256, color[3]/256)
    end
end

-- рисуем несколько прямых

-- drawLineX(1, -5, 2, {214, 238, 230})
-- drawLineX(-1, 5, 3, {89, 117, 206})
drawLineX(1, 10, 4, {208, 70, 72})
-- drawLineX(-1, -5, 5, {44, 170, 105})

-- рисуем несколько парабол

drawParabola(-0.5, 1, -15, {89, 117, 206})
-- drawParabola(0.05, 0, 5, {214, 238, 230})

-- рисуем несколько окружностей
drawCircle(0, -2, 50, {44, 170, 105})
-- drawCircle(0, 0, 20, {89, 117, 206})

-- рисуем координатную плоскость 
drawLineX(0, 0, 1, {78, 74, 78})
drawLineY(0, 0, 1,{78, 74, 78})

local function hsvtoTRgb(h, s, v)
    local r, g, b
    local i = math.floor(h / 60)
    local f = h / 60 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end
    return r, g, b
end

local function changeColor()
    local hue = 0
    local saturation = 1
    local value = 1
    local step = 1

    local function changeColorInner()
        for i = 1, mg.fp.numChildren do
            local child = mg.fp[i]
            local r, g, b = hsvtoTRgb(hue, saturation, value)
            child:setStrokeColor(r, g, b)
        end
        for i = 1, mg.cp.numChildren do
            local child = mg.cp[i]
            local r, g, b = hsvtoTRgb(hue, saturation, value)
            child:setStrokeColor(r, g, b)
        end
        for i = 1, mg.px.numChildren do
            local child = mg.px[i]
            if child and child.setStrokeColor and i ~= 1 and i ~= 2 then
                local r, g, b = hsvtoTRgb(hue, saturation, value)
                child:setStrokeColor(r, g, b)
            end
        end
        hue = (hue + step) % 360
        if hue == 0 then step = -step end
        if hue == 240 then step = -step end
    end
    timer.performWithDelay(1, changeColorInner, 0)
end

changeColor() -- запустить функцию