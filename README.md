<h1>· J-UI</h1>

<h2>

>>Inspired In [QT-HUD](https://forum.cfx.re/t/paid-esx-qt-hud-clean-ui-custom/4800100)

</h2>

<h1> ·  Features</h1>
<h3>

* Cash & Bank UI
* Hunger & Thirst UI
* Speedometer UI
* User ID & Max Clients UI
* Voice UI (The voice switching mode is only compatible with pma-voice.)
</h3>

<h1>· Dependencies</h1>

>> [pma-voice](https://github.com/AvarianKnight/pma-voice)

<h1>· How to set the voice range change?</h1>
<hr>
<h3>- You need to have pma-voice on your server.</h3>

<h4> - Go to pma-voice/client/commands.lua</h4>
<h2>And put this below</h2>

```lua
TriggerEvent('pma-voice:setTalkingMode', voiceMode)
```

<hr>

```lua
if voiceMode == 3 then 
	voiceMode = "G"
elseif voiceMode == 1 then
	voiceMode = "S"
elseif voiceMode == 2 then
	voiceMode = "N"
end
exports["j-ui"]:setLevel(voiceMode)
```

<h1> ·  In Game Preview</h1>

>> Download: [Github]()


<img src = "https://cdn.discordapp.com/attachments/886714318471712798/929864921104150538/unknown.png">
<hr>
<div align = "center">
<h1>Made with love, and with the help of 
<h1>Medinaa#7364, Roderic#0614.
 & 𝔼𝕝 ℙ𝕒𝕥𝕣𝕠𝕟#1119</h1>
