// [[Rcpp::depends(BH)]]
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/seq/for_each_i.hpp>
#include <boost/preprocessor/seq/enum.hpp>

#define CRYPT_MACRO(r, d, i, elem) ( elem ^ ( d - i ) )

#define DEFINE_HIDDEN_STRING(NAME, SEED, SEQ)\
static const char* BOOST_PP_CAT(Get, NAME)()\
{\
    static char data[] = {\
        BOOST_PP_SEQ_ENUM(BOOST_PP_SEQ_FOR_EACH_I(CRYPT_MACRO, SEED, SEQ)),\
        '\0'\
    };\
\
    static bool isEncrypted = true;\
    if ( isEncrypted )\
    {\
        for (unsigned i = 0; i < ( sizeof(data) / sizeof(data[0]) ) - 1; ++i)\
        {\
            data[i] = CRYPT_MACRO(_, SEED, i, data[i]);\
        }\
\
        isEncrypted = false;\
    }\
\
    return data;\
}

