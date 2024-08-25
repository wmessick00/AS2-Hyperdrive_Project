jumping = PlayerCanJump()
quality = GetQualityLevel()
function fif(test, if_true, if_false)
  if test then return if_true else return if_false end
end

hifi = GetQualityLevel() > 2

function ifhifi(if_true, if_false)
  if hifi then return if_true else return if_false end
end
function lowMedHigh(if_low, if_med, if_high)
	if quality <= 1 then return if_low
	elseif quality == 2 then return if_med
	else return if_high end
end

skinvars = GetSkinProperties()
trackWidth = 12

SetScene{
water = false,
	glowpasses = ifhifi(4,0),
	glowspread = ifhifi(0.5,0),
	radialblur_strength = ifhifi(0.5,0),
	watertint = {r=255,g=255,b=255,a=234},
	watertexture = "WaterCubesBlue_BlackTop_WhiteLowerTier.png",
	watertype = 2,
	towropes = jumping,
	airdebris_count = ifhifi(500,100),
	airdebris_density = ifhifi(10,2),
	useblackgrid=false,
	twistmode= {curvescaler=1.5,steepscaler=1.2},
	skywirecolor= "highway",
	dynamicFOV = false,
	numvisiblewaterchunks = 8,
	fogenabled = false,
	fogcolor={39,39,39},
	fogstart=700,
	fogend=1700
}

LoadSounds{
	hit="hit.wav",
	hitgrey="hitgrey.wav",
	trickfail="hitgrey.wav",
	matchsmall="matchsmall.wav",
	matchmedium="matchmedium.wav",
	matchlarge="matchlarge.wav",
	matchhuge="matchhuge.wav",
	overfillwarning="overfillwarning.wav"
}

if jumping then
	SetPlayer{
		cameramode = "first_jumpthird",

		camfirst={
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 1
		},
		camthird={
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 0.75,
			pos2={0,2.8,-3.50475},
			rot2={20.49113,0,0},
			strafefactorFar = 1},
		surfer={
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
				shader=ifhifi("RimLightHatchedSurferExternal","VertexColorUnlitTinted"),
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
				shader="RimLightHatchedSurferExternal",
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
	SetPlayer{
		cameramode = "third",
	
		camfirst={
			pos={1,1.84,-0.8},
			rot={20,0,0}},
		camthird={
			pos={0,3,-0.5},
			rot={30,0,0},
			pos2={0,5,-4},
			rot2={30,0,0},
			transitionspeed = 1,
			puzzleoffset=-0.70,
			puzzleoffset2=-1.60},
		vehicle={
			min_hover_height= 0.20,
			max_hover_height = 0.75,
			use_water_rooster = false,
			water_rooster_z_offset = 0,
            smooth_tilting = false,
            smooth_tilting_speed = 0,
            smooth_tilting_max_offset = 0,
			pos={x=0,y=0,z=0},
			mesh="ninjamono.obj",
			shader="VertexColorUnlitTinted",
			layer = 14,
			shadercolors={
				_Color = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=6}},
			texture="ninjaMono.png",
			scale = {x=1,y=1,z=1},
			thrusters = {crossSectionShape={{-.35,-.35,0},{-.5,0,0},{-.35,.35,0},{0,.5,0},{.35,.35,0},{.5,0,0},{.35,-.35,0}},
						perShapeNodeColorScalers={1,1,1,1,1,1,1},
						extrusions=20,
						stretch=-0.1191,
						updateseconds = 0.025,
						instances={
							{pos={0,.281,-1.33},rot={0,0,0},scale={0.75,0.75,0.75}},
							{pos={.1236,0.2,-1.297},rot={0,0,58.713},scale={.5,.5,.5}},
							{pos={-.1236,0.2,-1.297},rot={0,0,313.7366},scale={.5,.5,.5}}
						}}
		}
	}
end
randomSky = math.random(1,7)
SetSkybox{
	skysphere = "skyline_" .. randomSky .. ".jpg",
	skysphere = "skyline_" .. randomSky .. ".jpg",
	skysphere = "skyline_" .. randomSky .. ".jpg",
	skysphere = "skyline_" .. randomSky .. ".jpg",
	skysphere = "skyline_" .. randomSky .. ".jpg",
	skysphere = "skyline_" .. randomSky .. ".jpg",
	skysphere = "skyline_" .. randomSky .. ".jpg"
	}

SetTrackColors{
    {r=0, g=0, b=0},
    {r=255, g=0, b=255},
    {r=0, g=0, b=205},
    {r=50, g=205, b=50},
    {r=255, g=69, b=0},
    {r=255,g=0,b=0}
}

SetBlockColors{
	{r=93, g=8, b=132},
	{r=1.0, g=0.27, b=0.2},
	{r=0.047, g=0.5098, b=0.94},
	{r=1.0, g=0.85, b=0.4157},
	{r=0, g=0.29, b=0.08},
	{r=1,g=0,b=0}
}

if hifi then
	CreateLight{
		railoffset = -3,
		range = 10,
		intensity = 2,
		transform = {
			position={0,.5,0}
		},
		color="highway"
	}
end

SetRings{
	texture = "ring_1.jpg",
	layer=13,
	shader="VertexColorUnlitTintedAddSmooth",
	size=22,
	percentringed=.2,
	airtexture="ringOnTop.jpg",
	airshader="VertexColorUnlitTintedAddSmoothNoDepth",
	airsize=16
}



local laneDividers = skinvars["lanedividers"]

if #skinvars["lanedividers"] < 3 then wakeHeight=(ifhifi(3,2)) else wakeHeight = 0 end

SetWake{ --setup the spray coming from the two pulling "boats"
	height = wakeHeight,
	fallrate = 1.0,
	shader = "VertexColorUnlitTintedAddSmooth",
	layer = 13, -- looks better not rendered in background when water surface is not type 2
	bottomcolor = {r=0,g=0,b=0},
	topcolor = highway
}

CreateObject{
	name="EndCookie",
	tracknode="end",
	gameobject={
		transform={pos={0,0,126},scale={scaletype="intensity",min={55,99,900},max={66,120,900}}},
		mesh="danishCookie_boxes.obj",
		shader="RimLightHatched",
		shadercolors={
			_Color={0,0,0},
			_RimColor={1,1,1}
		}
	}
}


CreateObject{ 
	name="BuildingCloneMe",
	gameobject={
		pos={x=0,y=0,z=0},
		--mesh="skyscraper_withbase.obj",
		shader="PsychoBuilding2",
		diffuseinair = true,
		shadercolors={
			_Color = {colorsource="highwaysmooth", scaletype="intensity", minscaler=6, maxscaler=6}
		},
		texture="White.png",
		scale = {x=1,y=1,z=1}
	}
}


track = GetTrack()

if buildingNodes == nil then
	buildingNodes = {}
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
	end

	BatchRenderEveryFrame{prefabName="BuildingCloneMe",
							locations=buildingNodes,
                    		rotateWithTrack=false,
                    		maxShown=50,
                    		maxDistanceShown=2000,
							offsets=offsets,
							collisionLayer = 1,
							testAndHideIfCollideWithTrack=true
						}


end

CreateObject{
	railoffset=0,
	floatonwaterwaves = true,
	gameobject={
		name="scriptSkyWires",
		pos={x=0,y=0,z=0},
		mesh="skywires.obj",
		renderqueue=1000,
		layer=ifhifi(18,13),
		shader="VertexColorUnlitTintedSkywire",
		shadercolors={
			_Color="highway" --{r=255,g=0,b=0}
		},
		texture="White.png",
		scale = {x=1,y=1,z=1},
		lookat = "end"
	}
}

	for i=1,#laneDividers do
CreateRail{
	positionOffset={
		x=laneDividers[i],
		y=-3},
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
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=false,
	texture="White.png",
	shader="VertexColorUnlitTinted"}

end



CreateRail{
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

CreateRail{
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

CreateRail{
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

CreateRail{
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

CreateRail{
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

CreateRail{
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
	shader="VertexColorUnlitTintedAddSmoothNoCull"
}

CreateRail{
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
	shader="VertexColorUnlitTintedAddSmoothNoCull"
}

if hifi then
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
