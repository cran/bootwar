## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
# Load bootwar
library(bootwar)

# Set up vectors for computer and player's cards and values
comp_cv <- vector(mode = "character")
comp_vv <- vector(mode = "numeric")
plyr_cv <- vector(mode = "character")
plyr_vv <- vector(mode = "numeric")

## -----------------------------------------------------------------------------
seed <- 123
set.seed(seed)

# Shuffle the deck
ideck <- mmcards::shuffle_deck(
  deck_of_cards = function(x) {list(as.integer(stats::runif(26, 25, 50)),
                                    as.integer(stats::runif(26, 35, 55)))},
  seed = seed
  )

head(ideck)

## -----------------------------------------------------------------------------
rres <- play_round(cdeck = ideck,
                   plyr_cv = plyr_cv, plyr_vv = plyr_vv,
                   comp_cv = comp_cv, comp_vv = comp_vv)

## -----------------------------------------------------------------------------
for (i in 1:4) {
  rres <- play_round(cdeck = rres$updated_deck,
                     plyr_cv = rres$plyr_cv, plyr_vv = rres$plyr_vv,
                     comp_cv = rres$comp_cv, comp_vv = rres$comp_vv)
}

# Ensure 10 cards have been dealt
nrow(rres$updated_deck)

## -----------------------------------------------------------------------------
gres <- analyze_game(plyr_vv = rres$plyr_vv, comp_vv = rres$comp_vv,
                     mode = "pt", nboot = 1000, seed = 150, conf.level = 0.05)

# Display game results
gres$winner
gres$bootstrap_results$effect.size
gres$bootstrap_results$ci.effect.size
gres$bootstrap_results$p.value

