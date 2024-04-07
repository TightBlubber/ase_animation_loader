local dlg = Dialog("Load PNGs into Frames")

dlg:entry{
    id = "folderPath",
    label = "Folder path:",
    title = "Enter the path to the folder containing your PNG images",
    focus = true
}

dlg:entry{
    id = "fileName",
    label = "File name:",
    title = "Enter the desired file name for the new sprite"
}

dlg:button{ id = "ok", text = "OK" }
dlg:button{ id = "cancel", text = "Cancel" }

dlg:show()

local data = dlg.data
if not data.ok then return end

local folderPath = data.folderPath
local fileName = data.fileName

if folderPath == "" then
    app.alert("You must enter a folder path.")
    return
end

if fileName == "" then
    app.alert("You must enter a file name.")
    return
end

local files = app.fs.listFiles(folderPath)

if #files == 0 then
    app.alert("No files found in the specified folder.")
    return
end

local firstImage = Image{ fromFile=folderPath .. "/" .. files[1] }
local spr = Sprite(firstImage.width, firstImage.height)
spr.filename = fileName
app.activeSprite = spr

for i, filename in ipairs(files) do
    if filename:match("%.png$") then
        local imagePath = folderPath .. "/" .. filename
        local img = Image{ fromFile=imagePath }

        local newFrame = spr:newEmptyFrame()
        local cel = spr:newCel(spr.layers[1], newFrame, img, Point(0, 0))
    end
end

app.alert("Finished importing PNG images into frames.")