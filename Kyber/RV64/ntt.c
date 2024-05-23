#include "ntt.h"

#include <stdint.h>

#include "ntt_rvv.h"
#include "params.h"
#include "reduce.h"

#if defined(VECTOR128)
void ntt(int16_t r[KYBER_N])
{
    ntt_rvv(r, qdata);
}

void invntt(int16_t r[KYBER_N])
{
    intt_rvv(r, qdata);
}
#elif defined(RV64)
// RV64IM assembly optimized implementation with Plantard multiplication
uint64_t zetas_basemul_rv64im[64] = {
    94200855888573859,    -3147416832041761886, 3230535234296385879,
    -3768034235542954370, 9070988299387965153,  4006306988672876485,
    -5768417116470905146, 6095349498672426187,  7807588585117680453,
    -3695998286922280243, -265978887214796779,  1291105848355159365,
    4189167473633049271,  -6499859056311596289, -1739945220530128930,
    -1546002281936006278, -9010034804401240891, 9148565474825614214,
    -2992262481166463765, -8533489298141396662, -8212098142756850554,
    5275247929760136118,  8095732379600376963,  -3557467616497906920,
    5203211981139461991,  -5657592580131406488, -4942774320741640145,
    -5214294434773411857, 4061719256842625814,  -5496897002439133434,
    1485048786949282017,  3551926389680931987,  8777303278088293710,
    -5713004848301155817, -7159265047531613304, -603993723050267686,
    2077960056365599837,  -4322156917240447660, -6865580026231941860,
    9115318113923764616,  5890324106444353670,  1767651354615003594,
    -3080922110238062691, 4194708700450024203,  -6815708984879167464,
    3108628244322937356,  -4782078743049367091, -4072801710476575680,
    -2909144078911839771, 6051019684136626724,  2233114407240897958,
    5685298714216281153,  6333622251802348302,  -6533106417213445886,
    -3069839656604112825, 4909526959839790547,  -8904751494878717166,
    6715966902173618672,  -8062485018698527366, 5701922394667205952,
    -6754755489892443202, -2183243365888123562, 4903985733022815614,
    -6510941509945546155};

// 4+3 layer merging strategy with CT butterfly
uint64_t zetas_ntt_rv64im[128] = {
    -8865962907159892636, -4150378885914224740,
    -221649072678997316,  -3806822823261778901,
    3490972894694207725,  -7935036801908103909,
    4698960340794743097,  5884782879627378737,
    -7813129811934655386, 1069456775676162049,
    4416357773129021519,  -3008886161617388563,
    -382344650371270370,  3152958058858736819,
    -8771762051271318777, 1640203137824580138,
    1601414550105755607,  1834146076418702789,
    94200855888573859,    -3147416832041761886,
    3230535234296385879,  -3768034235542954370,
    -4887362052571890816, -421133238090094900,
    -8716349783101569448, 9070988299387965153,
    4006306988672876485,  -5768417116470905146,
    6095349498672426187,  7419702707929435150,
    6632848499918994678,  -5679757487399306220,
    7807588585117680453,  -3695998286922280243,
    -265978887214796779,  1291105848355159365,
    8178850781855000957,  -5829370611457629408,
    -7059522964826064512, 4189167473633049271,
    -6499859056311596289, -1739945220530128930,
    -1546002281936006278, -1568167189203906010,
    3601797431033706383,  -7491738656550109278,
    -9010034804401240891, 9148565474825614214,
    -2992262481166463765, -8533489298141396662,
    310308701750596242,   -4521641082651545244,
    3502055348328157591,  -8212098142756850554,
    5275247929760136118,  8095732379600376963,
    -3557467616497906920, -6034396003685701925,
    -2571129243076368864, 182860484960172786,
    5203211981139461991,  -5657592580131406488,
    -4942774320741640145, -5214294434773411857,
    7386455347027585552,  7314419398406911425,
    -7835294719202555117, 4061719256842625814,
    -5496897002439133434, 1485048786949282017,
    3551926389680931987,  7901789441006254312,
    -5596639085144682227, 7951660482359028708,
    8777303278088293710,  -5713004848301155817,
    -7159265047531613304, -603993723050267686,
    -6843415118964042128, 4471770041298770848,
    2504634521272669670,  2077960056365599837,
    -4322156917240447660, -6865580026231941860,
    9115318113923764616,  2964556347081589100,
    7968284162809953507,  -2554505562625444066,
    5890324106444353670,  1767651354615003594,
    -3080922110238062691, 4194708700450024203,
    -2476928387187795005, 8500241937239547065,
    -5136717259335762796, -6815708984879167464,
    3108628244322937356,  -4782078743049367091,
    -4072801710476575680, -5186588300688537192,
    -3779116689176904236, -3945353493686152223,
    -2909144078911839771, 6051019684136626724,
    2233114407240897958,  5685298714216281153,
    -2493552067638719804, 8206556915939875621,
    3590714977399756518,  6333622251802348302,
    -6533106417213445886, -3069839656604112825,
    4909526959839790547,  -7508362337001034076,
    -4737748928513567627, -1213528672917510305,
    -8904751494878717166, 6715966902173618672,
    -8062485018698527366, 5701922394667205952,
    4549347216736419909,  6799085304428242665,
    5042516403447188937,  -6754755489892443202,
    -2183243365888123562, 4903985733022815614,
    -6510941509945546155, 0};

// 3+4 layer merging strategy with GS butterfly.
uint64_t zetas_intt_rv64im[128] = {
    6510941509945546155,  -4903985733022815614, 2183243365888123562,
    6754755489892443202,  -5042516403447188937, -6799085304428242665,
    -4549347216736419909, -5701922394667205952, 8062485018698527366,
    -6715966902173618672, 8904751494878717166,  1213528672917510305,
    4737748928513567627,  7508362337001034076,  -4909526959839790547,
    3069839656604112825,  6533106417213445886,  -6333622251802348302,
    -3590714977399756518, -8206556915939875621, 2493552067638719804,
    -5685298714216281153, -2233114407240897958, -6051019684136626724,
    2909144078911839771,  3945353493686152223,  3779116689176904236,
    5186588300688537192,  4072801710476575680,  4782078743049367091,
    -3108628244322937356, 6815708984879167464,  5136717259335762796,
    -8500241937239547065, 2476928387187795005,  -4194708700450024203,
    3080922110238062691,  -1767651354615003594, -5890324106444353670,
    2554505562625444066,  -7968284162809953507, -2964556347081589100,
    -9115318113923764616, 6865580026231941860,  4322156917240447660,
    -2077960056365599837, -2504634521272669670, -4471770041298770848,
    6843415118964042128,  603993723050267686,   7159265047531613304,
    5713004848301155817,  -8777303278088293710, -7951660482359028708,
    5596639085144682227,  -7901789441006254312, -3551926389680931987,
    -1485048786949282017, 5496897002439133434,  -4061719256842625814,
    7835294719202555117,  -7314419398406911425, -7386455347027585552,
    5214294434773411857,  4942774320741640145,  5657592580131406488,
    -5203211981139461991, -182860484960172786,  2571129243076368864,
    6034396003685701925,  3557467616497906920,  -8095732379600376963,
    -5275247929760136118, 8212098142756850554,  -3502055348328157591,
    4521641082651545244,  -310308701750596242,  8533489298141396662,
    2992262481166463765,  -9148565474825614214, 9010034804401240891,
    7491738656550109278,  -3601797431033706383, 1568167189203906010,
    1546002281936006278,  1739945220530128930,  6499859056311596289,
    -4189167473633049271, 7059522964826064512,  5829370611457629408,
    -8178850781855000957, -1291105848355159365, 265978887214796779,
    3695998286922280243,  -7807588585117680453, 5679757487399306220,
    -6632848499918994678, -7419702707929435150, -6095349498672426187,
    5768417116470905146,  -4006306988672876485, -9070988299387965153,
    8716349783101569448,  421133238090094900,   4887362052571890816,
    3768034235542954370,  -3230535234296385879, 3147416832041761886,
    -94200855888573859,   -1834146076418702789, -1601414550105755607,
    -1640203137824580138, 8771762051271318777,  -3152958058858736819,
    382344650371270370,   3008886161617388563,  -4416357773129021519,
    -1069456775676162049, 7813129811934655386,  -5884782879627378737,
    -4698960340794743097, 7935036801908103909,  -3490972894694207725,
    3806822823261778901,  221649072678997316,   4150378885914224740,
    -4050636803208675948, 6211715261828899778};

void ntt(int16_t *poly)
{
    ntt_rv64im(poly, zetas_ntt_rv64im);
}

void invntt(int16_t *poly)
{
    invntt_rv64im(poly, zetas_intt_rv64im);
}
#else
const int16_t zetas[128] = {
    -1044, -758,  -359,  -1517, 1493,  1422,  287,   202,   -171,  622,
    1577,  182,   962,   -1202, -1474, 1468,  573,   -1325, 264,   383,
    -829,  1458,  -1602, -130,  -681,  1017,  732,   608,   -1542, 411,
    -205,  -1571, 1223,  652,   -552,  1015,  -1293, 1491,  -282,  -1544,
    516,   -8,    -320,  -666,  -1618, -1162, 126,   1469,  -853,  -90,
    -271,  830,   107,   -1421, -247,  -951,  -398,  961,   -1508, -725,
    448,   -1065, 677,   -1275, -1103, 430,   555,   843,   -1251, 871,
    1550,  105,   422,   587,   177,   -235,  -291,  -460,  1574,  1653,
    -246,  778,   1159,  -147,  -777,  1483,  -602,  1119,  -1590, 644,
    -872,  349,   418,   329,   -156,  -75,   817,   1097,  603,   610,
    1322,  -1285, -1465, 384,   -1215, -136,  1218,  -1335, -874,  220,
    -1187, -1659, -1185, -1530, -1278, 794,   -1510, -854,  -870,  478,
    -108,  -308,  996,   991,   958,   -1460, 1522,  1628};

static int16_t fqmul(int16_t a, int16_t b)
{
    return montgomery_reduce((int32_t)a * b);
}

void ntt(int16_t r[256])
{
    unsigned int len, start, j, k;
    int16_t t, zeta;

    k = 1;
    for (len = 128; len >= 2; len >>= 1) {
        for (start = 0; start < 256; start = j + len) {
            zeta = zetas[k++];
            for (j = start; j < start + len; j++) {
                t = fqmul(zeta, r[j + len]);
                r[j + len] = r[j] - t;
                r[j] = r[j] + t;
            }
        }
    }
}

void invntt(int16_t r[256])
{
    unsigned int start, len, j, k;
    int16_t t, zeta;
    const int16_t f = 1441;  // mont^2/128

    k = 127;
    for (len = 2; len <= 128; len <<= 1) {
        for (start = 0; start < 256; start = j + len) {
            zeta = zetas[k--];
            for (j = start; j < start + len; j++) {
                t = r[j];
                r[j] = barrett_reduce(t + r[j + len]);
                r[j + len] = r[j + len] - t;
                r[j + len] = fqmul(zeta, r[j + len]);
            }
        }
    }

    for (j = 0; j < 256; j++)
        r[j] = fqmul(r[j], f);
}

void basemul(int16_t r[2], const int16_t a[2], const int16_t b[2],
             int16_t zeta)
{
    r[0] = fqmul(a[1], b[1]);
    r[0] = fqmul(r[0], zeta);
    r[0] += fqmul(a[0], b[0]);
    r[1] = fqmul(a[0], b[1]);
    r[1] += fqmul(a[1], b[0]);
}

#endif
