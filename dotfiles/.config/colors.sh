export GUI_RED=#E86671 CTERM_RED=204 CTERM16_RED=1
export GUI_DARK_RED=#BE5046 CTERM_DARK_RED=196 CTERM16_DARK_RED=9
export GUI_GREEN=#98C379 CTERM_GREEN=114 CTERM16_GREEN=2
export GUI_GOLD=#FFD700 CTERM_GOLD=220 CTERM16_GOLD=3
export GUI_YELLOW=#E0AF68 CTERM_YELLOW=180 CTERM16_YELLOW=3
export GUI_DARK_YELLOW=#D19A66 CTERM_DARK_YELLOW=173 CTERM16_DARK_YELLOW=11
export GUI_BLUE=#61AFEF CTERM_BLUE=039 CTERM16_BLUE=2
export GUI_PURPLE=#C678DD CTERM_PURPLE=170 CTERM16_PURPLE=5
export GUI_CYAN=#56B6C2 CTERM_CYAN=038 CTERM16_CYAN=6
export GUI_MAGENTA=#C678DD CTERM_PURPLE=170 CTERM16_PURPLE=5
export GUI_WHITE=#798294 CTERM_WHITE=145 CTERM16_WHITE=7
export GUI_BLACK=#282C34 CTERM_BLACK=235 CTERM16_BLACK=0
export GUI_BG_BLACK=#282c34 CTERM_BG_BLACK=237 CTERM16_BG_BLACK=0
export GUI_COMMENT_GREY=#5C6370 CTERM_COMMENT_GREY=059 CTERM16_COMMENT_GREY=15
export GUI_GUTTER_FG_GREY=#abb2bf CTERM_GUTTER_FG_GREY=238 CTERM16_GUTTER_FG_GREY=15
export GUI_CURSOR_GREY=#2C323C CTERM_CURSOR_GREY=236 CTERM16_CURSOR_GREY=8
export GUI_VISUAL_GREY=#3E4452 CTERM_VISUAL_GREY=237 CTERM16_VISUAL_GREY=15
export GUI_MENU_GREY=#3E4452 CTERM_MENU_GREY=237 CTERM16_MENU_GREY=8
export GUI_SPECIAL_GREY=#3B4048 CTERM_SPECIAL_GREY=238 CTERM16_SPECIAL_GREY=15
export GUI_VERTSPLIT=#181A1F CTERM_VERTSPLIT=059 CTERM16_VERTSPLIT=15
export GUI_VISUAL_BLACK=NONE CTERM_VISUAL_BLACK=NONE CTERM16_VISUAL_BLACK=0


print_c() {
    print -cP $1 "%F{$2}$2%f %K{$2}($2)%k" "%F{$3}$3%f %K{$3}($3)%k" "%F{$4}$4%f %K{$4}($4)%k"
}

print_colors() {
    echo "Name                    GUI           CTERM          CTERM16"
    echo "============================================================"
    print_c RED $GUI_RED $CTERM_RED $CTERM16_RED
    print_c DARK_RED $GUI_DARK_RED $CTERM_DARK_RED $CTERM16_DARK_RED
    print_c GREEN $GUI_GREEN $CTERM_GREEN $CTERM16_GREEN
    print_c GOLD $GUI_GOLD $CTERM_GOLD $CTERM16_GOLD
    print_c YELLOW $GUI_YELLOW $CTERM_YELLOW $CTERM16_YELLOW
    print_c DARK_YELLOW $GUI_DARK_YELLOW $CTERM_DARK_YELLOW $CTERM16_DARK_YELLOW
    print_c BLUE $GUI_BLUE $CTERM_BLUE $CTERM16_BLUE
    print_c PURPLE $GUI_PURPLE $CTERM_PURPLE $CTERM16_PURPLE
    print_c CYAN $GUI_CYAN $CTERM_CYAN $CTERM16_CYAN
    print_c WHITE $GUI_WHITE $CTERM_WHITE $CTERM16_WHITE
    print_c BLACK $GUI_BLACK $CTERM_BLACK $CTERM16_BLACK
    print_c BG_BLACK $GUI_BG_BLACK $CTERM_BG_BLACK $CTERM16_BG_BLACK
    print_c COMMENT_GREY $GUI_COMMENT_GREY $CTERM_COMMENT_GREY $CTERM16_COMMENT_GREY
    print_c GUTTER_FG_GREY $GUI_GUTTER_FG_GREY $CTERM_GUTTER_FG_GREY $CTERM16_GUTTER_FG_GREY
    print_c CURSOR_GREY $GUI_CURSOR_GREY $CTERM_CURSOR_GREY $CTERM16_CURSOR_GREY
    print_c VISUAL_GREY $GUI_VISUAL_GREY $CTERM_VISUAL_GREY $CTERM16_VISUAL_GREY
    print_c MENU_GREY $GUI_MENU_GREY $CTERM_MENU_GREY $CTERM16_MENU_GREY
    print_c SPECIAL_GREY $GUI_SPECIAL_GREY $CTERM_SPECIAL_GREY $CTERM16_SPECIAL_GREY
    print_c VERTSPLIT $GUI_VERTSPLIT $CTERM_VERTSPLIT $CTERM16_VERTSPLIT
    print_c VISUAL_BLACK $GUI_VISUAL_BLACK $CTERM_VISUAL_BLACK $CTERM16_VISUAL_BLACK
}
