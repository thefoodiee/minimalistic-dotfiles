------------------
--- ANIMATIONS ---
------------------

hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("fastSmooth", { type = "bezier", points = { { 0.2, 0.9 }, { 0.1, 1.0 } } })

hl.animation({
  leaf = "windows", enabled = true, speed = 2, bezier = "fastSmooth"
})

hl.animation({
  leaf = "windowsIn", enabled = true, speed = 2, bezier = "fastSmooth", style = "slide"
})

hl.animation({
  leaf = "windowsOut", enabled = true, speed = 2, bezier = "fastSmooth", style = "slide"
})

hl.animation({
  leaf = "border", enabled = true, speed = 6, bezier = "default"
})

hl.animation({
  leaf = "borderangle", enabled = true, speed = 6, bezier = "default"
})

hl.animation({
  leaf = "fade", enabled = true, speed = 2, bezier = "default"
})

hl.animation({
  leaf = "workspaces", enabled = true, speed = 2, bezier = "fastSmooth", style = "slide"
})
