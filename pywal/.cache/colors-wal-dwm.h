static const char norm_fg[] = "#c1c2c4";
static const char norm_bg[] = "#080b14";
static const char norm_border[] = "#585d6b";

static const char sel_fg[] = "#c1c2c4";
static const char sel_bg[] = "#1A4C5E";
static const char sel_border[] = "#c1c2c4";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};
