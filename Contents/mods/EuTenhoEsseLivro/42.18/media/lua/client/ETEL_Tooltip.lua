---------------------------------------------------
-- Tooltip Customizado - ETEL_Tooltip.lua
---------------------------------------------------

local oldSetItem = ISToolTipInv.setItem
local oldRender = ISToolTipInv.render

---------------------------------------------------
-- Hook setItem
---------------------------------------------------

function ISToolTipInv:setItem(item)
    ------------------------------------------------
    -- Reinicialização sistemática da flag de estado
    ------------------------------------------------
    self.ETELMarkedBook = false

    ------------------------------------------------
    -- Execução do comportamento vanilla
    ------------------------------------------------
    oldSetItem(self, item)

    ------------------------------------------------
    -- Cláusula de segurança primária
    ------------------------------------------------
    if not item then
        return
    end

    ------------------------------------------------
    -- Recuperação segura de ModData do Cliente/Servidor
    -- Em servidores multiplayer, recomenda-se armazenar dados específicos 
    -- do jogador no ModData do próprio personagem para evitar dessincronização.
    ------------------------------------------------
    local ETEL_Data = ModData.get("ETEL")
    
    -- Mecanismo de fallback robusto para multiplayer:
    -- Se o ModData global não estiver sincronizado, tenta ler os dados locais do jogador.
    if not ETEL_Data then
        local playerObj = getPlayer()
        if playerObj then
            local pModData = playerObj:getModData()
            ETEL_Data = pModData.ETEL
        end
    end

    if not ETEL_Data or not ETEL_Data.KnownBooks then
        return
    end

    ------------------------------------------------
    -- Verificação de correspondência do item de inventário
    ------------------------------------------------
    local key = item:getFullType()

    if not ETEL_Data.KnownBooks[key] then
        return
    end

    ------------------------------------------------
    -- Ativação da flag persistente para o ciclo do render
    ------------------------------------------------
    self.ETELMarkedBook = true
end

---------------------------------------------------
-- Hook render
---------------------------------------------------

function ISToolTipInv:render()
    ------------------------------------------------
    -- Sem texto extra: renderização vanilla padrão
    ------------------------------------------------
    if not self.ETELMarkedBook then
        oldRender(self)
        return
    end

    ------------------------------------------------
    -- Interceptação dinâmica do redimensionamento vanilla
    ------------------------------------------------
    local originalSetHeight = self.setHeight
    self.setHeight = function(subSelf, h)
        -- Adiciona 20 pixels adicionais à janela gerada pelo comportamento padrão
        originalSetHeight(subSelf, h + 20)
    end

    -- Renderiza o layout nativo estendendo a moldura com segurança
    oldRender(self)

    -- Restauração imediata do método nativo para evitar vazamento de memória
    self.setHeight = originalSetHeight

    ------------------------------------------------
    -- Desenho contínuo do texto customizado
    ------------------------------------------------
    -- O texto é posicionado na margem inferior criada dinamicamente
    self:drawText(
        getText("IGUI_ETEL.HaveBook"),
        10,
        self:getHeight() - 18,
        0.0, -- Vermelho (R)
        1.0, -- Verde (G)
        0.0, -- Azul (B)
        1.0, -- Opacidade (Alpha)
        UIFont.Small
    )
end

print(" Tooltip carregado com correções arquiteturais")