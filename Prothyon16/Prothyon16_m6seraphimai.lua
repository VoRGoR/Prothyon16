local BaseManager = import('/lua/ai/opai/basemanager.lua')
local NavalOSB = import('/lua/ai/opai/GenerateNaval.lua')

local SPAIFileName = '/lua/scenarioplatoonai.lua'

# ------
# Locals
# ------
local Seraphim = 5

# -------------
# Base Managers
# -------------
local SeraphimM6IslandBase = BaseManager.CreateBaseManager()

function SeraphimM6IslandBaseAI()
	SeraphimM6IslandBase:Initialize(ArmyBrains[Seraphim], 'M6_Seraphim_Island_Base', 'M6_Seraphim_Island_Base_Marker', 150,
        {
             M6_Sera_MEX1 = 1000,
             M6_Sera_FACT1 = 950,
             M6_Sera_FACT2 = 900,
             M6_Sera_MEX2 = 850,
             M6_Sera_PWR1 = 800,
             M6_Sera_FACT3 = 750,
             M6_Sera_PWR2 = 700,
             M6_Sera_MSTR1 = 650,
             M6_Sera_FACT4 = 600,
             M6_Sera_MEX3 = 550,
             M6_Sera_DEF1 = 500,
             M6_Sera_SHD1 = 450,
             M6_Sera_FACT5 = 400,
             M6_Sera_DEF2 = 350,
             M6_Sera_SHD2 = 300,
             M6_Sera_PWR3 = 250,
             M6_Sera_MISC1 = 200,
             M6_Sera_DEF3 = 150,
         }
    )
    SeraphimM6IslandBase:StartEmptyBase(25)
    # SeraphimM6IslandBase:SetConstructionAlwaysAssist(true)
    SeraphimM6IslandBase:SetMaximumConstructionEngineers(5)
    # SeraphimM6IslandBase.SetFactoryBuildRateBuff = 'BaseManagerFactoryDefaultBuildRate'
    # SeraphimM6IslandBase.SetEngineerBuildRateBuff = 'BaseManagerEngineerDefaultBuildRate'

    SeraphimM6IslandBase:SetActive('AirScouting', true)

end

function NewEngineerCount()
    SeraphimM6IslandBase:SetEngineerCount({25, 20})
    SeraphimM6IslandBase:SetMaximumConstructionEngineers(5)
end

function SeraphimM6IslandBaseAirAttacks()
	local opai = nil

    for i = 1, 2 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirAttack1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
                PlatoonData = {
                    PatrolChains = {'M6_Sera_Island_Air_Attack_Chain_1', 'M6_Sera_Island_Air_Attack_Chain_2', 'M6_Sera_Island_Air_Attack_Chain_3'},
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('Gunships', 24)
    end

    for i = 1, 4 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirAttack2_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChains = 'M6_Sera_Island_Air_Attack_Chain_4',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('TorpedoBombers', 12)
        opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain', 'Player', 20, categories.NAVAL * categories.MOBILE})
    end

    for i = 1, 3 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirAttack3_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
                PlatoonData = {
                    PatrolChains = {'M6_Sera_Island_Air_Attack_Chain_1', 'M6_Sera_Island_Air_Attack_Chain_2', 'M6_Sera_Island_Air_Attack_Chain_3'},
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('Interceptors', 30)
        opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain', 'Player', 60, categories.AIR * categories.MOBILE})
    end

    for i = 1, 3 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirAttack4_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
                PlatoonData = {
                    PatrolChains = {'M6_Sera_Island_Air_Attack_Chain_1', 'M6_Sera_Island_Air_Attack_Chain_2', 'M6_Sera_Island_Air_Attack_Chain_3'},
                },
                Priority = 110,
            }
        )
        opai:SetChildQuantity('CombatFighters', 20)
        opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain', 'Player', 100, categories.AIR * categories.MOBILE})
    end

	# -----------
	# Air Defense
	# -----------
	# maintains 3 x 6 [air superiority]
    for i = 1, 3 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirDefense1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M6_Sera_Island_Base_AirDef_Chain',
                },
                Priority = 110,
            }
        )
        opai:SetChildQuantity('AirSuperiority', 6)
    end

    # maintains 6 x 4 [gunships]
    for i = 1, 6 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirDefense2_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M6_Sera_Island_Base_AirDef_Chain',
                },
                Priority = 110,
            }
        )
        opai:SetChildQuantity('Gunships', 4)
    end

    # maintains 5 x 5 [torp bombers]
    for i = 1, 5 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirDefense3_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M6_Sera_Island_Base_AirDef_Chain',
                },
                Priority = 110,
            }
        )
        opai:SetChildQuantity('TorpedoBombers', 5)
    end

    # maintains 3 x 3 [torp bombers]
    for i = 1, 3 do
        opai = SeraphimM6IslandBase:AddOpAI('AirAttacks', 'M6_Sera_Island_AirDefense4_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M6_Sera_Island_Base_AirDef_Chain',
                },
                Priority = 110,
            }
        )
        opai:SetChildQuantity('StratBombers', 3)
    end
end

function SeraphimM6IslandBaseNavalAttacks()

    local opai = nil
    local NavyOSB = nil
    
    NavyOSB = NavalOSB.GenerateNavalOSB('M6_Sera_Island_Naval_1' , 5, 40, 60, 'S', 100, nil, nil)
    opai = SeraphimM6IslandBase:AddOpAI(NavyOSB, 'M6_Sera_Island_Naval_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
            },
        }
    )
    opai:SetChildActive('T3', false)

    NavyOSB = NavalOSB.GenerateNavalOSB('M6_Sera_Island_Naval_2' , 5, 30, 50, 'S', 100, nil, nil)
    opai = SeraphimM6IslandBase:AddOpAI(NavyOSB, 'M6_Sera_Island_Naval_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
            },
        }
    )
    opai:SetChildActive('T3', false)

    NavyOSB = NavalOSB.GenerateNavalOSB('M6_Sera_Island_Naval_3' , 5, 40, 50, 'S', 100, nil, nil)
    opai = SeraphimM6IslandBase:AddOpAI(NavyOSB, 'M6_Sera_Island_Naval_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
            },
        }
    )
    opai:SetChildActive('T3', false)

    NavyOSB = NavalOSB.GenerateNavalOSB('M6_Sera_Island_Naval_4' , 5, 35, 55, 'S', 100, nil, nil)
    opai = SeraphimM6IslandBase:AddOpAI(NavyOSB, 'M6_Sera_Island_Naval_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
            },
        }
    )
    opai:SetChildActive('T3', false)

end
--[[
function SeraphimM6IslandBaseNavalAttacks()
    local Base = ScenarioFramework.GetCatUnitsInArea((categories.ALLUNITS * categories.STRUCTURE - categories.MOBILE), 'M6_Sera_Base_Area', ArmyBrains[Seraphim])

    local Temp = {
        'SeraM6NavalAttackPlayerTemp1',
        'NoPlan',
        { 'xss0201', 1, 6, 'Attack', 'AttackFormation' },   # Destroyers
        { 'xss0202', 1, 2, 'Attack', 'AttackFormation' },   # Cruisers
        { 'xss0203', 1, 8, 'Attack', 'AttackFormation' },   # T1 Sub
    }
    local Builder = {
        BuilderName = 'SeraM6NavyAttackPlayerBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 200,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = Base,
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
        },
    }
    ArmyBrains[Seraphim]:PBMAddPlatoon( Builder )

    Temp = {
        'SeraM6NavalAttackPlayerTemp2',
        'NoPlan',
        { 'xss0201', 1, 2, 'Attack', 'AttackFormation' },   # Destroyers
        { 'xss0103', 1, 12, 'Attack', 'AttackFormation' },   # Frigate
    }
    Builder = {
        BuilderName = 'SeraM6NavyAttackPlayerBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 200,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = Base,
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
        },
    }
    ArmyBrains[Seraphim]:PBMAddPlatoon( Builder )

    Temp = {
        'SeraM6NavalAttackPlayerTemp3',
        'NoPlan',
        { 'xss0201', 1, 4, 'Attack', 'AttackFormation' },   # Destroyers
    }
    Builder = {
        BuilderName = 'SeraM6NavyAttackPlayerBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 200,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = Base,
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
        },
    }
    ArmyBrains[Seraphim]:PBMAddPlatoon( Builder )

    Temp = {
        'SeraM6NavalT3AttackPlayerTemp1',
        'NoPlan',
        { 'xss0302', 1, 1, 'Attack', 'GrowthFormation' },   # Battleship
        { 'xss0201', 1, 2, 'Attack', 'GrowthFormation' },   # Destroyers
        { 'xss0203', 1, 3, 'Attack', 'GrowthFormation' },   # T1 Sub
    }
    Builder = {
        BuilderName = 'SeraM6NavyT3AttackPlayerBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 300,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = Base,
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
        },
    }
    ArmyBrains[Seraphim]:PBMAddPlatoon( Builder )

    Temp = {
        'SeraM6NavalT3AttackPlayerTemp2',
        'NoPlan',
        { 'xss0201', 1, 5, 'Attack', 'AttackFormation' },   # Destroyers
        { 'xss0202', 1, 2, 'Attack', 'AttackFormation' },   # Cruisers
        { 'xss0103', 1, 9, 'Attack', 'AttackFormation' },   # Frigate
    }
    Builder = {
        BuilderName = 'SeraM6NavyT3AttackPlayerBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 200,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = Base,
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M6_Sera_Island_Naval_Attack_Chain_1',
        },
    }
    ArmyBrains[Seraphim]:PBMAddPlatoon( Builder )
end
]]--