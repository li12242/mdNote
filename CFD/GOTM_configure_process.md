# GOTM

General Ocean Turbulence Model <http://www.gotm.net/>

## 1.set environment

1. GOTM main path, GOTM test cases: for example

```
setenv GOTMDIR /GOTM/gotm-3.2.4
setenv GOTM_CASES "$GOTMDIR"/gotm-cases/v3.2
```

2. netCDF path: for example 

```
setenv NETCDFHOME /Users/mac/Documents/Model/FVCOM/libs/install
setenv NETCDFINC /Users/mac/Documents/Model/FVCOM/libs/install/include
setenv NETCDFLIBNAME /Users/mac/Documents/Model/FVCOM/libs/install/lib/libnetcdf.a
```

3. Choose compiler to compile Make sure that "/compiler/compiler.XLF" uses the same compiler you used when you installed netCDF. Here we changed "FC=xlf90_r" to "FC=f90" and we also commented out the option "-q32" in "EXTRAS" flag.

```
setenv FORTRAN_COMPILER XLF

```

## 2.make

Go to directory "src" and run "make". This will compile "F90" file within the dependent directories. This will create executable file "gotm_prod_XLF".
