--[[Most of this code was not done by me. The base code was used from Rainbowish by Kiisseli with some colour pallet edits as well as changes to wakes done solely by me. Parts that were not in either of those were based off of code from other skins and/or were edited by me or Kiisseli. The only credit I should get is the idea of making this and bringing it all together.]]

jumping = PlayerCanJump()
function fif(test, if_true, if_false)
  if test then return if_true else return if_false end
end

hifi = GetQualityLevel() > 2 -- GetQualityLevel returns 1,2,or 3
function ifhifi(if_true, if_false)
  if hifi then return if_true else return if_false end
end

skinvars = GetSkinProperties()
trackWidth = skinvars["trackwidth"]
--trackWidth = 11.5 -- uses a wide water track even for vehicles
fullsteep = jumping or skinvars.prefersteep

do
        --[[ "Sandboxify" code that runs before us:
                luanet = nil
                package = nil
                require = nil
                dofile = nil
                load = nil
                loadfile = nil
                os = nil
                io = nil
        ]]
       
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
	radialblur_strength = ifhifi(2,0),
--	radialblur_strength = fif(jumping,2,0),
	watertype = 1,
	water = jumping, --only use the water cubes in wakeboard mode
	--watertint = {r=255,g=255,b=255,a=11},
	watertint = {r=255,g=255,b=255,a=255},
	--watertint_highway = true,
	--watertexture = "WaterCubesBlue_BlackTop_WhiteLowerTier.png",--waterBW.png",
	watertexture = "WaterCubesBlue_BlackTop_WhiteLowerTier.png",
	widewater = false, --sets water to 16.25 width
	towropes = jumping,--use the tow ropes if jumping
	airdebris_count = ifhifi(1000,500),
	airdebris_density = ifhifi(40,20),
	airdebris_texture = ifhifi ("Hexagon256_2.png","Hexagon.png"),
	--airdebris_particlesize = .55,
	--airdebris_fieldsize = 200,
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
			--leg={
			--	mesh="foot.obj",
			--	shader="RimLightHatchedSurfer",
			--	shadercolors={
			--		_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=6, param="_Threshold", paramMin=-1, paramMax=2},
			--		_RimColor={0,49,242}
			--		--_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}
			--	},
			--	texture="foot.png"
			--},
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
	--[[
	local vehicleTable = {}
	local junShip = false
	local junShipFrontWings = false
	local skinnyfrontship = true
	local skinnyfrontshiptop = false

	local shipMesh = BuildMesh{
		mesh="junship90.obj",
		--calculateTangents = true,
		barycentricTangents = true, --for use with wireframe shaders
		calculateNormals = false,
		submeshesWhenCombining = false
	}

	shipMaterial = BuildMaterial{
		renderqueue = 2000,
		shader="UnlitTintedTexGlowWire",
		shadersettings={_Shininess=0.1, _GlowScaler=9, _MainScaler=.7},
		shadercolors={
			_Color = {colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1},
			_SpecColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1},
			_GlowColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1}
			},
		textures={_MainTex="maintex.png", _BumpMap="normal.png", _Glow="glowBW.png"}
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
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.6,0.6,0.8}},
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.45,0.45,0.8}},
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.3,0.3,0.8}},
						{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.1,0.1,0.8}},

						--rear sides
						{pos={0.537,0.28,-1.64},rot={0,0,0},scale={0.3,0.3,0.66}},
						{pos={0.537,0.28,-1.64},rot={0,0,0},scale={0.1,0.1,0.66}},

						{pos={-0.472,0.28,-1.65},rot={0,0,0},scale={0.3,0.3,0.66}},
						{pos={-0.472,0.28,-1.65},rot={0,0,0},scale={0.1,0.1,0.66}}
					}}
	}
	--]]
		local shipMesh = BuildMesh{
			mesh="racingship_scaled75.obj",
			barycentricTangents = true, --for use with wireframe shaders
			--calculateTangents = true,
			calculateNormals = false,
			submeshesWhenCombining = false
		}

		shipMaterial = BuildMaterial{
			renderqueue = 2000,
			shader="UnlitTintedTexGlowWire",
			shader = "MatCap/Vertex/PlainBrightGlow",
			shadersettings={_GlowScaler=9, _Brightness=.66},
			shadercolors={
				_Color = {colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1},
				--_SpecColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1},
				_GlowColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1}
				},
			textures={_MatCap="matcapchrome.jpg", _Glow="glowBWj1.png"}
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
			pos={0,2,-0.5},
			rot={30,0,0},
			strafefactorFar = .75,
			pos2={0,5,-4},
			rot2={30,0,0},
			strafefactorFar = 1,
			transitionspeed = 1,
			puzzleoffset=-0.65,
			puzzleoffset2=-1.5},
		vehicle=vehicleTable
	}
end

--randomSky = math.random(1,2)

--[[SetSkybox{
	skyscreen = "thegridSky_" .. randomSky .. ".shader"
	--skyscreenlayer = 13} --13 for normal layer -- 11 for both
	}
--]]
SetSkybox{
	skyscreen = "thegridSky_2.shader",
	layer=11
	}

track_colors_choices = {
{										--Original
    {r=0, g=0, b=0},
    {r=0, g=0, b=0},
    {r=148,g=0,b=211},
    {r=25, g=25, b=112},
    {r=34, g=139, b=34},
    {r=237, g=247, b=65},
    {r=250,g=50,b=36},
    {r=0, g=0, b=0},
    {r=243, g=32, b=124},
    {r=232, g=62, b=232},
    {r=150, g=20, b=236},
    {r=63, g=20, b=236},
    {r=29, g=134, b=239},
    {r=29, g=239, b=204},
    {r=29, g=239, b=106},
    {r=196, g=246, b=57},
    {r=250,g=50,b=36},
},
{										--26 colors
    {r=0, g=0, b=0},
    {r=0, g=0, b=0},
    {r=148,g=0,b=211},
    {r=25, g=25, b=112},
    {r=34, g=139, b=34},
    {r=237, g=247, b=65},
    {r=250,g=50,b=36},
    {r=0, g=0, b=0},
    {r=229, g=122, b=129},
    {r=235, g=89, b=152},
    {r=193, g=29, b=139},
    {r=230, g=36, b=224}, 
    {r=199, g=30, b=242}, 
    {r=145, g=66, b=225},
    {r=72, g=39, b=240},
    {r=32, g=74, b=240},
    {r=114, g=178, b=242},
    {r=23, g=95, b=137},
    {r=64, g=176, b=193},
    {r=64, g=220, b=153},
    {r=64, g=245, b=59},
    {r=148, g=225, b=110},
    {r=203, g=239, b=85},
    {r=236, g=214, b=72},
    {r=243, g=140, b=36},
    {r=49, g=225, b=219},
    {r=250,g=50,b=36},
},
{										--Crazy shit (NEEDS COMPLETE REWORK)
    {r=0, g=0, b=0},
    {r=243, g=64, b=36}, 
    {r=243, g=22, b=66}, 
    {r=240, g=228, b=51},
    {r=220, g=50, b=152},
    {r=235, g=235, b=51},
    {r=242, g=39, b=228},
    {r=131, g=232, b=30},
    {r=144, g=30, b=232},
    {r=33, g=218, b=19},
    {r=39, g=45, b=233},
    {r=33, g=240, b=158},
    {r=39, g=252, b=245},
    {r=0, g=0, b=0},
},
{										--Highlight_1
    {r=0, g=0, b=0},
    {r=0, g=0, b=0},
    {r=148,g=0,b=211},
    {r=25, g=25, b=112},
    {r=34, g=139, b=34},
    {r=237, g=247, b=65},
    {r=250,g=50,b=36},
    {r=0, g=0, b=0},
	--{18,219,233},--light blue
    --{18,18,233},--blue
	{25,136,233},--light blue
	{25,25,112},--blue
    {232,18,132},--magenta
	{148,0,211},--purple
    {255,69,0},--orange
    {0,0,0},
    {r=250,g=50,b=36},
},
{										--Highlight_2
    {r=0, g=0, b=0},
    {r=0, g=0, b=0},
    {r=148,g=0,b=211},
    {r=25, g=25, b=112},
    {r=34, g=139, b=34},
    {r=237, g=247, b=65},
    {r=250,g=50,b=36},
    {r=0, g=0, b=0},
	{18,219,233},--light blue
    {18,18,233},--blue
	--{25,136,233},--light blue
	--{25,25,112},--blue
	{148,0,211},--purple
    {232,18,132},--magenta
    {255,69,0},--orange
    {0,0,0},
    {r=250,g=50,b=36},
},
{										--Purple to Blue (OLD)
    {r=0, g=0, b=0},
    --{r=243, g=64, b=36}, --red orange
    {r=243, g=22, b=66}, --hot magenta
	{232,18,132},--magenta
    --{r=240, g=228, b=51},--yellow
    {r=220, g=50, b=152},--purple
	{0,0,0},
    --{r=235, g=235, b=51},--yellow
    {r=242, g=39, b=228},--purple
    --{r=131, g=232, b=30},--kiwi green
	{25,25,112},--blue
    {r=144, g=30, b=232},--dark purple
    --{r=33, g=218, b=19},--green
	--{r=33, g=240, b=158},--seafoam green
    {r=39, g=45, b=233},--another blue
    {r=33, g=240, b=158},--seafoam green
    {r=39, g=252, b=245},--b-ba-baby
    {r=0, g=0, b=0},
},
{										--Random (OLD)
    {r=0, g=0, b=0},
    {r=243, g=64, b=36}, --red orange
	{r=240, g=228, b=51},--yellow
    {r=243, g=22, b=66}, --hot magenta
	{0,0,0},								
	--{232,18,132},--magenta
    {r=220, g=50, b=152},--purple
    {r=235, g=235, b=51},--yellow
    --{r=242, g=39, b=228},--purple
    --{r=131, g=232, b=30},--kiwi green
	{25,25,112},--blue
    {r=144, g=30, b=232},--dark purple
    --{r=33, g=218, b=19},--green
	--{r=33, g=240, b=158},--seafoam green
    {r=39, g=45, b=233},--another blue
    {r=33, g=240, b=158},--seafoam green
	{r=250,g=50,b=36},--cool red
    --{r=39, g=252, b=245},--b-ba-baby
    {r=0, g=0, b=0},
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

track_colors_index = math.random(#track_colors_choices)
track_colors = track_colors_choices[track_colors_index]
SetTrackColors(track_colors)
print("random track color palette: #" .. track_colors_index)
--[[
SetTrackColors{ --enter any number of colors here. The track will use the first ones on less intense sections and interpolate all the way to the last one on the most intense sections of the track
{r=0, g=0, b=0},
	{12,10,87}, --very dark blue
	{47,77,37}, --dark green
	{70,150,24}, --green
		{213,213,33}, --yellow
	{153,21,21}, --dark red
	{214,204,26}, --orange
	{160,5,5}, --crimson
	{247,57,57}, --bright red
	{12,10,87}, --very dark blue
		{213,213,33}, --yellow
	{153,21,21}, --dark red
	{214,204,26}, --orange
	{160,5,5}, --crimson
	{247,57,57}, --bright red
}
--]]
--SetBlockColors{ --this is only used for puzzle modes (which you don't have yet) with multiple colors of blocks
--    {r=93, g=8, b=132},
--	{r=1.0, g=0.27, b=0.2},
--    {r=0.047, g=0.5098, b=0.94},
--    {r=1.0, g=0.85, b=0.4157},
--	{r=0, g=0.29, b=0.08},
--    {r=1,g=0,b=0}
--}

spikeMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = true,
				barycentricTangents = true,
				meshes={"wallmorph_baseline.obj", "wallmorph0.obj", "wallmorph1.obj", "wallmorph2.obj", "wallmorph3.obj", "wallmorph4.obj"}
			}

ballMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = true,
				barycentricTangents = true,
				meshes={"ballmorph_baseline.obj", "ballmorph0.obj", "ballmorph1.obj", "ballmorph2.obj", "ballmorph3.obj", "ballmorph4.obj"}
			}

--towerMesh = BuildMesh{
--				recalculateNormalsEveryFrame=true,
--				meshes={"towermorph_baseline.obj", "towermorph0.obj", "towermorph1.obj", "towermorph2.obj", "towermorph3.obj", "towermorph4.obj"}
--			}

squareMesh = BuildMesh{
				recalculateNormalsEveryFrame=true,
				splitVertices = true,
				barycentricTangents = true,
				meshes={"squaremorph_baseline.obj", "squaremorph0.obj", "squaremorph1.obj", "squaremorph2.obj", "squaremorph3.obj", "squaremorph4.obj"}
			}

if not jumping then
	SetBlocks{
		maxvisiblecount = 200, -- fif(skinvars.minvisibleblocks, math.max(200, skinvars.minvisibleblocks), 200),
		colorblocks={
			mesh = "DBN_assets/block.obj", --  ballMesh, --"DoubleLozenge.obj",
			--shader = fif(hifi,"MatCap/Vertex/Textured Lit Double Mult", "MatCap/Vertex/PlainBright"),
			--shader = "MatCap/Vertex/PlainBright", -- "MatCap/Vertex/PlainBrightWire",
			shader = "DBN_assets/block_rimlight_intensity.shader",
				shadercolors = {
					_AlphaGlowTint = 2/3,
					_RimColor = 1/8,
					_BorderAdd = 3/4, -- higher contrast in trackless mode
					_BorderMult = 1/4,
				},
			shadersettings = fif(hifi, {_Brightness=4.0}, {_Brightness=5.5}),
			textures = {_MainTex="White.png", _MatCap="matcapchrome.jpg"},
		    height = 0,
		    shadercolors = {_Color="highwayinverted"},
		    float_on_water = false,
		    scale = {1,1,1},
		    reflect = false
		},
		greyblocks={
			mesh = spikeMesh,--"doublespike.obj",
			--shader = fif(hifi,"MatCap/Vertex/Textured Lit Double Mult", "MatCap/Vertex/PlainBright"),
			shader = "MatCap_PlainBrightWireGrey.shader", -- "MatCap/Vertex/PlainBright", --"MatCap/Vertex/PlainBrightWireWhite",
			shadersettings = fif(hifi, {_Brightness=4.0}, {_Brightness=5}),
			textures = {_MainTex="White.png", _MatCap="matcapchrome.jpg"},
			--height = 0,
			--shadercolors = {_Color="highwayinverted"},
			shadercolors= {_Color={colorsource="highwayinverted", scaletype="intensity", minscaler=2, maxscaler=2.5}},
			reflect = false
		},
		--[[powerups={--override the following objects in case the mod uses them
			powerpellet={
				mesh = squareMesh,
				shader = fif(hifi,"MatCap/Vertex/Textured Lit Double Mult", "MatCap/Vertex/PlainBright"),
				shadersettings = fif(hifi, {_Brightness=4.0}, {_Brightness=5}),
				textures = {_MainTex="White.png", _MatCap="matcapchrome.jpg"},
				scale = {2.7,2.7,2.7},
				reflect = false,
				shadercolors = {_Color="highway"}
			}]]

		--},
		chainspans={
			material = chainspanMaterial
			--renderqueue = 3033,
			--shader = "VertexColorUnlitTintedAdd"
		}

	}
end


--if hifi then
--	CreateLight{
--		railoffset = -3,
--		range = 10,
--		intensity = 2,
--		transform = {
--			position={0,.5,0}
--		},
--		color="highway"
--	}
--end

SetPuzzleGraphics{
	usesublayerclone = false,
	puzzlematchmaterial = {shader="Unlit/Transparent",texture="tileMatchingBars.png"},
	puzzleflyupmaterial = {shader="VertexColorUnlitTintedAddFlyup",texture="tileMatchingBars.png"},
	puzzlematerial = {shader="DBN_assets/VertexColorUnlitTintedAlpha.shader",texture="tilesSquare.png",shadercolors={_Color={255,255,255,255}}}
}

SetRings{ --setup the tracks tunnel rings. the airtexture is the tunnel used when you're up in a jump
	texture="ringOnTop_2.png",
	--texture="Classic_OnBlack",
	shader="VertexColorUnlitTintedAddSmooth",
	size=22,
	percentringed=.2,--ifhifi(2,.01),-- .2,
	airtexture="Bits.png",
	airshader="VertexColorUnlitTintedAddSmooth",
	airsize=16
}

--if jumping then wakeHeight=(ifhifi(4,2)) else wakeHeight = 0 end
wakeHeight=1.5 --(ifhifi(4,2))
extraWidth = trackWidth - 5
if jumping then extraWidth = 0 end
wakeStrafe = 7.5 + extraWidth
--wakeStrafe = 14.7
if not jumping then wakeHeight = 1.75 end
SetWake{ --setup the spray coming from the two pulling "boats"
	height = wakeHeight,
	fallrate = 0.99,
	--offsets = {{wakeStrafe,0,0}, {-wakeStrafe,0,0}, {0,0,0}},
	offsets = {{wakeStrafe,0,0}, {-wakeStrafe,0,0}},
	--strafe = wakeStrafe,
	--shader = fif(jumping, "VertexColorUnlitTintedAddSmooth", "VertexColorUnlitTintedAddSmoothQuarter"),
	shader = "VertexColorUnlitTintedAddSmooth",
	layer = 13, -- looks better not rendered in background when water surface is not type 2
	--layer = 12,
	bottomcolor = {r=0,g=0,b=0},
	--topcolor = {colorsource="highwaysmooth", scaletype="intensity", minscaler=1, maxscaler=2}
	topcolor = highway,
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

CreateObject{ 
	name="Star",
	active=true,
	gameobject={
		pos={x=0,y=0,z=0},
		layer=12,
		mesh="planet.obj",
		meshmorph="planets.obj",
		meshmorphtype="intensity",
		meshmorphsmoothspeed = 22,
		--shader="VertexColorUnlitTintedAddSmooth",
		shader="VertexColorUnlitTintedAlpha2",
		--shader="IlluminDiffuse",
		--diffuseinair = true,
		shadercolors={
			_Color = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=6},
			--_Color={colorsource="highway", scaletype="intensity", minscaler=0, maxscaler=1, param="_Threshold", paramMin=1, paramMax=2},
			--_Color="highway",
			--_RimColor={255,255,255}
			_RimColor={0,0,0}
		},
		texture="planet8_alpha.png",
		--texturewrap = "clamp",
		scale = {x=1,y=1,z=1},
	}
}

--CreateLight{
--	type= "point",
--	range = 211,
--	intensity = 5,
--	transform = {
--		position={0,130,0}
--	},
--	color="highway"
--}

track = GetTrack()
	math.randomseed(#track)
if buildingNodes == nil then
	buildingNodes = {}
	offsets = {}
	buildingNodesToo = {}
	offsetsToo = {}
	local nextLight = 0
	for i=1,#track do
		if i%80==0 then	

			buildingNodes[#buildingNodes+1] = i
			local xOffset = 500 + 1850*math.random(0.2,1)
			if math.random() > 0.5 then xOffset = xOffset * -1 end
			offsets[#offsets+1] = {xOffset,-100,0}
			--if nextLight > 4 then		CreateLight{
			--type= "point",
			--range = 2000,
			--intensity = 5,
			--transform = {
			--position={(buildingNodes[i] + xOffset), (buildingNodes[i] - 100),(buildingNodes[i])}
			--},
			--color="highway"
			--}
			--nextLight = 0
			--else
			--nextLight = nextLight + 1
			--end
		--for jjj=1,3 do
			--buildingNodes[#buildingNodes+1] = i
			--local xOffset = jjj * 14 + 5*math.random()
			--if math.random() > 0.5 then xOffset = xOffset * -1 end
			--local yOffset = jjj * 14 + 5*math.random()
			--if math.random() > 0.5 then yOffset = yOffset * -1 end
			--offsets[#offsets+1] = {xOffset,yOffset,(3 - jjj) * (4 + 3 * jjj)}
		end
	end
	

	BatchRenderEveryFrame{prefabName="Star",
							locations=buildingNodes,
                    		rotateWithTrack=false,
							maxShown=8,
                    		maxDistanceShown=4000,
							offsets=offsets,
							collisionLayer = 1,
							testAndHideIfCollideWithTrack=true
						}
end


--This shows that scripted dynamic meshes can be used, but you probably don't need this
--function AddQuadIndices(t, index0, index1, index2, index3)
--	table.insert(t, index0)
--	table.insert(t, index1)
--	table.insert(t, index2)
--	table.insert(t, index1)
--	table.insert(t, index3)
--	table.insert(t, index2)
--end
--
--if mesh1==nil then --if this mesh hasn't been created yet
--	verts = {}
--	verts[1] = {x=-0.5, y=0.5, z=0.5}
--	verts[2] = {x=0.5, y=0.5, z=0.5}
--	verts[3] = {x=-0.5, y=0.5, z=-0.5}
--	verts[4] = {x=0.5, y=0.5, z=-0.5}
--	verts[5] = {x=-0.5, y=-0.5, z=0.5}
--	verts[6] = {x=0.5, y=-0.5, z=0.5}
--	verts[7] = {x=-0.5, y=-0.5, z=-0.5}
--	verts[8] = {x=0.5, y=-0.5, z=-0.5}
--	uvs = {}
--	uvs[1] = {0,1}
--	uvs[2] = {1,1}
--	uvs[3] = {0,1}
--	uvs[4] = {1,1}
--	uvs[5] = {0,0}
--	uvs[6] = {1,0}
--	uvs[7] = {0,0}
--	uvs[8] = {1,0}
--	indices = {}
--	AddQuadIndices(indices, 0, 1, 2, 3)
--	AddQuadIndices(indices, 1, 0, 5, 4)
--	AddQuadIndices(indices, 3, 1, 7, 5)
--	AddQuadIndices(indices, 2, 3, 6, 7)
--	AddQuadIndices(indices, 0, 2, 4, 6)
--	AddQuadIndices(indices, 5, 4, 7, 6)
--
--	mesh1 = BuildMesh{
--		vertextable=verts,
--		indextable=indices,
--		uvtable = uvs,
--		calculatenormals = true
--	}
--end
--
--function Update(dt) --called every frame if it exists
--	for i=1,4 do
--		verts[i].y = dt*100
--	end
--
--	BuildMesh{
--		mesh=mesh1,
--		vertextable = verts,
--		calculatenormals = true
--	}
--end

--[[CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
	name="BuildingCloneMe",
	gameobject={
		pos={x=0,y=0,z=0},
		--mesh="skyscraper42.obj",
		mesh="skyscraper_withbase.obj",
		--shader="VertexColorUnlitTintedAlpha",
		shader="Diffuse",
		--diffuseinair = true,
		shadercolors={
			_Color={r=0,g=0,b=0}
			--_Color="highwaysmooth"
			--_Color = {colorsource="highway", scaletype="intensity", minscaler=6, maxscaler=6}
			--_Color = {colorsource="highway", scaletype="intensity", minscaler=2, maxscaler=2}
		},
		texture="White.png",
		--texture="skyscraper.png",
		scale = {x=1,y=1,z=1}
	}
}]]

--CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
--	name="BuildingCloneMeToo",
--	gameobject={
--		pos={x=0,y=0,z=0},
--		--mesh="skyscraper42.obj",
--		mesh="skyscraper42_withbase.obj",
--		--shader="VertexColorUnlitTintedAlpha",
--		shader="PsychoBuilding",
--		shadercolors={
--			--_Color={r=255,g=255,b=255}
--			--_Color="highwaysmooth"
--			--_Color = {colorsource="highway", scaletype="intensity", minscaler=6, maxscaler=6}
--			_Color = {colorsource="highway", scaletype="intensity", minscaler=2, maxscaler=2}
--		},
--		--texture="cliffRails.png",
--		--texture="skyscraper.png",
--		scale = {x=1,y=1,z=1}
--	}
--}

track = GetTrack()--get the track data from the game engine

--[[if buildingNodes == nil then
	buildingNodes = {} --the track is made of nodes, each one with a position and rotation. This table will hold the indices of track nods that should have a skyscraper rendered at them (with some offset)
	offsets = {}
	buildingNodesToo = {}
	offsetsToo = {}
	for i=1,#track do
		if i%80==0 then
			buildingNodes[#buildingNodes+1] = i
			local xOffset = 150 + 1650*math.random()
			if math.random() > 0.5 then xOffset = xOffset * -1 end
			offsets[#offsets+1] = {xOffset,-100,0}
		end

--		if (i+40)%120==0 then
--			buildingNodesToo[#buildingNodesToo+1] = i
--			local xOffset = 150 + 1650*math.random()
--			if math.random() > 0.5 then xOffset = xOffset * -1 end
--			offsetsToo[#offsetsToo+1] = {xOffset,-100,0}
--		end
	end

	BatchRenderEveryFrame{prefabName="BuildingCloneMe", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
							locations=buildingNodes,
                    		rotateWithTrack=false,
                    		maxShown=50,
                    		maxDistanceShown=2000,
							offsets=offsets,
							collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
							testAndHideIfCollideWithTrack=true --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
						}

--	BatchRenderEveryFrame{prefabName="BuildingCloneMeToo", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
--							locations=buildingNodesToo,
--                    		rotateWithTrack=false,
--                    		maxShown=50,
--                    		maxDistanceShown=2000,
--							offsets=offsetsToo,
--							collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
--							testAndHideIfCollideWithTrack=true --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
--						}]]
--end


wireTerrainMesh = BuildMesh{
				recalculateNormalsEveryFrame=false,
				--meshes={"centerbox.obj", "centerbox_m1.obj", "centerbox_m2.obj", "centerbox_m3.obj", "centerbox_m4.obj", "centerbox_m5.obj"}
				--meshes={"sidebox.obj"}
				meshes={"sideboxb0.obj", "sideboxb1.obj", "sideboxb2.obj", "sideboxb3.obj", "sideboxb4.obj", "sideboxb5.obj"}
			}

CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
	name="SideBoxCloneMe",
	gameobject={
		pos={x=0,y=0,z=0},
		--mesh="skyscraper42.obj",
		mesh=wireTerrainMesh,
		--shader="VertexColorUnlitTintedAlpha",
		shader="UnlitTintedTex",
		shadercolors={
			_Color = {colorsource="highway", scaletype="intensity", minscaler=2, maxscaler=2}
		},
		texture="White.png",
		--texture="skyscraper.png",
		scale = {x=1,y=1,z=2}
	}
}

if terrainNodes == nil then
	terrainNodes = {} --the track is made of nodes, each one with a position and rotation. This table will hold the indices of track nods that should have a skyscraper rendered at them (with some offset)
	terrainOffsets = {}
	terrainOffsetsR = {}
	terrainRotsR = {}
	--offsets = {}
	--buildingNodesToo = {}
	--offsetsToo = {}
	for i=1,#track do
		if i%2==0 then
			terrainNodes[#terrainNodes+1] = i
			terrainOffsets[#terrainOffsets+1] = {-trackWidth,0,0}
			terrainOffsetsR[#terrainOffsetsR+1] = {trackWidth,0,0}
			terrainRotsR[#terrainRotsR+1] = {0,180,0}
			--local xOffset = 150 + 1650*math.random()
			--if math.random() > 0.5 then xOffset = xOffset * -1 end
			--offsets[#offsets+1] = {xOffset,-100,0}
		end
	end

	BatchRenderEveryFrame{prefabName="SideBoxCloneMe", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
							locations=terrainNodes,
							offsets = terrainOffsets,
                    		rotateWithTrack=true,
                    		maxShown=1000,
                    		colors = "nodecolor", -- objects are rendered by the color of the highway node they're set to
                    		--maxDistanceShown=20000,
							--offsets=offsets,
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
							--offsets=offsets,
							--collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
							testAndHideIfCollideWithTrack=false --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
						}
end


function Update(dt, trackLocation, playerStrafe, playerJumpHeight, intensity)
	local fft = GetSpectrum(); -- GetLogSpectrum();
	local morphweights = {
						3.5 * (fft[1]+fft[2]+fft[3]),
						1.5 * (fft[4]+fft[5]+fft[6]),
						1.5 * (fft[7]+fft[8]+fft[9]),
						1.5 * (fft[10]+fft[11]+fft[12]),
						1.5 * (fft[13]+fft[14]+fft[15]+fft[16])
					}

	UpdateMeshMorphWeights{mesh=spikeMesh, weights=morphweights}
	UpdateMeshMorphWeights{mesh=ballMesh, weights=morphweights}
	local morphweightsreversed = {morphweights[5], morphweights[4], morphweights[3], morphweights[2], morphweights[1]}
	UpdateMeshMorphWeights{mesh=squareMesh, weights=morphweightsreversed}

	UpdateMeshMorphWeights{mesh=wireTerrainMesh, weights=morphweights}

	if shipMaterial then
		local enginePower = 3 + 20*intensity
		UpdateShaderSettings{material=shipMaterial, shadersettings={_GlowScaler=enginePower}}
	end
end

--[[
CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
	name="SpriteTest",
	active=false,
	gameobject={
		pos={x=0,y=0,z=0},
		mesh="skyscraper42_withbase.obj",--mesh doesn't matter, the spritebatch won't use it
		shader="VertexColorUnlitTintedAddSmooth",
		shadercolors={
			_Color = {255,255,255}
		},
		texture="Frequency_OnBlack.jpg"
	}
}

spritenodes = {}
spriteoffsets = {}
for i=1,#track do
	if i%80==0 then
		spritenodes[#spritenodes+1]=i
		local xOffset = 150 + 300*math.random()
		if math.random() > 0.5 then xOffset = xOffset * -1 end
		spriteoffsets[#spriteoffsets+1] = {xOffset,-100,0}
	end
end

CreateSpriteBatch{
	prefabName="SpriteTest",--the material from this prefab is used
	locations=spritenodes,
	offsets={120,0,0},
	scales={30,30,30},
	repeaterSpacings={2,4,6,8,10,12,14,16,18,20}
}

--]]

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

if jumping then
	--[[
	CreateObject{--left rope puller
		railoffset=18,
		floatonwaterwaves = true,
		tiltsmoother = 44,
		gameobject={
			pos={
				x=-7.5,
				y=.25,
				z=1},
			mesh="staggersphere.obj",
			shader="rimlight.shader",--shader text files can be used. Take the compiled shader from unity and give it a "shader" file extension to use it
			shadercolors={
				_Color={r=46,g=46,b=46},
				_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}
			},
			texture="White.png",
			scale = {x=1.25,y=1.25,z=1.25}
		}
	}

	CreateObject{--right rope puller
		railoffset=18,
		floatonwaterwaves = true,
		tiltsmoother = 44,
		gameobject={
			pos={
				x=7.5,
				y=.25,
				z=1},
			mesh="staggersphere.obj",
			shader="rimlight.shader",
			shadercolors={
				_Color={r=46,g=46,b=46},
				_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}
			},
			texture="White.png",
			scale = {x=1.25,y=1.25,z=1.25}
		}
	}
	--]]
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

--CreateRail{--big cliff low detail. This one will almost always be able to render the song's full future.
--	positionOffset={
--		x=0,
--		y=0},
--	crossSectionShape={
--		{x=0,y=-4},
--		{x=0,y=-35}
--		},
--	perShapeNodeColorScalers={
--		1,
--		.4},
--	colorMode="highway",
--	color = {r=255,g=255,b=255},
--	flatten=false,
--	wrapnodeshape = true,
--	texture="cliffRails.png",
--	fullfuture = true,
--	stretch = 3,
--	calculatenormals = true,
--	shader="Cliff"
--}

--[[
CreateRail{--distant water
	positionOffset={
		x=0,
		y=0},
	crossSectionShape={
		{x=-12,y=-5.5},
		{x=12,y=-5.5}},
	perShapeNodeColorScalers={
		1,
		1},
	colorMode="static",
	color = {r=0,g=137,b=255},
	flatten=false,
	wrapnodeshape = false,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}
--]]

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
		color = {r=255,g=255,b=255,a=255},
		flatten=false,
		renderqueue=3001,
		--texture="subroad.png",
		shader="DBN_assets/VertexColorUnlitTintedAlpha.shader",
		shadercolors={_Color={r=0,g=0,b=0,a=0}}
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

CreateRail{--left aurora core
	positionOffset={
		x=-18,
		y=33},
	crossSectionShape={
		{x=-13,y=.5},
		{x=-9,y=.5},
		{x=-9,y=-.5},
		{x=-13,y=-.5}},
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
		{x=9,y=.5},
		{x=13,y=.5},
		{x=13,y=-.5},
		{x=9,y=-.5}},
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

auroraExtent = ifhifi(77, 22)
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
    layer=11,
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
    layer=11,
	texture="White.png",
	shader="VertexColorUnlitTintedAddDouble"
}

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
		colorMode=fif(jumping,"highway","highwayinverted"),
		color = {r=255,g=255,b=255},
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTintedAddDouble"
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
		colorMode=fif(jumping,"highway","highwayinverted"),
		color = {r=255,g=255,b=255},
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTintedAddDouble"
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
		colorMode=fif(jumping,"highway","highwayinverted"),
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
		colorMode=fif(jumping,"highway","highwayinverted"),
		color = {r=255,g=255,b=255},
		flatten=jumping,
		texture="White.png",
		shader="VertexColorUnlitTinted"
	}
end