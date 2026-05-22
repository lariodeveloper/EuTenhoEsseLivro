local ETEL = {}

---------------------------------------------------
-- Dados globais
---------------------------------------------------
ETEL.Data = nil

---------------------------------------------------
-- Inicializa ModData
---------------------------------------------------
function ETEL.initGlobalData()

    ETEL.Data = ModData.getOrCreate("ETEL")

    ETEL.Data.KnownBooks =
        ETEL.Data.KnownBooks or {}

    print("[ETEL] GlobalData inicializado")
end

Events.OnInitGlobalModData.Add(
    ETEL.initGlobalData
)

---------------------------------------------------
-- Verifica literatura
---------------------------------------------------
function ETEL.isLiterature(item)

    if not item then
        return false
    end

    return item:getCategory() == "Literature"
end

---------------------------------------------------
-- Chave única
---------------------------------------------------
function ETEL.getItemKey(item)

    return item:getFullType()
end

---------------------------------------------------
-- Verifica se conhecido
---------------------------------------------------
function ETEL.isKnownBook(item)

    local key = ETEL.getItemKey(item)

    return ETEL.Data.KnownBooks[key] == true
end

---------------------------------------------------
-- Alterna marca
---------------------------------------------------
function ETEL.toggleBookMark(item)

    local key = ETEL.getItemKey(item)

    local current =
        ETEL.Data.KnownBooks[key]

    ETEL.Data.KnownBooks[key] =
        not current

    ------------------------------------------------
    -- IMPORTANTE
    ------------------------------------------------
    ModData.add("ETEL", ETEL.Data)

    ModData.transmit("ETEL")
end

---------------------------------------------------
-- Context menu
---------------------------------------------------
function ETEL.onFillInventoryContextMenu(
    player,
    context,
    items
)

    local item = nil

    if instanceof(items[1], "InventoryItem") then
        item = items[1]
    else
        item = items[1].items[1]
    end

    if not item then
        return
    end

    if not ETEL.isLiterature(item) then
        return
    end

    if ETEL.isKnownBook(item) then

        context:addOption(
            getText("IGUI_ETEL.ContextRemove"),
            item,
            ETEL.toggleBookMark
        )

    else

        context:addOption(
            getText("IGUI_ETEL.ContextToggle"),
            item,
            ETEL.toggleBookMark
        )

    end
end

---------------------------------------------------
-- Evento
---------------------------------------------------
Events.OnFillInventoryObjectContextMenu.Add(
    ETEL.onFillInventoryContextMenu
)

print("[ETEL] Mod carregado")