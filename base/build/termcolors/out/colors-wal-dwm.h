static const char norm_fg[] = "#eceff4";
static const char norm_bg[] = "#3b4252";
static const char norm_border[] = "#5c667a";

static const char sel_fg[] = "#eceff4";
static const char sel_bg[] = "#93ae7c";
static const char sel_border[] = "#eceff4";

static const char urg_fg[] = "#eceff4";
static const char urg_bg[] = "#bf616a";
static const char urg_border[] = "#bf616a";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
