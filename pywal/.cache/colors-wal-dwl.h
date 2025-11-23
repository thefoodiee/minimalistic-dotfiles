/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x080b14ff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc1c2c4ff, 0x080b14ff, 0x585d6bff },
	[SchemeSel]  = { 0xc1c2c4ff, 0x124676ff, 0x1A4C5Eff },
	[SchemeUrg]  = { 0xc1c2c4ff, 0x1A4C5Eff, 0x124676ff },
};
