local SimpleShindoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/theyneverfoundthebody/celex-ui-lib/main/lib-source.lua"))()

local Main = SimpleShindoUi:new()

local Tab = Main:Tab('Centerhub')

local page = Main:Page()

Main:Toggle(page, 'Toggle!', false, function(t)
    print(t)
end)

Main:Button(page, 'Button!', function()
    print('Button clicked!')
end)

Main:Slider(page, 'Slider!', 1, 100, 20, function(t)
    print(t)
end)
