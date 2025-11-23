const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#090404", /* black   */
  [1] = "#575757", /* red     */
  [2] = "#686868", /* green   */
  [3] = "#787878", /* yellow  */
  [4] = "#888888", /* blue    */
  [5] = "#979797", /* magenta */
  [6] = "#A7A7A7", /* cyan    */
  [7] = "#c1c0c0", /* white   */

  /* 8 bright colors */
  [8]  = "#665353",  /* black   */
  [9]  = "#575757",  /* red     */
  [10] = "#686868", /* green   */
  [11] = "#787878", /* yellow  */
  [12] = "#888888", /* blue    */
  [13] = "#979797", /* magenta */
  [14] = "#A7A7A7", /* cyan    */
  [15] = "#c1c0c0", /* white   */

  /* special colors */
  [256] = "#090404", /* background */
  [257] = "#c1c0c0", /* foreground */
  [258] = "#c1c0c0",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
