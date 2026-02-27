
local seed = 6276
local delay = 50
local delayht = 100
local mag = {x = 0, y = 0}
local min_uws = 2605
local size_world = {col = GetWorld().width, row = GetWorld().height}
local usings_uws = false
local allowed_users = {
    [9339187] = true,
    [26008716] = true,
    [32295067] = true,
    [26970214] = true,
    [8441787] = true,
}

local me = GetLocal()
if not me or not allowed_users[me.userid] then
    SendVariantList({
        [0] = "OnTextOverlay",
        [1] = "`4ACCESS DENIED! `oLol Hapus aja scnya"
    }, -1, 1)
    return
end

function zaxmsg(text)
local eja = "`o[ZaXploit] `w"..text
SendPacket(2, [[action|input
|text|]] .. eja)
end

function bubble(text)
if not GetLocal() then return end
SendVariantList({
[0] = "OnTalkBubble",
[1] = GetLocal().netid,
[2] = "`o[ZaXploit]`w "..text,
[3] = 0,
[4] = 1
})
Sleep(10)
end

local function action(x, y, itemid)
    local me = GetLocal()
    if not me then return end
    SendPacketRaw(false,  {
        type = 3,
        state = GetLocal().isleft and 2608 or 2592,
        int_data = itemid,
        int_x = x,
        int_y = y,
        pos_x = x * 32,
        pos_y = y * 32
    })
end

local function tp(x, y)
    SendPacketRaw(false, {
        type = 3,
        pos_x = x * 32,
        pos_y = y * 32
    })
end


function take_remote(x, y)
Sleep(20)
SendPacket(2, [[action|dialog_return
dialog_name|itemsucker_block
tilex|]]..x..[[|
tiley|]]..y..[[|
buttonClicked|getplantationdevice]].."\n")
end

local function drop(itemid, count)
SendPacket(2, [[action|dialog_return
dialog_name|drop_item
itemID|]]..itemid..[[|
count|]]..count.."\n")
end

function using_uws()
SendPacket(2, "action|dialog_return\ndialog_name|world_spray".."\n")
end


AddHook("OnVariant", "adwadas", function(var)
    if var[0] == "OnDialogRequest"
    and var[1]:find("end_dialog|world_spray") then
        if not usings_uws then return true end
        local minimal = tonumber(var[1]:match("add_textbox|There is `2(%d+)")) or 0
        if minimal >= min_uws then
            zaxmsg("jir siapa yang nge uws? (smile)")
            using_uws()
        end 
        return true
    end
    if var[0] == "OnTalkBubble" and var[2]:find("The `2MAGPLANT 5000`` is empty!") then
        -- ini belum di setting kontol
    end
end)

function plant()
    if not GetLocal() then return end
    local col = size_world.col
    local row = size_world.row
    local count = 0
    local found = false
    for y = 0, row - 1 do
        for x = 0, col - 1 do
            local tile = GetTile(x, y)
            local below = GetTile(x, y + 1)

            if tile and below and tile.fg == 0 and below.fg ~= 0 then
                found = true
                tp(x, y)
                Sleep(10)
                action(x, y, 5640)
                Sleep(delay)
                count = count + 1
                bubble("Planting `5"..count)
                if count > 99 then
                    return plant()
                end
            end
        end
    end
    if not found then return end
end

local function harvest()
    local me = GetLocal()
    if not me then return end

    local col = size_world.col
    local row= size_world.row
    local count = 0
    local found = false

    for x = 0, col - 1 do
        for y = 0, row - 1 do
            local tile = GetTile(x, y)
            if tile and tile.fg == seed and tile.extra and tile.extra.progress == 1.0 then
                found = true
                tp(x, y)
                Sleep(10)
                action(x, y, 18)
                Sleep(delayht)
                count = count + 1
                bubble("Harvesting `5"..count)
                if count > 99 then return harvest() end
            end
        end
    end
    if not found then return end
end

        
function listmag()
    local text = ""
    for _, tile in pairs(GetTiles()) do
        if not GetLocal() then return "" end
        if tile.fg == 5638 or tile.fg == 5930 or tile.fg == 9850 or tile.fg == 10266 or tile.fg == 21220 then
            text = text.."add_label_with_icon|small|`2"..tile.fg.." "..GetItemByIDSafe(tile.fg).name.." `8X: `5"..tile.x.."`8 Y: `5"..tile.y.."|left|"..tile.fg.."\n"
        end
    end
    return text
end

SendVariantList({
    [0] = "OnDialogRequest",
    [1] = [[
set_default_color|`o
set_border_color|255,222,0,255
set_bg_color|0,0,0,255
add_label_with_icon|big|PTHT `9ZAXPLOIT|left|5956|
add_textbox|`9#New Script `4BrigPer|
add_textbox|`9#Auto `2Reconnect|
add_textbox|`9#Auto `2UWS|
add_spacer|small|
add_label_with_icon|small|`9List Mag Position:|left|5638|
]]..listmag()..[[
add_spacer|small|
add_textbox|#`2Put Only Number|
add_spacer|small|
add_label_with_icon|small|Size World `5X,Y|left|123|
add_text_input|zax_size_x|COL:|]]..size_world.col..[[|8|
add_text_input|zax_size_y|ROW:|]]..size_world.row..[[|8|
add_spacer|small|
add_label_with_icon|small|Magplant `5X,Y|left|5638|
add_text_input|zax_x|X:|]]..mag.x..[[|8|
add_text_input|zax_y|Y:|]]..mag.y..[[|8|
add_spacer|small|
add_label_with_icon|small|SeedID `5Need for harvest|left|]]..seed..[[|
add_text_input|zax_seed||]]..seed..[[|8|
add_spacer|small|
add_label_with_icon|small|Delay|left|5806|
add_text_input|zax_delay||]]..delay..[[|8|
add_text_input|zax_delayht||]]..delayht..[[|8|
add_spacer|small|
add_label_with_icon|small|Minimal Using UWS|left|5806|
add_textbox|`9(Jika Seed Yang Belum Ready Ada `2]]..min_uws..[[ `oMaka UWS)|
add_textbox|`9(Jika Kurang Dari `2]]..min_uws..[[ `oMaka UWS Tidak Dilaksanakan)|
add_text_input|zax_min||]]..min_uws..[[|8|
add_checkbox|checkbox_uws|Auto UWS|0
add_spacer|small|
add_textbox|Klik `2OK buat jalanin|
end_dialog|zax_zax_ngentot_dialog|Baca Doang|OK|
add_spacer|small|]],

})
RunThread(function()
    zaxmsg("`4PTEW `weh `2PTHT `wOpening Settings")
    Sleep(3000)
    zaxmsg("so inggris banget jing (sigh)")
end)
function main()
    RunThread(function()
        while true do
            if GetItemCount(5640) < 1 then zaxmsg("ngambil remote") Sleep(200) take_remote(mag.x, mag.y) end
            if not GetLocal() then Sleep(1000) end
            take_remote(mag.x, mag.y)
            Sleep(1000)
            zaxmsg("(tongue) nanem biji konnttoolll...")
            plant()
            Sleep(10000)
            zaxmsg("(smile) Nyawitt...")
            harvest()
            Sleep(10000)
        end
    end)
end

AddHook("OnSendPacket", "dwadds", function(type, packet)
    if type == 2 and packet:find("dialog_name|zax_zax_ngentot_dialog") then
        local checkuws = packet:match("checkbox_uws|(%d+)")
        local zax_verif = packet:match("zax_verif|(%d+)")
        local zax_seed = packet:match("zax_seed|(%d+)")
        local zax_delay = packet:match("zax_delay|(%d+)")
        local zax_delayht = packet:match("zax_delayht|(%d+)")
        local zax_x = packet:match("zax_x|(%d+)")
        local zax_y = packet:match("zax_y|(%d+)")
        local zax_min = packet:match("zax_min|(%d+)")
        local zax_size_x = packet:match("zax_size_x|(%d+)")
        local zax_size_y = packet:match("zax_size_y|(%d+)")
        
        delayht = tonumber(zax_delayht)
        seed = tonumber(zax_seed)
        delay = tonumber(zax_delay)
        min_uws = tonumber(zax_min)
        mag = {x = tonumber(zax_x), y = tonumber(zax_y)}
        size_world.col = tonumber(zax_size_x)
        size_world.row = tonumber(zax_size_y)
        local confirm_uws = ""
        local uws = tonumber(checkuws)
        usings_uws = (uws == 1)
        
        local confirm_uws = ""
        if uws == 0 then
            confirm_uws = "`4Disabled"
        elseif uws == 1 then
            confirm_uws = "`2Enabled"
        else
            confirm_uws = "`4Error Input"
        end
        
        
        SendVariantList({
            [0] = "OnDialogRequest",
            [1] = [[
set_default_color|`o
set_border_color|255,222,0,255
set_bg_color|0,0,0,255
add_label_with_icon|big|Info `9ZAXPLOIT|left|5956|
add_spacer|small|
add_textbox|Your Mag Position: X: `5]]..mag.x..[[ `oY: `5]]..mag.y..[[|
add_textbox|Your Seed: `5]]..seed..[[|
add_textbox|Your Delay Plant: `5]]..delay..[[|
add_textbox|Your Delay Harvest: `5]]..delayht..[[|
add_textbox|Using UWS: ]]..confirm_uws..[[|
add_textbox|Minimal Using UWS: ]]..min_uws..[[ seed|
add_spacer|small|
end_dialog|ewean|`5MONYET||]],
})
            main()
            RunThread(function()
                while true do
                    local me = GetLocal()
                    if not me then
                        Sleep(1000)
                    else
                        if GetItemCount(5926) > 0 then 
                            if usings_uws then
                                action(math.floor(me.pos.x / 32), math.floor(me.pos.y / 32), 5926)
                                Sleep(300)
                            end
                        else
                            Sleep(5000)
                            zaxmsg("lu gapunya `2"..GetItemByIDSafe(5926).name.."`w jir sosoan aktifin auto uws")
                            usings_uws = false
                        end
                    end
                    Sleep(10000)
                end
            end)
        end
    end)

    RunThread(function()
    while true do
        if not GetLocal() then 
            Sleep(2000)
        else
            local uws_count = GetItemCount(5926)

            if uws_count > 0 and not usings_uws then
                usings_uws = true
                Sleep(5000)
                zaxmsg("`2UWS ada auto pake uws lah bangsat!")
            end
        end
        Sleep(5000)
    end
end)

function exchange()
if not GetLocal() then return end
SendPacket(2, [[action|dialog_return
dialog_name|exchange_go
buttonClicked|ex_3412001000210]].."\n")
end
function exchangeuws()
if not GetLocal() then return end
SendPacket(2, [[action|dialog_return
dialog_name|exchange_go
buttonClicked|ex_100022592610]].."\n")
end
local uwscount = GetItemCount(5926)
local btccount = GetItemCount(10002)
RunThread(function()
    while true do
        if not GetLocal() then return end
        if GetItemCount(341) == 200 then
            zaxmsg("Mencoba exchange seed ke btc")
            exchange()
            Sleep(1000)
            if btccount > btccount then
                Sleep(5000)
                zaxmsg("`2Berhasil exchange btc")
            else
                Sleep(5000)
                zaxmsg("`4Gagal anying (mad)")
            end
        end
        if GetItemCount(10002) >= 2 then
            zaxmsg("Mencoba exchange uws")
            exchangeuws()
            Sleep(3000)
            if uwscount > uwscount then 
                Sleep(5000)
                zaxmsg("`2Berhasil exchange")
            else
                Sleep(5000)
                zaxmsg("`4Exchange gagal")
            end
        end
        Sleep(10000)
    end
end)



--0: OnDialogRequest
--1:
--set_border_color|112,86,191,255
--set_bg_color|43,34,74,200
--set_default_color|`o
--add_label_with_icon|big|`wUltra World Spray``|left|5926|
--add_spacer|small|
--add_textbox|There is `22457`` ungrown tree that this spray will work on.|
--add_spacer|small|
--add_textbox|Are you sure you want to use the Ultra World Spray on this world?|
--end_dialog|world_spray|No|Yes|
--
--add_quick_exit|
--
--[sendpacket] type: 2
--action|dialog_return
--dialog_name|world_spray
--
--got raw packet: 13 [PACKET_MODIFY_ITEM_INVENTORY]
--got raw packet: 1 [PACKET_CALL_FUNCTION]
--0: OnConsoleMessage
--1: Calmdown with the world spray.. (`$Ultra World Spray!`` mod added, `$4 minutes, 10 seconds`` left)