self = {}

self.core = exports.es_extended:getSharedObject();

self.core.RegisterServerCallback('j-ui:getPlayers', function(source, cb)
    cb(#self.core.GetPlayers())
end)