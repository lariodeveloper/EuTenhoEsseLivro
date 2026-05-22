---------------------------------------------------
-- Ícone customizado inventário
---------------------------------------------------

local ETEL_Icon =
    getTexture("media/textures/ETEL_HaveBook.png")

---------------------------------------------------
-- Guarda original
---------------------------------------------------

local oldRenderDetails =
    ISInventoryPane.renderdetails

---------------------------------------------------
-- Hook
---------------------------------------------------

function ISInventoryPane:renderdetails(doDragged)

    ------------------------------------------------
    -- render vanilla primeiro
    ------------------------------------------------
    oldRenderDetails(self, doDragged)

    ------------------------------------------------
    -- não renderiza durante drag
    ------------------------------------------------
    if doDragged then
        return
    end

    ------------------------------------------------
    -- segurança
    ------------------------------------------------
    local ETEL_Data = ModData.get("ETEL")

    if not ETEL_Data then
        return
    end

    if not ETEL_Data.KnownBooks then
        return
    end

    ------------------------------------------------
    -- player
    ------------------------------------------------
    local player =
        getSpecificPlayer(self.player)

    ------------------------------------------------
    -- desenha overlays
    ------------------------------------------------
    local y = 0

    for _, v in ipairs(self.itemslist) do

        local item = v.items[1]

        if item then

            local key = item:getFullType()

            if ETEL_Data.KnownBooks[key] then

                ------------------------------------------------
                -- evita sobrepor vanilla
                ------------------------------------------------
                local alreadyKnown =
                    self:isLiteratureRead(player, item)
                    or item:hasBeenSeen(player)
                    or item:hasBeenHeard(player)
                    or player:hasReadMap(item)

                if not alreadyKnown then

                    ------------------------------------------------
                    -- mesmas contas do vanilla
                    ------------------------------------------------
                    local texWH =
                        math.min(self.itemHgt - 2, 32)

                    local auxDXY =
                        self.itemHgt -
                        (self.itemHgt - texWH) / 2 -
                        13

                    local texOffsetY =
                        (y * self.itemHgt) +
                        (self.itemHgt - texWH) / 2 +
                        self.headerHgt

                    local texOffsetX =
                        self.column2 -
                        texWH -
                        (self.itemHgt - texWH) / 2

                    ------------------------------------------------
                    -- desenha overlay
                    ------------------------------------------------
                    self:drawTexture(
                        ETEL_Icon,
                        texOffsetX + auxDXY,
                        texOffsetY + auxDXY - 1,
                        1,
                        1,
                        1,
                        1
                    )
                end
            end
        end

        y = y + 1
    end
end

print("[ETEL] Inventory icon carregado")