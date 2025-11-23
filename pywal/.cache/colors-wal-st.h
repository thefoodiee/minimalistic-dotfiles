const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#080b14", /* black   */
  [1] = "#1A4C5E", /* red     */
  [2] = "#124676", /* green   */
  [3] = "#083B86", /* yellow  */
  [4] = "#15518B", /* blue    */
  [5] = "#276CA2", /* magenta */
  [6] = "#3585B8", /* cyan    */
  [7] = "#c1c2c4", /* white   */

  /* 8 bright colors */
  [8]  = "#585d6b",  /* black   */
  [9]  = "#1A4C5E",  /* red     */
  [10] = "#124676", /* green   */
  [11] = "#083B86", /* yellow  */
  [12] = "#15518B", /* blue    */
  [13] = "#276CA2", /* magenta */
  [14] = "#3585B8", /* cyan    */
  [15] = "#c1c2c4", /* white   */

  /* special colors */
  [256] = "#080b14", /* background */
  [257] = "#c1c2c4", /* foreground */
  [258] = "#c1c2c4",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
