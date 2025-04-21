
#include <Rembedded.h>
#include <Rinternals.h>

void rwrap_init(int argc, char *argv[]) { Rf_initEmbeddedR(argc, argv); }

SEXP rwrap_eval(const char *code) {
    SEXP cmdSexp, cmdexpr;
    ParseStatus status;
    PROTECT(cmdSexp = Rf_allocVector(STRSXP, 1));
    SET_STRING_ELT(cmdSexp, 0, Rf_mkChar(code));
    PROTECT(cmdexpr = R_ParseVector(cmdSexp, -1, &status, R_NilValue));
    SEXP ans = Rf_eval(VECTOR_ELT(cmdexpr, 0), R_GlobalEnv);
    UNPROTECT(2);
    return ans;
}
