Config = {}

Config.OpenKey = 38 -- E
Config.DrawDistance = 12.0
Config.InteractDistance = 1.8
Config.MarkerType = 2

Config.Text = {
    open = '~g~E~w~ - Elevator',
    invalidFloor = 'Floor does not exist',
    alreadyOnFloor = 'You are already on floor %s',
    selectedFloor = 'Selected floor: %s',
    arrived = 'Arrived at floor %s'
}

Config.Elevators = {
    {
        name = 'Police Elevator 1',
        floors = {
            [0] = {
                label = 'Police Floor 0',
                coords = vector4(-406.97, -345.17, 38.43, 281.3)
            },
            [1] = {
                label = 'Police Floor 1',
                coords = vector4(-406.88, -345.49, 43.59, 254.19)
            },
            [2] = {
                label = 'Police Floor 2',
                coords = vector4(-407.12, -345.43, 48.54, 266.29)
            },
            [3] = {
                label = 'Police Floor 3',
                coords = vector4(-406.50, -345.33, 53.26, 256.06)
            }
        }
    },
    {
        name = 'Police Elevator 2',
        floors = {
            [0] = {
                label = 'Police Floor 0',
                coords = vector4(-407.31, -348.10, 38.43, 253.18)
            },
            [1] = {
                label = 'Police Floor 1',
                coords = vector4(-407.31, -348.24, 43.59, 260.87)
            },
            [2] = {
                label = 'Police Floor 2',
                coords = vector4(-407.16, -348.27, 48.54, 260.24)
            },
            [3] = {
                label = 'Police Floor 3',
                coords = vector4(-407.19, -348.35, 53.26, 262.83)
            }
        }
    }
}
