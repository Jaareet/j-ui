$(function(){
    $(".voiceMode").fadeOut(300);
    $(".speedometer").fadeOut(300);
    $(".seatbelt").fadeOut(300);
    $(".cruiser").fadeOut(300);

    window.addEventListener("message", function(event){
        let srv = event.data;

        self = {}

        self.speedometer = $(".speedometer");
            
        self.km = $(".km");
        
        self.cruiser = $(".cruiser");

        self.seatBelt = $(".seatbelt");


        if (srv.action == "showHud") {
            self.hud = $("body");
            self.clockIcon = $(".timeIcon");
            self.time = $(".time");
            self.date = $(".date");
            self.micMode = $(".voiceMode");
            self.mic = $(".microPhone");
            self.wallet = $(".wallet");
            self.bank = $(".bank");
            self.bankAccount = $(".bankAc");
            self.bankIcon = $(".bIcon");
            self.foodIcon = $(".fIcon");
            self.waterIcon = $(".wIcon");
            self.food = $(".food");
            self.water = $(".water");
            self.playerIDIcon = $(".idCard");
            self.maxClientsIcon = $(".mClientsIcon");
            self.playerID = $(".idCount");
            self.maxClients = $(".mClientsCount");
            self.serverIcon = $(".serverIcon");
            self.playerIDIcon.addClass("fas fa-id-card");
            self.maxClientsIcon.addClass("fas fa-users");
            self.bankIcon.addClass("fas fa-university");
            self.foodIcon.addClass("fas fa-utensils");
            self.waterIcon.addClass("fas fa-glass");
            self.clockIcon.addClass("fas fa-clock");
            self.food.text(srv.food);
            self.water.text(srv.thirst);
            self.wallet.text("$"+ srv.money);
            self.bankAccount.text("$"+ srv.bank);
            let hourText = '';
            let date = new Date();
            hourText += date.getHours() + ':' + (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes())
            hourText += (date.getHours() < 13 && date.getHours() > 23 ? ' AM' : ' PM')
            self.time.text(hourText);
            let dateText = '';
            dateText += (date.getDate() > 9 ? date.getDate() : '0' + date.getDate()) + '/';
            dateText += ((date.getMonth() + 1) < 10 ?  '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '/';
            dateText += date.getFullYear();
            self.date.text(dateText);
            self.serverIcon.html("<img src = '"+srv.svIcon+"'>");
            self.playerID.text(": "+srv.pID);
            self.maxClients.text(": "+srv.playersConnected);
            if (srv.action == "speaking") {
                self.mic.removeClass("fas fa-microphone-slash").addClass("fas fa-microphone").addClass("speaking");
            } else if (srv.action == "notSpeaking") {
                self.mic.removeClass("fas fa-microphone").removeClass("speaking").addClass("fas fa-microphone-slash");
            }
            if (srv.action == "setLevel") {
                self.micMode.fadeIn("300").text(srv.level);
                setTimeout(function(){
                    self.micMode.fadeOut("300")
                }, srv.duration);
            }
        } else if (srv.action == "speedometer") {
            if (srv.inCar == true) {
                self.speedometer.fadeIn(300);
                self.km.text(Math.round(srv.speed) + " KM/h");
            } else if (srv.inCar == false) {
                self.speedometer.fadeOut(300);
                self.seatBelt.fadeOut(300);
                self.cruiser.fadeOut(300);
            }
        } else if (srv.seatBelt == true && srv.action == "seatBelt") {
            self.seatBelt.fadeIn(300);
        } else if (srv.seatBelt == false && srv.action == "seatBelt") {
            self.seatBelt.fadeOut(300);
        }
        if (srv.cruiser == true && srv.action == "cruiser") {
            self.cruiser.fadeIn(300);
        } else if (srv.cruiser == false && srv.action == "cruiser") {
            self.cruiser.fadeOut(300);
        }
    })
});