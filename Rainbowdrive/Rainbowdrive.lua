--[[Credits:
	Kiisseli - original ideas
	DBN - DBN_assets, color palette randomizer, mod documentation, and addEntropy function
	Epikas Jones - Original HexSphere mesh
	Nova - Original Nova color palette
]]

--  USER SETTINGS  --
palette_setting = 0 -- 0 = random, 1-8 for specific palette, else for Album Art
grid_setting = 1 -- 0 = random, 1-2 for specific shader
ghost_ship_setting = true -- true for ghost ship, false for solid ship
--END USER SETTINGS--

--   LOAD ASSETS   --
customillumindiffuse = AssetBundles.hyperdriveproject:LoadAsset('Assets/DBN_Assets/IlluminDiffuse_B.shader')
customunlitedgedblock = AssetBundles.hyperdriveproject:LoadAsset('Assets/Shaders/UnlitEdgedBlock2.shader')
--END ASSET LOADING--

jumping = PlayerCanJump()
function fif(test, if_true, if_false)
  if test then return if_true else return if_false end
end

hifi = GetQualityLevel() > 2 -- GetQualityLevel returns 1,2,or 3
function ifhifi(if_true, if_false)
  if hifi then return if_true else return if_false end
end

quality = GetQualityLevel4()
function ByQuality4(low,med,high,ultra)
	if quality < 2 then return low
	elseif quality <3 then return med
	elseif quality <4 then return high
	else return ultra end
end

track = GetTrack()--get the track data from the game engine
white = {1, 1, 1}
function greyscale(amount, alpha) return {amount,amount,amount,alpha} end -- can omit alpha

skinvars = GetSkinProperties()
trackWidth = skinvars["trackwidth"]
--trackWidth = 11.5 -- uses a wide water track even for vehicles
fullsteep = jumping or skinvars.prefersteep

do
	local entropy = math.random(9000000) -- keep the song-based entropy AS2 is giving us

	local function addEntropy(seed)
			if seed == nil then
					seed = math.random(9000000)
			elseif type(seed) ~= "number" then
					if type(seed) ~= "string" then seed = tostring(seed) end -- for functions and tables this will use their raw memory address for entropy
					if seed == "" then seed = "12" end
					local numbers = {string.byte(seed, 1, #seed)}
					seed = 0
					for i=1,#numbers do seed = seed + numbers[i] end
			end
			entropy = entropy + seed
	end

	-- if only it were that easy!
	if type(os) == "table" and type(os.time) == "function" then
			addEntropy(os.time())
	end

	-- this is fun, finding things to throw into the shredder
	addEntropy(collectgarbage("count") * 1024)
	addEntropy({})
	addEntropy(addEntropy)
	addEntropy(BatchRenderEveryFrame)
	local skinvars = GetSkinProperties()
	addEntropy(skinvars)
	for k, v in pairs(skinvars) do
			addEntropy(k)
			addEntropy(v)
			if type(v) == "table" then
					local success, result = pcall(table.concat, v)
					addEntropy(result)
			end
	end

	-- "math.randomseed will call the underlying C function srand which takes an unsigned integer value"
	local UINT_MAX = 4294967295
	while entropy > UINT_MAX do entropy = entropy - UINT_MAX end
	while entropy < 0 do entropy = entropy + UINT_MAX end

	print("rng seed: " .. entropy)
	math.randomseed(entropy)
end

SetScene{
	ambientlight = "highwayinverted",
	glowpasses = ifhifi(4,1),
	glowspread = ifhifi(1,0.5),
	radialblur_strength = 2,
	watertype = 1,
	water = jumping, --only use the water cubes in wakeboard mode
	--watertint = {r=255,g=255,b=255,a=11},
	watertint = {r=255,g=255,b=255,a=255},
	--watertint_highway = true,
	--watertexture = "WaterCubesBlue_BlackTop_WhiteLowerTier.png",--waterBW.png",
	watertexture = "WaterCubesBlue_BlackTop_WhiteLowerTier.png",
	widewater = false, --sets water to 16.25 width
	towropes = jumping,--use the tow ropes if jumping
	airdebris_count = 1500,
	airdebris_density = 60,
	airdebris_texture = ifhifi ("Hexagon128_2.png","Hexagon128_2.png"),
	--airdebris_particlesize = 1,
	airdebris_fieldsize = 500,
	--airdebris_layer = 13,
	useblackgrid=false,
	crease_strength=ifhifi(-47,0),
	closecam_near=.05,
	closecam_far=22 --bringing this in closer than the default (50) improves the ship's shadow quality
	--twistmode={curvescaler=1, steepscaler=.1} -- note: "cork" is the same as {curvescaler=1, steepscaler=1} and "cork_flatish" is the same as {curvescaler=1, steepscaler=.4}
}

--LoadSounds{
--	hit="hit.wav",
--	hitgrey="hitgrey.wav",
--	trickfail="hitgrey.wav",
--	matchsmall="matchsmall.wav",
--	matchmedium="matchmedium.wav",
--	matchlarge="matchlarge.wav",
--	matchhuge="matchhuge.wav",
--	overfillwarning="overfillwarning.wav"
--}

if jumping then
	SetPlayer{
		--showsurfer = true,
		--showboard = true,
		cameramode = "first_jumpthird",
		--cameramode = "first",
		--cameramode_air = "third",--"first_jumptrickthird", --start in first, go to third for jumps and tricks

		camfirst={ --sets the camera position when in first person mode. Can change this while the game is running.
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 1
		},
		camthird={ --sets the two camera positions for 3rd person mode. lerps out towards pos2 when the song is less intense
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 0.75,
			pos2={0,2.8,-3.50475},
			rot2={20.49113,0,0},
			strafefactorFar = 1},
		surfer={ --set all the models used to represent the surfer
			arms={
				--mesh="arm.obj",
				shader="RimLightHatchedSurfer",
				shadercolors={
					_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=6, param="_Threshold", paramMin=2, paramMax=2},
					_RimColor={0,63,192}
				},
				texture="FullLeftArm_1024_wAO.png"
			},
			board={
				--mesh="wakeboard.obj",
				shader=ifhifi("RimLightHatchedSurferExternal","VertexColorUnlitTinted"), -- don't use the transparency shader in lofi mode. less fillrate needed that way
				renderqueue=3999,
				shadercolors={ --each color in the shader can be set to a static color, or change every frame like the arm model above
					_Color={colorsource="highway", scaletype="intensity", minscaler=5, maxscaler=5},
					_RimColor={0,0,0}
				},
				shadersettings={
					_Threshold=11
				},
				texture="board_internalOutline.png"
			},
			body={
				--mesh="surferbot.obj",
				shader="RimLightHatchedSurferExternal", -- don't use the transparency shader in lofi mode. less fillrate needed that way
				renderqueue=3000,
				shadercolors={
					_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3},
					_RimColor={0,0,0}
				},
				shadersettings={
					_Threshold=1.7
				},
				texture="robot_HighContrast.png"
			}
		}
	}
else
	local shipMesh = BuildMesh{
		mesh="racingship_scaled75.obj",
		--mesh="ninjamono.obj",
		barycentricTangents = true, --for use with wireframe shaders
		--calculateTangents = true,
		calculateNormals = true,
		submeshesWhenCombining = false
	}

	shipMaterial = BuildMaterial{
		renderqueue = 2000,
		--shader="UnlitTintedTexGlowWire",
		shader = fif(ghost_ship_setting,"VertexColorUnlitTintedAddSmooth","MatCap/Vertex/PlainBrightGlow"),
		--shader = "MatCap/Vertex/PlainBrightGlow",
		shadersettings={_GlowScaler=9, _Brightness=.66},
		shadercolors={
			_Color = fif(ghost_ship_setting,{100,100,100},{colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1}),
			_SpecColor = fif(ghost_ship_setting,{colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=2},nil),
			_GlowColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=2},
			},
		textures = fif(ghost_ship_setting,{_MatCap="matcapchrome.jpg", _Glow="maintex_darkerNeg170_highlights.png"},{_MatCap="matcapchrome.jpg", _Glow="glowBWj1.png"}),
	}

	vehicleTable={
		min_hover_height= 0.11,
		max_hover_height = 1.4,
		use_water_rooster = false,
		smooth_tilting = false,
		smooth_tilting_speed = 10,
		smooth_tilting_max_offset = -20,
		pos={x=0,y=0,z=0},
		--scale={x=.75, y=.75, z=.75},

		mesh = shipMesh,--built with BuildMesh above
		--materials = {shipMaterial}, --assign the pre-created material
		material = shipMaterial,
		reflect = false,
		--mesh="racingship.obj",
		--calculateTangents = true,
		--calculateNormals = false,
		--submeshesWhenCombining = false,
		layer = 15,
--			renderqueue = 2000,
--			shader="SelfGlowBumpSpec2_compiled.shader",
--			shadersettings={_Shininess=0.1, _GlowScaler=9},
--			shadercolors={
--				_Color = {colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1},
--				_SpecColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1},
--				_GlowColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1}
--				},
--			textures={_MainTex="maintex_darkerNeg170_highlights.png", _BumpMap="normal.png", _Glow="glowBW.png"},
		scale = {x=1,y=1,z=1},
		thrusters = {crossSectionShape={{-.35,-.35,0},{-.5,0,0},{-.35,.35,0},{0,.5,0},{.35,.35,0},{.5,0,0},{.35,-.35,0}},
					perShapeNodeColorScalers={.5,1,1,1,1,1,.5},
					shader="TransparentShadowCaster",
					layer = 14,
					renderqueue = 3000,
					colorscaler = {close=2.5, far=0},
					sizefalloff = 1,
					minrenderedsize = 0.05,
					extrusions=25,
					stretch=-0.1191,
					updateseconds = 0.025,
					instances={
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.6,0.6,0.6}},
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.45,0.45,0.8}},
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.3,0.3,0.8}},
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.1,0.1,0.8}},

						{pos={0.31,0.28,-1.64},rot={0,0,0},scale={0.3,0.3,0.66}},
						{pos={0.31,0.28,-1.64},rot={0,0,0},scale={0.1,0.1,0.66}},

						{pos={-0.25,0.28,-1.64},rot={0,0,0},scale={0.3,0.3,0.66}},
						{pos={-0.25,0.28,-1.64},rot={0,0,0},scale={0.1,0.1,0.66}}
					}}
	}

	SetPlayer{
		--showsurfer = false,
		--showboard = false,
		cameramode = "third",
	--	cameramode_air = "first",--"first_jumptrickthird", --start in first, go to third for jumps and tricks

		camfirst={
			pos={0,1.84,-0.8},
			rot={20,0,0}},
		camthird={
			pos={0,2.5,-1.5},								--[0 2 -0.5]
			rot={22,0,0},								--[30 0 0]
			strafefactor = .77,							--[.75]
			pos2={0,5,-4},								--[0 5 -4] 
			rot2={30,0,0},								--[30 0 0]
			strafefactorFar = 1,
			transitionspeed = 1,
			puzzleoffset=-0.65,
			puzzleoffset2=-1.5},
		vehicle=vehicleTable
	}
end

if grid_setting ~= 1 and grid_setting ~= 2 then 
	grid_setting = math.random(1,2)
end
function skybox_chooser(setting1, setting2) 
	if grid_setting == 1 then return setting1
	elseif grid_setting == 2 then return setting2 end
end
if hifi then SetSkybox{
		skyscreen = skybox_chooser("Skyscreen/TheGrid","Skyscreen/TheGridSky"),
		layer=18
	}
end

track_colors_choices = {
{										--Waltz 1
{0,0,0},
    {200,10,40}, --hot magenta
    {200,18,100},--magenta
{0,0,0},
    {200,30,100},--purple
	--{250,43,239},--Rose Fuchsia
	{31,94,86}, --ocean green
    {200,20,190},--purple
    {25,25,112},--blue
    {100,15,200},--dark purple
    {39,45,200},--another blue
    {0,183,104},--seafoam green
    {12,20,122},--dark blue
},
{										--Burning Skies 2
{0,0,0},
    {200,30,15}, --red orange
    {246,159,15},--orange
    {200,10,40}, --hot magenta
{0,0,0},
    {200,30,100},--purple
    {25,25,112},--blue
	{9,112,66},--dark green
    {100,15,200},--dark purple
    {26,30,133},--another blue
    --{18,128,87},--seafoam green
	{153,11,77}, --some magenta
    {200,30,15},--cool red
{0,0,0},
},

{										--Nova 3
{0,0,0},
	{128,16,96}, --magenta
	{69,13,96},--black magenta
    {3,37,77},--deep blue
	{0,30,100},--less deep blue
    {0,60,130},--deep blue
    {140,20,20}, --crimson
    {104,0,148},--dark magenta
	{25,40,150},
	{25,50,112}, --dark navy
    {4,60,198},--bright blue
	{75,2,130},
},
{										--Inferno 4
{0,0,0},
	{50,50,50}, --dark grey
	--{90,90,90}, --grey
	{37,13,126}, --dark purple
	{105,0,22}, --dark maroon
	{163,16,44}, --maroon
	{50,0,5}, --black red
	{100,0,10}, --dark red
	{58,16,61}, --dark violet
{0,0,0},
	{100,0,10}, --dark red
	{245,77,22}, --orange
},
{										--Galaxy 5
{0,0,0},
	{220,20,40}, --red
	{248,70,49}, --orange red
    {219,46,104}, --magenta
    --{248,70,49}, --orange red
    {94,6,64}, --midnight satin
	{216,67,21}, --pure light
    {28,26,84}, --deep blue
    {1,1,5}, --deep black
},
{										--Magic 6
{0,0,0},
	{14,115,51},--green
    --{84,9,105},--purple
    {25,25,112}, --dark violet
    --{182,134,24},--yelloworange
	{84,9,105},--purple
	{220,20,20}, --crimson
{0,0,0},
	{128,5,5}, --maroon
    {255,69,0},--orange
    {0,8,79},--blue
	{12,149,203},--light blue
},
{										--Adrenalin 7
{0,0,0},
	{12,10,87}, --very dark blue
	{0,87,37}, --dark green
	{124,164,8}, --yellow
	{153,21,21}, --dark red
	{207,138,10}, --orange
	{160,5,5}, --crimson
	{247,57,57}, --bright red
	{12,10,87}, --very dark blue
	--{194,194,8}, --yellow
	{153,21,21}, --dark red
	{207,138,10}, --orange
	{160,5,5}, --crimson
	{247,57,57}, --bright red
},
}

if skinvars.colorcount > 5 then
	blockColors={
    {r=0, g=0, b=0},
    --{r=75, g=0, b=130},
    --{r=0, g=0, b=205},
    {r=50, g=205, b=50},
    {r=255, g=160, b=0},
    {r=255,g=0,b=0},
	{r=255,g=255,b=255}
	}
end

if palette_setting >= 1 and palette_setting <= 8 then
	track_colors_index = palette_setting
else
	track_colors_index = math.random(#track_colors_choices)
end
track_colors = track_colors_choices[track_colors_index]
SetTrackColors(track_colors)
palette_names = {"Waltz", "Burning Skies", "Nova", "Inferno", "Galaxy", "Magic", "Adrenalin"}
palette_index = palette_names[track_colors_index]
-- [track_colors_index] can be replaced with [#] to force a color palette
print("                                        " .. palette_index)
print("Random Track Color Palette: #" .. track_colors_index)

--]]
--SetBlockColors{ --this is only used for puzzle modes (which you don't have yet) with multiple colors of blocks
--    {r=93, g=8, b=132},
--	{r=1.0, g=0.27, b=0.2},
--    {r=0.047, g=0.5098, b=0.94},
--    {r=1.0, g=0.85, b=0.4157},
--	{r=0, g=0.29, b=0.08},
--    {r=1,g=0,b=0}
--}

starMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = true,
				barycentricTangents = true,
				meshes={"hexsphere/hexx_baseline.obj", "hexsphere/hexx4.obj", "hexsphere/hexx01.obj", "hexsphere/hexx02.obj", "hexsphere/hexx03.obj"}
			}	
			
spikeMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = true,
				barycentricTangents = true,
				meshes={"wallmorph_baseline.obj", "wallmorph0.obj", "wallmorph1.obj", "wallmorph2.obj", "wallmorph3.obj", "wallmorph4.obj"}
			}

pyrtopMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = false,
				barycentricTangents = true,
				--meshes={"pyramidtop.obj", "pyramidtop.obj", "pyramidtop.obj", "pyramidtop.obj", "pyramidtop.obj", "pyramidtop.obj"}
				meshes={"Pyramids/pyramidtop.obj", "Pyramids/pyramidtop.obj"}
			}

pyrbotMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = false,
				barycentricTangents = true,
				--meshes={"pyramidbot.obj", "pyramidbot.obj", "pyramidbot.obj", "pyramidbot.obj", "pyramidbot.obj", "pyramidbot.obj"}
				meshes={"Pyramids/pyramidbot.obj", "Pyramids/pyramidbot.obj"}
			}

if not jumping then
	SetBlocks{
		maxvisiblecount = 200, -- fif(skinvars.minvisibleblocks, math.max(200, skinvars.minvisibleblocks), 200),
		colorblocks={
			mesh = "DBN_assets/block3.obj",
			shader = customunlitedgedblock,
				shadercolors = {
					_Color = {colorsource={1,1,1,1}, scaletype="intensity", minscaler=4, maxscaler=4},
					_Brightness = 1,
					_AlphaGlowTint = 2/3,
					_RimColor = {1,1,1,1},
					_BorderSize = {-1,1},
					_BorderColor = "white",
					_BorderAdd = {1,1,1,1}, -- higher contrast in trackless mode
					_BorderMult = 1/4,
				},
			shadersettings = fif(hifi, {_Brightness=4.0}, {_Brightness=5.5}),
			textures = {
				_MainTex="DBN_assets/Block3UVdark1.png", 
				--_MatCap="DBN_assets/BlockUV.png",
			},
		    height = 0,
		    float_on_water = false,
		    scale = {1,1,1},
		    reflect = false
		},
		greyblocks={
			mesh = spikeMesh,--"doublespike.obj",
			shader = "MatCap/Vertex/PlainBrightWireGrey", -- "MatCap/Vertex/PlainBright", --"MatCap/Vertex/PlainBrightWireWhite",
			shadersettings = fif(hifi, {_Brightness=4.0}, {_Brightness=5}),
			textures = {_MainTex="White.png", _MatCap="matcapchrome.jpg"},
			--height = 0,
			shadercolors= {_Color={colorsource="highwayinverted", scaletype="intensity", minscaler=2, maxscaler=2.5}},
			reflect = false
		},
		powerups={--override the following objects in case the mod uses them
			powerpellet={
			mesh = starMesh,
				shader = "RimLight",
				textures={_MainTex="hexsphere/hexx_Color_4.png", _BumpMap="hexsphere/hexx_Normal_4.png", _MatCap="matcapchrome.jpg", _Glow="hexsphere/hexx_Color_4.png"},
				--shadersettings = {_Outter=.1,_Inner = 5},
				shadersettings = fif(hifi, {_Brightness=10}, {_Brightness=5}),
			shadercolors={
				_Color = {255,255,255},
				--_RimColor={0,0,0},
			},
			height = 0,
			scale = {.01,.01,.01},
			}

		},
		chainspans={
			material = chainspanMaterial
			--renderqueue = 3033,
			--shader = "VertexColorUnlitTintedAdd"
		}

	}
end

SetPuzzleGraphics{
	usesublayerclone = false,
	puzzlematchmaterial = {shader="VertexColorUnlitTintedAlpha",texture="tileMatchingBars.png"},
	puzzleflyupmaterial = {shader="VertexColorUnlitTintedAddFlyup",texture="tileMatchingBars.png"},
	puzzlematerial = {shader="VertexColorUnlitTintedAlpha2",texture="tilesSquare.png",texturewrap="clamp", usemipmaps="false",
	shadercolors={_Color = {colorsource={1,1,1,1}, scaletype="intensity", minscaler=1.0, maxscaler=1.5}}}
}

SetRings{ --setup the tracks tunnel rings. the airtexture is the tunnel used when you're up in a jump
	texture="ringOnTop_2.png",
	shader="VertexColorUnlitTintedAddSmooth",
	size=22,
	percentringed=.2,--ifhifi(2,.01),-- .2,
	airtexture="ringOnTop_2.png",
	airshader="VertexColorUnlitTintedAddSmooth",
	airsize=24,
	colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=2
}

if jumping then wakeHeight=(ifhifi(4,2)) else wakeHeight = 1.9 end
--wakeHeight=1.9 --(ifhifi(4,2))
extraWidth = trackWidth - 5
if jumping then extraWidth = 0 end
wakeStrafe = 7.5 + extraWidth
SetWake{ --setup the spray coming from the two pulling "boats"
	height = wakeHeight,
	fallrate = 0.965,
	offsets = {{wakeStrafe,0,0}, {-wakeStrafe,0,0}},
	--strafe = wakeStrafe,
	shader = "VertexColorUnlitTintedAddSmooth",
	layer = 13, -- looks better not rendered in background when water surface is not type 2
	bottomcolor = {r=0,g=0,b=0},
	topcolor = {colorsource="highway", scaletype="intensity", minscaler=0.5, maxscaler=1.5}
}

CreateObject{
	name="EndCookie",
	tracknode="end",
	gameobject={
		transform={pos={0,0,126},scale={scaletype="intensity",min={55,99,900},max={66,120,900}}},
		mesh="danishCookie_boxes.obj",
		shader="VertexColorUnlitTintedAdd",
		shadercolors={
			_Color="highway"
		}
	}
}


hexNodes_Zone = {}
pyrtopNodes_Zone = {}
pyrbotNodes_Zone = {}

hexOffsets_Zone = {}
pyrtopOffsets_Zone = {}
pyrbotOffsets_Zone = {}

hexRotationSpeeds_Zone = {}
pyrtopRotationSpeeds_Zone = {}
pyrbotRotationSpeeds_Zone = {}

for i=1,#track do
	--if not track[i].funkyrot then -- don't place structures at loop/corkscrew nodes (not sure if necessary for these objects)
		if i%300 == 0 then
			hexNodes_Zone[#hexNodes_Zone+1] = i
			local xOffset = 1500 + math.random(0,3) * 7500
			if math.random() > 0.5 then xOffset = xOffset * -1 end
			hexOffsets_Zone[#hexOffsets_Zone+1] = {xOffset,math.random(-2,2)*500,0}
			if xOffset < 0 then
				hexRotationSpeeds_Zone[#hexRotationSpeeds_Zone+1] = {0,10,0}
			else
				hexRotationSpeeds_Zone[#hexRotationSpeeds_Zone+1] = {0,-10,0}
			end
		end
		if i%133 == 0 then
			pyrtopNodes_Zone[#pyrtopNodes_Zone+1] = i
			local xOffset = 250 + 1550*math.random()
			if math.random() > 0.5 then xOffset = xOffset * -1 end
			pyrtopOffsets_Zone[#pyrtopOffsets_Zone+1] = {xOffset,900,0}
			if xOffset < 0 then
				pyrtopRotationSpeeds_Zone[#pyrtopRotationSpeeds_Zone+1] = {0,40,0}
			else
				pyrtopRotationSpeeds_Zone[#pyrtopRotationSpeeds_Zone+1] = {0,-40,0}
			end
		end
		if i%167 == 0 then
			pyrbotNodes_Zone[#pyrbotNodes_Zone+1] = i
			local xOffset = 250 + 1550*math.random()
			if math.random() > 0.5 then xOffset = xOffset * -1 end
			pyrbotOffsets_Zone[#pyrbotOffsets_Zone+1] = {xOffset,-900,0}
			if xOffset < 0 then
				pyrbotRotationSpeeds_Zone[#pyrbotRotationSpeeds_Zone+1] = {0,-40,0}
			else
				pyrbotRotationSpeeds_Zone[#pyrbotRotationSpeeds_Zone+1] = {0,40,0}
			end
		end		
	--end
end		
if quality > 1 then 
CreateObject{ 
	name="HexSphere",
	visible = false,
	gameobject={
		layer=11,
		pos = {x=0,y=0,z=0},
		mesh = starMesh,
		shader="RimLight",
		--diffuseinair = true,
		shadersettings={_GlowScaler=2, _Brightness=1},
		shadercolors={
			_Color = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=6},
			_RimColor={255,255,255}
		},
		textures={_MainTex="hexsphere/hexx_Color_5.png", _BumpMap="hexsphere/hexx_Normal_5.png", _MatCap="matcapchrome.jpg", _Glow="hexsphere/hexx_Color_1.png"},
		--texturewrap = "clamp",
		scale = {x=3,y=3,z=3},
	}
}

BatchRenderEveryFrame{
	prefabName="HexSphere",
	locations=hexNodes_Zone,
	rotateWithTrack=false,
	maxShown=50,
	maxDistanceShown=15000,
	rotationspeeds = hexRotationSpeeds_Zone,
	offsets=hexOffsets_Zone,
	collisionLayer = -2,
	testAndHideIfCollideWithTrack=true
}
end


if quality > 3 then 
CreateObject{ 
	name="PyramidTop",
	visible = false,
	gameobject={
		layer=11,
		pos = {x=0,y=0,z=0},
		mesh = pyrtopMesh,
		shader="RimLightAdd",
		diffuseinair = true,
		shadersettings={_GlowScaler=2, _Brightness=1},
		shadercolors={
			_Color = {colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1},
			--_Color="highwayinverted",
			_RimColor={128,128,128,128}
		},
		texture="Pyramids/pyramid.png",
		--texturewrap = "clamp",
		scale = {x=1,y=1,z=1},
	}
}
	
BatchRenderEveryFrame{prefabName="PyramidTop",
	locations=pyrtopNodes_Zone,
	rotateWithTrack=false,
	maxShown=10,
	maxDistanceShown=2000,
	rotationspeeds = pyrbotRotationSpeeds_Zone,
	offsets=pyrtopOffsets_Zone,
	collisionLayer = -1,
	testAndHideIfCollideWithTrack=true
}
end


if quality > 3 then 
CreateObject{ 
	name="PyramidBot",
	visible = false,
	gameobject={
		layer=11,
		pos = {x=0,y=0,z=0},
		mesh = pyrbotMesh,
		shader="RimLightAdd",
		diffuseinair = true,
		shadersettings={_GlowScaler=2, _Brightness=1},
		shadercolors={
			_Color = {colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1},
			--_Color="highwayinverted",
			_RimColor={128,128,128,128}
		},
		texture="Pyramids/pyramid.png",
		--texturewrap = "clamp",
		scale = {x=1,y=1,z=1},
	}
}

BatchRenderEveryFrame{prefabName="PyramidBot",
	locations=pyrbotNodes_Zone,
	rotateWithTrack=false,
	maxShown=10,
	maxDistanceShown=2000,
	rotationspeeds = pyrbotRotationSpeeds_Zone,
	offsets=pyrbotOffsets_Zone,
	collisionLayer = -1,
	testAndHideIfCollideWithTrack=true
}
end

if quality > 3 then
	wireTerrainMesh = BuildMesh{
					recalculateNormalsEveryFrame=false,
					meshes={"sideboxb0.obj", "sideboxb1.obj", "sideboxb2.obj", "sideboxb3.obj", "sideboxb4.obj", "sideboxb5.obj"}
				}

	CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
		name="SideBoxCloneMe",
		gameobject={
			pos={x=0,y=0,z=0},
			mesh=wireTerrainMesh,
			shader="Proximity2ColorAlpha", -- fade out the distant lines to remove the noise from being smaller than pixels at distance
			shadercolors={
				_Color = {colorsource="highway", scaletype="intensity", minscaler=2, maxscaler=3}
			},
			shadersettings={
				_StartDistance = 50,
				_FullDistance = 125
			},
			texture="White.png",
			scale = {x=1,y=1,z=1}
		}
	}

	if terrainNodes == nil then
		terrainNodes = {} --the track is made of nodes, each one with a position and rotation. This table will hold the indices of track nods that should have a skyscraper rendered at them (with some offset)
		terrainOffsets = {}
		terrainOffsetsR = {}
		terrainRotsR = {}
		for i=1,#track do
			if i%2==0 then
				terrainNodes[#terrainNodes+1] = i
				terrainOffsets[#terrainOffsets+1] = {-trackWidth,0,0}
				terrainOffsetsR[#terrainOffsetsR+1] = {trackWidth,0,0}
				terrainRotsR[#terrainRotsR+1] = {0,180,0}
			end
		end

		BatchRenderEveryFrame{prefabName="SideBoxCloneMe", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
								locations=terrainNodes,
								offsets = terrainOffsets,
								rotateWithTrack=true,
								maxShown=1000,
								colors = "nodecolor", -- objects are rendered by the color of the highway node they're set to
								--maxDistanceShown=20000,
								--collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
								testAndHideIfCollideWithTrack=false --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
							}

		BatchRenderEveryFrame{prefabName="SideBoxCloneMe", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
								locations=terrainNodes,
								offsets = terrainOffsetsR,
								rotations = terrainRotsR,
								rotateWithTrack=true,
								maxShown=1000,
								colors = "nodecolor", -- objects are rendered by the color of the highway node they're set to
								--maxDistanceShown=20000,
								--collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
								testAndHideIfCollideWithTrack=false --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
							}
	end
end

print("Track nodes: " .. #track)
function Update(dt, trackLocation, playerStrafe, playerJumpHeight, intensity)
	local fft = GetSpectrum(); -- GetLogSpectrum();
	local morphweights = {
						3.5 * (fft[1]+fft[2]+fft[3]),
						1.5 * (fft[4]+fft[5]+fft[6]),
						1.5 * (fft[7]+fft[8]+fft[9]),
						1.5 * (fft[10]+fft[11]+fft[12]),
						1.5 * (fft[13]+fft[14]+fft[15]+fft[16])
					}
	local starmorphweights = {
						1.5 * (fft[1]),
						1.0 * (fft[2]+fft[3]+fft[4]+fft[5]+fft[6]),
						1.0 * (fft[7]+fft[8]+fft[9]+fft[10]+fft[11]),
						1.0 * (fft[12]+fft[13]+fft[14]+fft[15]+fft[16])
					}

	UpdateMeshMorphWeights{mesh=spikeMesh, weights=morphweights}
	local morphweightsreversed = {morphweights[5], morphweights[4], morphweights[3], morphweights[2], morphweights[1]}
	UpdateMeshMorphWeights{mesh=starMesh, weights=starmorphweights}
	UpdateMeshMorphWeights{mesh=pyrtopMesh, weights=morphweights}
	UpdateMeshMorphWeights{mesh=pyrbotMesh, weights=morphweights}

	UpdateMeshMorphWeights{mesh=wireTerrainMesh, weights=morphweights}

	if shipMaterial then
		local enginePower = 3 + 20*intensity
		UpdateShaderSettings{material=shipMaterial, shadersettings={_GlowScaler=enginePower}}
	end
end

if quality < 3 then
CreateObject{--skywires, the red lines in the sky. A railed object is attached to the track and moves along it with the player.
	railoffset=0,
	floatonwaterwaves = false,
	gameobject={
		name="scriptSkyWires",
		pos={x=0,y=0,z=0},
		mesh="skywires.obj",
		renderqueue=1000,
		layer=ifhifi(18,13), -- in low detail the glow camera (layer 18) is disabled, so move the skywires to the main camera's layer (13)
		shader="VertexColorUnlitTintedSkywire",
		shadercolors={
			_Color="highway" --{r=255,g=0,b=0}
		},
		texture="White.png",
		scale = {x=1,y=1,z=1},
		lookat = "end"
	}
}
end

--RAILS. rails are the bulk of the graphics in audiosurf. Each one is a 2D shape extruded down the length of the track.
if #skinvars["lanedividers"] > 2 then
	local laneDividers = skinvars["lanedividers"]
	for i=1,#laneDividers do
		CreateRail{ -- lane line
			positionOffset={
				x=laneDividers[i],
				y=0.1},
			crossSectionShape={
				{x=-.07,y=0},
				{x=.07,y=0}},
			perShapeNodeColorScalers={
				1,
				1},
			colorMode="static",
			color = {r=255,g=255,b=255},
			flatten=false,
			nodeskip = 2,
			wrapnodeshape = false,
			shader="VertexColorUnlitTinted"
		}
	end
end

if jumping then
	CreateRail{--big cliff
		positionOffset={
			x=0,
			y=0},
		crossSectionShape={
			{x=11,y=-2},
			{x=22,y=-11},
			{x=22,y=-40},
			{x=-22,y=-40},
			{x=-22,y=-11},
			{x=-11,y=-2}
			},
		perShapeNodeColorScalers={
			1,
			1,
			.4,
			.4,
			1,
			1},
		colorMode="highway",
		color = {r=255,g=255,b=255},
		flatten=false,
		wrapnodeshape = false,
		texture="cliffRails.png",
		fullfuture = true,--ifhifi(true,false),
		stretch = 3,
		calculatenormals = true,
		shader="Cliff"
	}
end

if not jumping then
	CreateRail{--road surface
		positionOffset={
			x=0,
			y=0},
		crossSectionShape={
			{x=-trackWidth,y=0},
			{x=trackWidth,y=0}},
		colorMode="static",
		layer=13,
		wrapnodeshape = false,
		fullfuture = true,
		color = {r=0,g=0,b=0,a=0},
		flatten=false,
		renderqueue=3001,
		--texture="subroad.png",
		shader="VertexColorUnlitTintedAlpha",
		--shadercolors={_Color={r=0,g=0,b=0,a=1}}
	}

	local laneDividers = skinvars["lanedividers"]
	for i=1,#laneDividers do
		CreateRail{ -- lane line
			positionOffset={
				x=laneDividers[i],
				y=0.02},
			crossSectionShape={
				{x=-.04,y=0},
				{x=.04,y=0}},
			perShapeNodeColorScalers={
				1,
				1},
			colorMode="highway",
			color = {r=255,g=255,b=255},
			flatten=false,
			--nodeskip = 2,
			wrapnodeshape = false,
			shader="VertexColorUnlitTinted"
		}
	end

	local shoulderLines = skinvars["shoulderlines"]
	for i=1,#shoulderLines do
		CreateRail{ -- lane line
			positionOffset={
				x=shoulderLines[i],
				y=0.02},
			crossSectionShape={
				{x=-.1,y=0},
				{x=.1,y=0}},
			perShapeNodeColorScalers={
				1,
				1},
			colorMode="highway",
			color = {r=255,g=255,b=255},
			flatten=false,
			--nodeskip = 2,
			wrapnodeshape = false,
			shader="VertexColorUnlitTintedQuadruple"
		}
		CreateRail{ -- lane line
			positionOffset={
				x=shoulderLines[i],
				y=0.04},
			crossSectionShape={
				{x=-.04,y=0},
				{x=.04,y=0}},
			perShapeNodeColorScalers={
				1,
				1},
			colorMode="highway",
			color = {r=255,g=255,b=255},
			flatten=false,
			--nodeskip = 2,
			wrapnodeshape = false,
			shader="VertexColorUnlitTintedDouble"
		}
	end
end

if jumping then
	CreateRail{--left rail
		positionOffset={
			x=-trackWidth,
			y=0},
		crossSectionShape={
			{x=-.95,y=1.4},
			{x=0,y=1},
			{x=0,y=-3},
			{x=-.95,y=-3}},
		perShapeNodeColorScalers={
			.5,
			1,
			0,
			0},
		colorMode="highway",
		color = {r=255,g=255,b=255},
		flatten=true,
		texture="cliffRails.png",
		shader="CliffRail"
	}

	CreateRail{--right rail
		positionOffset={
			x=trackWidth,
			y=0},
		crossSectionShape={
			{x=0,y=1},
			{x=.95,y=1.4},
			{x=.95,y=-3},
			{x=0,y=-3}},
		perShapeNodeColorScalers={
			1,
			.5,
			0,
			0},
		colorMode="highway",
		color = {r=255,g=255,b=255},
		flatten=true,
		texture="cliffRails.png",
		shader="CliffRail"
	}
end

--------------------------------------------------

if quality < 4 then 
shaderset = {_Color = {colorsource="aurora", scaletype="intensity", minscaler=0.5, maxscaler=1}} 
local auroraExtent = ifhifi(77,66)
white = {r=255,g=255,b=255}
CreateRail{ --left aurora for wakeboard 
	positionOffset={
		x=fif(jumping,-1.5, -trackWidth +10.5),
		y=0},
	crossSectionShape={
		{x=-auroraExtent,	y=.1},
		{x=-10.5,			y=.1},
		{x=-10.5,			y=-.1},
		{x=-auroraExtent,	y=-.1}},
	perShapeNodeColorScalers={
		0,
		1,
		1,
		0},
	colorMode="aurora",
	color = white,
	flatten = false,
	fullfuture = false,
	stretch = 1,
	renderqueue=200,
    layer=12,
	shader="VertexColorUnlitTintedAddDouble",
	shadercolors=shaderset
}
CreateRail{	--right aurora for wakeboard
	positionOffset={
		x=fif(jumping,1.5, trackWidth -10.5),
		y=0},
	crossSectionShape={
		{x=10.5,		y=.1},
		{x=auroraExtent,y=.1},
		{x=auroraExtent,y=-.1},
		{x=10.5,		y=-.1}},
	perShapeNodeColorScalers={
		1,
		0,
		0,
		1},
	colorMode="aurora",
	color = white,
	flatten = false,
	fullfuture = false,
	stretch = 1,
	renderqueue=200,
    layer=12,
	shader="VertexColorUnlitTintedAddDouble",
	shadercolors=shaderset
}
end

CreateRail{--left aurora core
	positionOffset={
		x=-18,
		y=33},
	crossSectionShape={
		{x=-13,y=.75},
		{x=-9,y=.75},
		{x=-9,y=-.75},
		{x=-13,y=-.75}},
	perShapeNodeColorScalers={
		1,
		1,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}

CreateRail{--right aurora core
	positionOffset={
		x=18,
		y=33},
	crossSectionShape={
		{x=9,y=.75},
		{x=13,y=.75},
		{x=13,y=-.75},
		{x=9,y=-.75}},
	perShapeNodeColorScalers={
		1,
		1,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}

auroraExtent = ifhifi(77, 55)
CreateRail{--left aurora
	positionOffset={
		x=-18,
		y=33},
	crossSectionShape={
		{x=-auroraExtent,y=.5},
		{x=-11,y=.5},
		{x=-11,y=-.5},
		{x=-auroraExtent,y=-.5}},
	perShapeNodeColorScalers={
		0,
		1,
		1,
		0},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTintedAddDouble"
}

CreateRail{--right aurora
	positionOffset={
		x=18,
		y=33},
	crossSectionShape={
		{x=11,y=.5},
		{x=auroraExtent,y=.5},
		{x=auroraExtent,y=-.5},
		{x=11,y=-.5}},
	perShapeNodeColorScalers={
		1,
		0,
		0,
		1},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTintedAddDouble"
}

--------------------------------------------------

if hifi and jumping then
	CreateRail{--left shell
		positionOffset={
			x = -trackWidth + .23,
			y=0},
		crossSectionShape={
			{x=-.3,y=3},
			{x=-.1,y=3},
			{x=.1,y=-3},
			{x=-.3,y=-3}},
		perShapeNodeColorScalers={
			.3,
			.2,
			.8,
			.2},
		colorMode="highway",
		flatten=true,
		wrapnodeshape = false,
		shader="proximity_2way_Color",
		renderqueue=3998,
	    layer=13,
		shadercolors={_nearColor={r=255,g=255,b=255,a=0},
						_farColor={r=255,g=255,b=255,a=214}},
		shadersettings={_nearDistance=0, _farDistance=103.5}
	}

	CreateRail{--right shell
		positionOffset={
			x=trackWidth - .23,
			y=0},
		crossSectionShape={
			{x=.3,y=-3},
			{x=-.1,y=-3},
			{x=-.1,y=3},
			{x=.3,y=3}},
		perShapeNodeColorScalers={
			.3,
			.8,
			.2,
			.2},
		colorMode="highway",
		flatten=true,
		wrapnodeshape = false,
		shader="proximity_2way_Color",
		renderqueue=3998,
	    layer=13,
		shadercolors={_nearColor={r=255,g=255,b=255,a=0},
						_farColor={r=255,g=255,b=255,a=214}},
		shadersettings={_nearDistance=0, _farDistance=103.5}
	}
end

if not jumping then
	CreateRail{--left wake guide
		positionOffset={
			x=-wakeStrafe,
			y=0},
		crossSectionShape={
			{x=-.1,y=-.05},
			{x=-.1,y=.05},
			{x=.1,y=.05},
			{x=.1,y=-.05}},
		perShapeNodeColorScalers={
			1,
			1,
			1,
			1},
		colorMode=fif(jumping,"highway","static"),
		color = {r=255,g=255,b=255},
		layer=13,
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTinted"
	}

	CreateRail{--right wake guide
		positionOffset={
			x=wakeStrafe,
			y=0},
		crossSectionShape={
			{x=-.1,y=-.05},
			{x=-.1,y=.05},
			{x=.1,y=.05},
			{x=.1,y=-.05}},
		perShapeNodeColorScalers={
			1,
			1,
			1,
			1},
		colorMode=fif(jumping,"highway","static"),
		color = {r=255,g=255,b=255},
		layer=13,
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTinted"
	}
else
	CreateRail{--left shell topper
		positionOffset={
			x=-trackWidth + .23,
			y=0},
		crossSectionShape={
			{x=-.1,y=3},
			{x=-.1,y=3.2},
			{x=.1,y=3.2},
			{x=.1,y=3}},
		perShapeNodeColorScalers={
			1,
			1,
			1,
			1},
		--colorMode=fif(jumping,"highway","highwayinverted"),
		color = {r=255,g=255,b=255},
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTinted"
	}

	CreateRail{--right shell top
		positionOffset={
			x=trackWidth - .23,
			y=0},
		crossSectionShape={
			{x=-.1,y=3},
			{x=-.1,y=3.2},
			{x=.1,y=3.2},
			{x=.1,y=3}},
		perShapeNodeColorScalers={
			1,
			1,
			1,
			1},
		--colorMode=fif(jumping,"highway","highwayinverted"),
		color = {r=255,g=255,b=255},
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTinted"
	}
end