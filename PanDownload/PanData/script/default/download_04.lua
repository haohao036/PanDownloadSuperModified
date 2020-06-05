local curl = require "lcurl.safe"
local json = require "cjson.safe"

script_info = {
    ["title"] = "亿寻下载通道",
    ["description"] = "百度网盘亿寻下载脚本，不登录，不限速",
    ["version"] = "0.0.2",
	["color"] = "66ccff",
}

accelerate_url = "https://d.pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload"

function onInitTask(task, user, file)
    if task:getType() ~= TASK_TYPE_SHARE_BAIDU then
        return false
    end
    local data = ""
    local yxdata = "app_id=250528&check_blue=1&es=1&esl=1&ver=4.0&dtype=1&err_ver=1.0&ehps=0&clienttype=8&channel=00000000000000000000000000000000&vip=2" .. string.gsub(string.gsub(file.dlink, "https://d.pcs.baidu.com/file/", "&path="), "?fid", "&fid") .. "&version=6.9.5.1&devuid=BDIMXV2%2DO%5F695C875B600E456DB5AB269BEE090BF4%2DC%5F0%2DD%5FWXE1A379KL9F%2DM%5FB888E3E2DC78%2DV%5F4C9746C8&rand=6cdb35557c40899b728205b7b29659d3557208f1&time=1588786260"
    local header = { "User-Agent: netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia" }
    pd.messagebox("选择下载接口时，建议使用推荐接口，下载速度更快", "提示")
    table.insert(header, "Cookie: BDUSS=TVHWXN0UFhZTHJvNmVrSG1MejQwYU41M0h6eldXYjdwV0FycURidDd4NG5nZHBlRVFBQUFBJCQAAAAAAQAAAAEAAACNjg8Sb3N1eXZmcwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACf0sl4n9LJeN")
    local c = curl.easy {
        url = accelerate_url,
        post = 1,
        postfields = yxdata,
        httpheader = header,
        timeout = 15,
        ssl_verifyhost = 0,
        ssl_verifypeer = 0,
        proxy = pd.getProxy(),
        writefunction = function(buffer)
            data = data .. buffer
            return #buffer
        end,
    }
    local _, e = c:perform()
    c:close()
    if e then
        return false
    end
    local j = json.decode(data)
    if j == nil then
        return false
    end
    local message = {}
    local downloadURL = ""
    for i, w in ipairs(j.urls) do
        downloadURL = w.url
        local d_start = string.find(downloadURL, "//") + 2
        local d_end = string.find(downloadURL, "%.") - 1
        downloadURL = string.sub(downloadURL, d_start, d_end)
        local length = string.len(downloadURL)
        if length <= 3
        then
            table.insert(message, downloadURL .. "(超推荐)")
        elseif a == 7
        then
            table.insert(message, downloadURL .. "(一般推荐)")
        elseif string.find(downloadURL, "cache") ~= nil
        then
            table.insert(message, downloadURL .. "(超推荐)")
        else
            table.insert(message, downloadURL .. "(普通)")
        end
    end
    local num = pd.choice(message, 1, "选择下载接口")
    downloadURL = j.urls[num].url
    task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk;6.9.5.1;PC;PC-Windows;6.3.9600;WindowsBaiduYunGuanJia")
    if string.find(message[num], "推荐") == nil then
        task:setOptions("header", string.upper("r") .. "ange:bytes=4096-8191")
        task:setOptions("piece-length", "4M")
        task:setOptions("allow-piece-length-change", "true")
        task:setOptions("enable-http-pipelining", "true")
    end
    return true
end