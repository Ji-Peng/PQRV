#include "ntt.h"

#include <stdint.h>

#include "params.h"
#include "reduce.h"

#if defined(VECTOR128)

void ntt(int32_t a[N])
{
    ntt_8l_rvv(a, qdata);
}

void intt(int32_t a[N])
{
    intt_8l_rvv(a, qdata);
}

#elif defined(RV64)

// RV64IM assembly optimized implementation with Plantard arithmetic
const int64_t zetas_ntt_8l_rv64im[N] = {
    -7863079302046539641, 8288750859434465317,  8279739258909364132,
    -7047040794213066873, -6347578587163640001, -6924180145725268195,
    -7046899919168219175, -1324408118892148702, 7797620831989026436,
    5904178785850661821,  4688259859699270849,  8287121991728413809,
    -2212704518869611853, 1227061261729813591,  -2688021322530896626,
    -7418719789490536519, 7929103473456019385,  7006063765542992697,
    6764223135818434274,  2812273112086566323,  -5801130891717146429,
    8478949779359463672,  3858655525281480,     -4260193426548934306,
    -5854073494508971959, -3204665141301799075, 5856017129893355044,
    -3918586851001296707, -130194955510181959,  6102971083511369758,
    -8943480837399596562, 6032408094250703242,  -7894386579591364792,
    9208323720540693185,  -7093954385319926075, -6870828124834354042,
    -603253356108752072,  2602320869466829805,  191959857985594580,
    1401986245151715432,  -8728322821638222451, -8709478583217267089,
    -5054766099423739082, -7230664811654314069, -8181639600726124135,
    5862554612443318532,  -6847447269734787653, 4625566062396893718,
    5522697969093398433,  4464237721975370486,  4264925947586786663,
    -8399069226585667377, -61219011676627792,   1810554691626100264,
    2221786556917136888,  -5401996670902405877, -4357214510170059115,
    3514880794746733203,  -8709916616559840400, -8275231257474237793,
    -3686116612931685951, 8154954785590364077,  2553085041292559330,
    6188136651639530476,  -6567816909229834223, -2442236191550602657,
    9152669273135549467,  -3709312569534889736, -7507248749314436028,
    5895352083821923239,  -8296104977010030306, -7816377023506951986,
    1399848906580666762,  -551274866905102976,  -5404708515515724065,
    -7757905075204854307, 867587768384851535,   2044336828550855208,
    3363536973128790572,  1062393742510884766,  2528834723025573554,
    -6520454278917522983, -9126642608599937249, -3901772093695178495,
    4827034985909707918,  -3801618741498768150, 5255328139835346225,
    -7950085050448023416, -590917984994275510,  -7000732525564537623,
    -955584044445420687,  2411314119206532931,  -7718147496141743018,
    -1244989812359258915, 373512572033065466,   5420264202108515975,
    -7339552416631281695, 8248343934461509170,  5054110149996166987,
    2729258089564908745,  -8449154707374175531, 7034234372167380820,
    5817655094243266263,  2760688632773975632,  -27331959873029171,
    1489291353023500564,  4560453176433772522,  -8846488369021956442,
    -9171020448899537886, -7678532993296055172, 4375521662482532628,
    -7037694615456452404, 6599597438878444609,  312203312280832118,
    -196566912186629456,  5531586303954257883,  -2982351113496677052,
    1349842668004885439,  -2884110580268589357, -4883228720595909230,
    -2940625686150849480, 7136139857734084410,  4745838131935615944,
    3821924558510018379,  518171432538469675,   -7154149851748832310,
    7172426187645245389,  -1009765907397390811, -4230640483546978145,
    8893168635835786644,  -7642623063895346636, 4488507850795537969,
    -4137935899346889835, -1802234259289783097, -4796278001508819088,
    -7105112129106378911, 7517156227077865544,  3872626367619735212,
    -5677380969508746657, 3935571098595747305,  -5263199532966211355,
    -4963043238192433167, -3573282305526407034, 4634097807300482432,
    -5226468566194749829, -4476760192758785397, 1290417611977490052,
    -2596531785592619712, 1162177297714569904,  -6038721057197940712,
    3773459140737258753,  -1799537822884495126, -7868016532133936310,
    7664936350295676563,  -9207317784673577591, -2861559567230078939,
    -5199308297782628790, -3251098876787145806, 4389239369974577227,
    5483836267268615473,  -3066583384452721770, 1118034982880574012,
    -2614739885139184688, -1595418687590483606, -4038108320691689792,
    5401640080945135141,  8269343120834119163,  -4261027670955141768,
    -2900436677262892116, 5417937562695953211,  6682715916511162215,
    1367289161840242546,  -6677789692286644273, -744920823083718442,
    5828691773538053109,  6624974757504211969,  -5751340368053788143,
    9131496194129455597,  1649948335809421485,  -8854766979079334449,
    3215292402497497298,  -3779386898483740798, -8694748336340379660,
    8587813171438098100,  -2700092552936283755, 6440225940876758933,
    7427306563708518865,  8761985353839095054,  5654836559987963476,
    -3556060331293775945, 3793124416528967105,  3665652311494982061,
    4464061628169310864,  2561280006792059016,  -7416351327799034595,
    -1414535130006039286, -6377488120122866897, 7026922076870754992,
    2985776138024536711,  -6109915782987846123, 5906340337320043688,
    -6116591939410081565, 8792960254324982667,  -26147729027278209,
    -3016744434992697088, 6648406239573020499,  7403736407767438382,
    472987963076146265,   1200466694669659090,  -1695873600429771055,
    -7891419398959260151, 1225736155839214931,  8519235639840753829,
    -7632929099871764413, 5090955577741567268,  -1437971014419999307,
    -1010697003396931065, 6835869101986367468,  -2428650554413102775,
    1118514838502086484,  -1218828876296526235, 1893325383991850115,
    7550981646049343297,  308701246712821374,   -3332909857909870714,
    6197707349998870963,  6421564399779590430,  4080546927952058835,
    767795408490863416,   -721650026612939318,  2225876335562871622,
    -5182033495408179815, -4809746976499804471, 6875939247555234587,
    5191185970978128699,  -4827362960623493965, -6635258635778093928,
    -3779003894455561119, 6440749819949786311,  -864415878703202584,
    5026890449924500826,  7365041995058412064,  4090694333526244586,
    -8405457029400480186, -4231210587244096174, -4923419930656442340,
    3839960966595675222,  -666966296313699269,  7772844433476437538,
    -8748527384710988398, -8306633185439819991, 4182342354889975161,
    -1721041807660842613, 2321088055326733809,  -1610012461767674828,
};

const int64_t zetas_intt_8l_rv64im[N] = {
    1610012461767674828,  -2321088055326733809, 1721041807660842613,
    -4182342354889975161, 8306633185439819991,  8748527384710988398,
    -7772844433476437538, 666966296313699269,   -3839960966595675222,
    4923419930656442340,  4231210587244096174,  8405457029400480186,
    -4090694333526244586, -7365041995058412064, -5026890449924500826,
    864415878703202584,   -6440749819949786311, 3779003894455561119,
    6635258635778093928,  4827362960623493965,  -5191185970978128699,
    -6875939247555234587, 4809746976499804471,  5182033495408179815,
    -2225876335562871622, 721650026612939318,   -767795408490863416,
    -4080546927952058835, -6421564399779590430, -6197707349998870963,
    3332909857909870714,  -308701246712821374,  -7550981646049343297,
    -1893325383991850115, 1218828876296526235,  -1118514838502086484,
    2428650554413102775,  -6835869101986367468, 1010697003396931065,
    1437971014419999307,  -5090955577741567268, 7632929099871764413,
    -8519235639840753829, -1225736155839214931, 7891419398959260151,
    1695873600429771055,  -1200466694669659090, -472987963076146265,
    -7403736407767438382, -6648406239573020499, 3016744434992697088,
    26147729027278209,    -8792960254324982667, 6116591939410081565,
    -5906340337320043688, 6109915782987846123,  -2985776138024536711,
    -7026922076870754992, 6377488120122866897,  1414535130006039286,
    7416351327799034595,  -2561280006792059016, -4464061628169310864,
    -3665652311494982061, -3793124416528967105, 3556060331293775945,
    -5654836559987963476, -8761985353839095054, -7427306563708518865,
    -6440225940876758933, 2700092552936283755,  -8587813171438098100,
    8694748336340379660,  3779386898483740798,  -3215292402497497298,
    8854766979079334449,  -1649948335809421485, -9131496194129455597,
    5751340368053788143,  -6624974757504211969, -5828691773538053109,
    744920823083718442,   6677789692286644273,  -1367289161840242546,
    -6682715916511162215, -5417937562695953211, 2900436677262892116,
    4261027670955141768,  -8269343120834119163, -5401640080945135141,
    4038108320691689792,  1595418687590483606,  2614739885139184688,
    -1118034982880574012, 3066583384452721770,  -5483836267268615473,
    -4389239369974577227, 3251098876787145806,  5199308297782628790,
    2861559567230078939,  9207317784673577591,  -7664936350295676563,
    7868016532133936310,  1799537822884495126,  -3773459140737258753,
    6038721057197940712,  -1162177297714569904, 2596531785592619712,
    -1290417611977490052, 4476760192758785397,  5226468566194749829,
    -4634097807300482432, 3573282305526407034,  4963043238192433167,
    5263199532966211355,  -3935571098595747305, 5677380969508746657,
    -3872626367619735212, -7517156227077865544, 7105112129106378911,
    4796278001508819088,  1802234259289783097,  4137935899346889835,
    -4488507850795537969, 7642623063895346636,  -8893168635835786644,
    4230640483546978145,  1009765907397390811,  -7172426187645245389,
    7154149851748832310,  -518171432538469675,  -3821924558510018379,
    -4745838131935615944, -7136139857734084410, 2940625686150849480,
    4883228720595909230,  2884110580268589357,  -1349842668004885439,
    2982351113496677052,  -5531586303954257883, 196566912186629456,
    -312203312280832118,  -6599597438878444609, 7037694615456452404,
    -4375521662482532628, 7678532993296055172,  9171020448899537886,
    8846488369021956442,  -4560453176433772522, -1489291353023500564,
    27331959873029171,    -2760688632773975632, -5817655094243266263,
    -7034234372167380820, 8449154707374175531,  -2729258089564908745,
    -5054110149996166987, -8248343934461509170, 7339552416631281695,
    -5420264202108515975, -373512572033065466,  1244989812359258915,
    7718147496141743018,  -2411314119206532931, 955584044445420687,
    7000732525564537623,  590917984994275510,   7950085050448023416,
    -5255328139835346225, 3801618741498768150,  -4827034985909707918,
    3901772093695178495,  9126642608599937249,  6520454278917522983,
    -2528834723025573554, -1062393742510884766, -3363536973128790572,
    -2044336828550855208, -867587768384851535,  7757905075204854307,
    5404708515515724065,  551274866905102976,   -1399848906580666762,
    7816377023506951986,  8296104977010030306,  -5895352083821923239,
    7507248749314436028,  3709312569534889736,  -9152669273135549467,
    2442236191550602657,  6567816909229834223,  -6188136651639530476,
    -2553085041292559330, -8154954785590364077, 3686116612931685951,
    8275231257474237793,  8709916616559840400,  -3514880794746733203,
    4357214510170059115,  5401996670902405877,  -2221786556917136888,
    -1810554691626100264, 61219011676627792,    8399069226585667377,
    -4264925947586786663, -4464237721975370486, -5522697969093398433,
    -4625566062396893718, 6847447269734787653,  -5862554612443318532,
    8181639600726124135,  7230664811654314069,  5054766099423739082,
    8709478583217267089,  8728322821638222451,  -1401986245151715432,
    -191959857985594580,  -2602320869466829805, 603253356108752072,
    6870828124834354042,  7093954385319926075,  -9208323720540693185,
    7894386579591364792,  -6032408094250703242, 8943480837399596562,
    -6102971083511369758, 130194955510181959,   3918586851001296707,
    -5856017129893355044, 3204665141301799075,  5854073494508971959,
    4260193426548934306,  -3858655525281480,    -8478949779359463672,
    5801130891717146429,  -2812273112086566323, -6764223135818434274,
    -7006063765542992697, -7929103473456019385, 7418719789490536519,
    2688021322530896626,  -1227061261729813591, 2212704518869611853,
    -8287121991728413809, -4688259859699270849, -5904178785850661821,
    -7797620831989026436, 1324408118892148702,  7046899919168219175,
    6924180145725268195,  6347578587163640001,  7047040794213066873,
    -8279739258909364132, -8288750859434465317, -8751230424634003604,
    -92400822384635461,
};

void ntt(int32_t a[N])
{
    ntt_8l_rv64im(a, zetas_ntt_8l_rv64im);
}

void intt(int32_t a[N])
{
    intt_8l_rv64im(a, zetas_intt_8l_rv64im);
}

#else

static const int32_t zetas[N] = {
    0,        25847,    -2608894, -518909,  237124,   -777960,  -876248,
    466468,   1826347,  2353451,  -359251,  -2091905, 3119733,  -2884855,
    3111497,  2680103,  2725464,  1024112,  -1079900, 3585928,  -549488,
    -1119584, 2619752,  -2108549, -2118186, -3859737, -1399561, -3277672,
    1757237,  -19422,   4010497,  280005,   2706023,  95776,    3077325,
    3530437,  -1661693, -3592148, -2537516, 3915439,  -3861115, -3043716,
    3574422,  -2867647, 3539968,  -300467,  2348700,  -539299,  -1699267,
    -1643818, 3505694,  -3821735, 3507263,  -2140649, -1600420, 3699596,
    811944,   531354,   954230,   3881043,  3900724,  -2556880, 2071892,
    -2797779, -3930395, -1528703, -3677745, -3041255, -1452451, 3475950,
    2176455,  -1585221, -1257611, 1939314,  -4083598, -1000202, -3190144,
    -3157330, -3632928, 126922,   3412210,  -983419,  2147896,  2715295,
    -2967645, -3693493, -411027,  -2477047, -671102,  -1228525, -22981,
    -1308169, -381987,  1349076,  1852771,  -1430430, -3343383, 264944,
    508951,   3097992,  44288,    -1100098, 904516,   3958618,  -3724342,
    -8578,    1653064,  -3249728, 2389356,  -210977,  759969,   -1316856,
    189548,   -3553272, 3159746,  -1851402, -2409325, -177440,  1315589,
    1341330,  1285669,  -1584928, -812732,  -1439742, -3019102, -3881060,
    -3628969, 3839961,  2091667,  3407706,  2316500,  3817976,  -3342478,
    2244091,  -2446433, -3562462, 266997,   2434439,  -1235728, 3513181,
    -3520352, -3759364, -1197226, -3193378, 900702,   1859098,  909542,
    819034,   495491,   -1613174, -43260,   -522500,  -655327,  -3122442,
    2031748,  3207046,  -3556995, -525098,  -768622,  -3595838, 342297,
    286988,   -2437823, 4108315,  3437287,  -3342277, 1735879,  203044,
    2842341,  2691481,  -2590150, 1265009,  4055324,  1247620,  2486353,
    1595974,  -3767016, 1250494,  2635921,  -3548272, -2994039, 1869119,
    1903435,  -1050970, -1333058, 1237275,  -3318210, -1430225, -451100,
    1312455,  3306115,  -1962642, -1279661, 1917081,  -2546312, -1374803,
    1500165,  777191,   2235880,  3406031,  -542412,  -2831860, -1671176,
    -1846953, -2584293, -3724270, 594136,   -3776993, -2013608, 2432395,
    2454455,  -164721,  1957272,  3369112,  185531,   -1207385, -3183426,
    162844,   1616392,  3014001,  810149,   1652634,  -3694233, -1799107,
    -3038916, 3523897,  3866901,  269760,   2213111,  -975884,  1717735,
    472078,   -426683,  1723600,  -1803090, 1910376,  -1667432, -1104333,
    -260646,  -3833893, -2939036, -2235985, -420899,  -2286327, 183443,
    -976891,  1612842,  -3545687, -554416,  3919660,  -48306,   -1362209,
    3937738,  1400424,  -846154,  1976782};

/*************************************************
 * Name:        ntt
 *
 * Description: Forward NTT, in-place. No modular reduction is performed
 *after additions or subtractions. Output vector is in bitreversed order.
 *
 * Arguments:   - uint32_t p[N]: input/output coefficient array
 **************************************************/
void ntt(int32_t a[N])
{
    unsigned int len, start, j, k;
    int32_t zeta, t;

    k = 0;
    for (len = 128; len > 0; len >>= 1) {
        for (start = 0; start < N; start = j + len) {
            zeta = zetas[++k];
            for (j = start; j < start + len; ++j) {
                t = montgomery_reduce((int64_t)zeta * a[j + len]);
                a[j + len] = a[j] - t;
                a[j] = a[j] + t;
            }
        }
    }
}

/*************************************************
 * Name:        intt
 *
 * Description: Inverse NTT and multiplication by Montgomery factor 2^32.
 *              In-place. No modular reductions after additions or
 *              subtractions; input coefficients need to be smaller than
 *              Q in absolute value. Output coefficient are smaller than Q
 *in absolute value.
 *
 * Arguments:   - uint32_t p[N]: input/output coefficient array
 **************************************************/
void intt(int32_t a[N])
{
    unsigned int start, len, j, k;
    int32_t t, zeta;
    const int32_t f = 41978;  // mont^2/256

    k = 256;
    for (len = 1; len < N; len <<= 1) {
        for (start = 0; start < N; start = j + len) {
            zeta = -zetas[--k];
            for (j = start; j < start + len; ++j) {
                t = a[j];
                a[j] = t + a[j + len];
                a[j + len] = t - a[j + len];
                a[j + len] = montgomery_reduce((int64_t)zeta * a[j + len]);
            }
        }
    }

    for (j = 0; j < N; ++j) {
        a[j] = montgomery_reduce((int64_t)f * a[j]);
    }
}

#endif