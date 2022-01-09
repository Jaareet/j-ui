self = {}

self.core = exports.es_extended:getSharedObject();

self.thread = CreateThread

self.triggerEvent = TriggerEvent

self.sendNUI = SendNUIMessage

self.addCommand = RegisterCommand

self.keyMap = RegisterKeyMapping

self.playersConnected = 0;

self.wait = function(msec)
    return Wait(msec)
end

self.sendNotification = function(message)
    SetNotificationTextEntry('STRING')
	AddTextComponentString(message)
	DrawNotification(0,1)
end

self.serverIcon = function()
    return Cfg.svIcon
end

self.playerID = function()
    return PlayerId();
end

self.playerPed = function()
   return PlayerPedId();
end

self.getVehicle = function()
    return GetVehiclePedIsIn(self.playerPed())
end

self.getPlayerName = function()
    return GetPlayerName(self.playerID());
end

self.getServerID = function()
    return GetPlayerServerId(self.playerID());
end

self.speakCheck = function()
    return NetworkIsPlayerTalking(self.playerID());
end

self.getSpeed = function()
    return GetEntitySpeed(self.playerPed());
end

self.getVehClass = function()
    return GetVehicleClass(GetVehiclePedIsIn(self.playerPed(), false));
end

self.isInVehicle = function()
    return IsPedInAnyVehicle(self.playerPed());
end

self.setVehicleSeat = function(seat)
    return GetPedInVehicleSeat(self.getVehicle(), seat);
end

self.round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

self.getSpeed = function()
    return GetEntitySpeed(self.getVehicle());
end

self.tickTimerCount = 0

self.showHud = function()
    while true do
        self.food = self.food or "N/A";
        self.thirst = self.thirst or "N/A";
        self.money = self.money or "N/A";
        self.bank = self.bank or "N/A";
        self.playerData = self.core.GetPlayerData();
        self.triggerEvent('esx_status:getStatus', 'hunger', function(status) self.food = status.val / 10000 end)    
        self.triggerEvent('esx_status:getStatus', 'thirst', function(status) self.thirst = status.val / 10000 end)

        for k,v in pairs(self.playerData.accounts) do
            if v.name == "money" then 
                self.money = v.money
            elseif v.name == "bank" then
                self.bank = v.money
            end
        end

        if (GetGameTimer() - self.tickTimerCount) > 30000 then
            SetTimeout(1000, function()
                self.tickTimerCount = GetGameTimer()
                self.core.TriggerServerCallback('j-ui:getPlayers', function(players)
                    print(players)
                    self.playersConnected = players
                end)
            end)
        end

        if self.speakCheck() then
            self.sendNUI({
                action = "speaking";
            })
        else
            self.sendNUI({
                action = "notSpeaking";
            })
        end

        SetTimeout(1500, function()
            print(self.playersConnected)
            self.sendNUI({
                action = "showHud";
                food = self.round(self.food);
                money = self.money;
                bank = self.bank;
                thirst = self.round(self.thirst);
                svIcon = self.serverIcon();
                pID = self.getServerID();
                pName = self.getPlayerName();
                playersConnected = self.playersConnected
            })
        end)

        self.wait(2000)
    end
end

self.showCarHUD = function()
    local seatBelt = false
    local cruiser = false
    local inHelicopter = false
    local inAirPlane = false
    local inAnyBoat = false 
    local inBike = false 
    local inAnyCar = false
    local inMotorcycle = false
    while Cfg.CarHUD == true do
        local sleep = 1000
        local km = (self.getSpeed()* 3.6)
        if self.isInVehicle() then 
            sleep = 100
            inHelicopter = false
            inAirPlane = false
            inAnyBoat = false 
            inBike = false 
            inAnyCar = false
            inMotorcycle = false
            local vc = self.getVehClass()
            if( (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)) then
                inAnyCar = true
            elseif(vc == 8) then
                inMotorcycle = true
            elseif(vc == 13) then
                inBike = true
            elseif(vc == 14) then
                inAnyBoat = true
            elseif(vc == 15) then
                inHelicopter = true
            elseif(vc == 16) then
                inAirPlane = true
            end
            self.sendNUI({
                action = "speedometer";
                inCar = true;
                speed = km;
            })
        else
            self.sendNUI({
                action = "speedometer";
                inCar = false;
            })
            sleep = 1000
        end
        self.wait(sleep)
    end
end

self.selectVoice = function(level)
    self.sendNUI({
        action = "setLevel";
        level = level;
        duration = 1000;
    })
end

exports("setLevel", self.selectVoice)

local first = false

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        first = true

        self.thread(self.showCarHUD)
        self.thread(self.showHud)
    end
end)

RegisterNetEvent('esx:playerLoaded', function()
    if not first then
        first = true

        self.thread(self.showCarHUD)
        self.thread(self.showHud)
    end
end)

SetTimeout(4000, function()

end)

self.addCommand("cruiser", function()
    if self.isInVehicle(self.playerPed(), false) then
        if self.setVehicleSeat(-1) == self.playerPed() then
            if not inBike then
                if not inAnyBoat then
                    if not inHelicopter then
                        if not cruiser then
                            self.sendNUI({
                                action = "cruiser";
                                cruiser = true;
                            })
                            local speed = self.getSpeed()
                            maxSpeed = self.round(GetVehicleEstimatedMaxSpeed(vehicle)* 3.6, 2)
                            self.sendNotification("Limiter ~b~posted~s~ a: " .. self.round(math.floor(GetEntitySpeed(ped) * 3.6 * 100)/100, 0) .. " KM/h")
                            SetVehicleMaxSpeed(vehicle,  speed)
                            cruiser = true
                        else
                            self.sendNUI({
                                action = "cruiser";
                                cruiser = false;
                            })
                            self.sendNotification("Limiter ~b~removed")
                            SetVehicleMaxSpeed(vehicle, maxSpeed)
                            cruiser = false
                        end
                    else
                        self.sendNotification("~r~You cannot put the limiter on a helicopter.")
                    end
                else
                    self.sendNotification("~r~You can't put the limiter on a boat")
                end
            else
                self.sendNotification("~r~You can't put the limiter on a bike")
            end
        else
            self.sendNotification('~r~You are not the driver')
        end
    end
end)

self.addCommand("seatBelt", function()
    if self.isInVehicle(self.playerPed(), false) then
        if not inMotorcycle then
            if not inBike then
                if not inAnyBoat then
                    if not inHelicopter then
                        if not seatBelt then
                            seatBelt = true
                            self.sendNotification("Belt ~b~on")
                        else
                            seatBelt = false
                            self.sendNotification("Belt ~r~removed")
                        end
                    else
                        self.sendNotification("~r~No belt a Helicopter")
                    end
                else
                    self.sendNotification("~r~There is no belt on a ship")
                end
            else
                self.sendNotification("~r~No seat belt on a motorcycle")
            end
        else
            self.sendNotification("~r~No seat belt on a bike")
        end
    else
        seatBelt = false;
    end
    self.sendNUI({
        action = "seatBelt";
        seatBelt = seatBelt;
    })
end)

self.keyMap(
    "seatBelt",
    "Fasten your seat belt.",
    "keyboard",
    "B"
)

self.keyMap(
    "cruiser", 
    "Activates the limiter", 
    "keyboard", 
    "1"
)