const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#3b4252", /* black   */
  [1] = "#bf616a", /* red     */
  [2] = "#93ae7c", /* green   */
  [3] = "#dbbb7b", /* yellow  */
  [4] = "#81a1c1", /* blue    */
  [5] = "#b48ead", /* magenta */
  [6] = "#6ec7b5", /* cyan    */
  [7] = "#a8aeb9", /* white   */

  /* 8 bright colors */
  [8]  = "#5c667a",  /* black   */
  [9]  = "#cf717a",  /* red     */
  [10] = "#b3ce9c", /* green   */
  [11] = "#fbdb9b", /* yellow  */
  [12] = "#88c0d0", /* blue    */
  [13] = "#c49ebd", /* magenta */
  [14] = "#96efd5", /* cyan    */
  [15] = "#eceff4", /* white   */

  /* special colors */
  [256] = "#2e3440", /* background */
  [257] = "#eceff4", /* foreground */
  [258] = "#FFFFFF",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
