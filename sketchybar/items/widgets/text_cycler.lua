local colors = require("colors")
local settings = require("settings")

-- Array di testi che vuoi ciclare
local texts = {
  "",
  "",
  "Ent. Link: paris dallas or france",
  "Pos Tag: label to token prounm verb..", 
  "Ner: identifying entities that are mentioned in a text",
  "word normalization: consistent spelling formatting",
  "Posting list: term - doc",
  "word2vec: cbow predict word, skipgram predict surrounding",
  "bm25 bound asympt",
  "byte pair: o = the",
  "lda: topic modelling wt td",
  "sentence segmentation: ! ? problem context",
  "pp(s): p(s) -1/n",
  "text normalization: 224 two two, bass fish or instrument",
  "co reference: pronoumn identification",
  "homograph: different pronunciation and meaning",
  "prosody: stress pattern",
  "log P : info learnt",  
  "layer llm 30-50",
  "clip model: language image pretrain",
  "bleu: n-gram precision",
  "rouge: model produce similarity",
  "bert: language model",
  "groupselfatt: memory efficient",
  "cls sep : bert classification",
  "Mlp perf imp for compl. ffn",
  "positional embedding rotation break simmetry"
}

-- Indice corrente (inizia da 1)
local current_index = 1

local text_cycler = sbar.add("item", "widgets.text_cycler", {
  position = "left",
  icon = { drawing = false },
  label = {
    string = texts[current_index],
    color = colors.white,
    font = { family = settings.font.text, style = settings.font.style_map["Semibold"] },
    padding_left = 8,
    padding_right = 8,
  },
  background = {
    color = colors.bg1,
    corner_radius = 6,
    height = 24,
  },
  padding_left = 5,
  padding_right = 5,
})

-- Funzione per aggiornare il testo
local function update_text()
  text_cycler:set({
    label = { string = texts[current_index] }
  })
end

-- Funzione per andare al testo successivo
local function next_text()
  current_index = current_index + 1
  if current_index > #texts then
    current_index = 1
  end
  update_text()
end

-- Funzione per andare al testo precedente
local function prev_text()
  current_index = current_index - 1
  if current_index < 1 then
    current_index = #texts
  end
  update_text()
end

-- Registra gli eventi per i comandi esterni
text_cycler:subscribe("text_cycler_next", next_text)
text_cycler:subscribe("text_cycler_prev", prev_text) 