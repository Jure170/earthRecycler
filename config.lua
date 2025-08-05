Config = {}

Config.Recikler = {
    model = "p_rail_controller_s",
    coords = vec3(-433.4, -1724.24, 18.92),
    heading = 160.43,
    radius = 50.0,
    stashId = "reciklerStash",
    blip = {
        enabled = true,
        sprite = 365,
        scale = 1.1,
        color = 26,
        label = "Recikler"
    },
    items = {
        ["faketablice"] = {
            gives = {
                { item = "popravka", amount = 1 }
            }
        },
    }
}