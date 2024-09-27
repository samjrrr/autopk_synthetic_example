$PROBLEM PK MODEL ORAL ADMINISTRATION

  ; NUMBER OF COMPARTMENTS        : 1 OR 2 OR 3
  ;
  ; ABSORPTION                    : FIRST-ORDER (option of LAG TIME), ZERO-ORDER OR ZERO-ORDER FOLLOWED BY FIRST-ORDER
  ;
  ; ELIMINATION                   : FIRST-ORDER
  ;
  ; INTERINDIVIDUAL VARIABILITY   : ESTIMATE in all parameters or fixed in some of them to 15% CV.
  ;
  ; RESIDUAL ERROR FOR PLASMA OBS : PROPORTIONAL, ADDITIVE OR COMBINED


$INPUT C ID TIME TAD AMT EVID DV II ADDL DOSE DOSEREF DAY RATE

$DATA /projects/qcp/QCP_MODELING/OTHER/autoPK/automatization_popPK/DerivedData/toymodel_data_rate_dose.csv
  IGNORE=@

$SUBROUTINE ADVAN5

$MODEL
  NCOMP= 3 
  COMP = (DEPOT, INITIALOFF) 
  COMP = (CENTRAL , DEFDOSE) 
  COMP = (PERIPH) 




$PK
  ; Parameter definition

  TVCL=EXP(THETA(1))    ; CL
  TVV2= EXP(THETA(2))   ; V2
  TVKA=EXP(THETA(4))    ; KA
  TVV3=EXP(THETA(7)) ; V3 
  TVQ=EXP(THETA(8)) ; Q 




  ; MU Referencing
  MU_1  = LOG(TVCL) + LOG(DOSE/DOSEREF)*THETA(3)    ; CL
  MU_2  = LOG(TVV2) + 0    ; V2
  MU_3  = LOG(TVKA) + 0    ; KA
  MU_4  = LOG(TVV3) + LOG(DOSE/DOSEREF)*THETA(9)  ; V3 
  MU_5  = LOG(TVQ) + LOG(DOSE/DOSEREF)*THETA(10) ; Q 



  ; Parameter transformations
  CL   = EXP(MU_1 + ETA(1))  ; CL
  V2    = EXP(MU_2 + ETA(2)) ; V2
  KA   = EXP(MU_3 + ETA(3))  ; KA
  V3   = EXP(MU_4 + ETA(4)) ; V3  
  Q   = EXP(MU_5 + ETA(5)) ; Q

  TVALAG2=EXP(THETA(11)) 
  MU_6  = LOG(TVALAG2) ; ALAG2 
  ALAG2 = EXP(MU_6 + ETA(6))  ; ALAG2
  TVD2=EXP(THETA(12)) 
  MU_7  = LOG(TVD2) ; D2 
  D2 = EXP(MU_7 + ETA(7))  ; D2


  ; Assigning expressions to match ADVAN5 parameterization
  k20 = CL/V2
  k20 = CL/V2
  k23 = Q/V2 ; k23  
  k32 = Q/V3 ; k32 


  F1 = 1   ; INPUT1
  S2 = V2 ; CP   

$ERROR
  CP = A(2)/S2
  IPRED = CP
  IRES = DV - IPRED
  W = SQRT(THETA(5)**2 + (THETA(6)*IPRED)**2)
  IWRES = IRES/W
  Y = IPRED + W*ERR(1)

$THETA
  ; Model parameters
  (2.5)       ; CL ; L/h ; LOG
  7         ; V2 ; L ; LOG
  0.1 	; cov_CL  ; 



  0 FIX 	; KA  ; 1/h ; LOG 

  ; Error model parameters
  1.5 	 ; add_error 
  (0, 0.2) 	 ; prop_error 

  ; Additional model parameters
  5 	 ; V3 ; LOG 
  2 	 ; Q ; LOG 
  0.1 	; cov_V3  ; 
  0.1 	; cov_Q  ; 

  -1.2 	; ALAG2  ; h ; LOG 

  -1.2 	; D2  ; h ; LOG 




$OMEGA ;; search band
  0.1  ;  CL ; LOG
  0.1  ;  V2 ; LOG
  0 FIX ;  KA ; LOG  

  0.1 	 ; V3 ; LOG 
  0.1 	 ; Q ; LOG
  0.01 FIX 	 ; ALAG2 ; LOG 

  0.01 FIX 	 ; D2 ; LOG 



$SIGMA
  1 FIX


$ESTIMATION method = SAEM ISAMPLE = 2 NBURN = 1000 NITER = 500 RANMETHOD = 3S2P CTYPE = 3 CITER = 10 CALPHA = 0.05 CINTERVAL = 10 SEED = 234567 PRINT = 5 NOABORT INTERACTION
$ESTIMATION method = IMP ISAMPLE = 3000 EONLY = 1 NITER = 10 RANMETHOD = 3S2P NOABORT INTERACTION PRINT = 1 MAPITER = 0 SIGDIGITS = 3 NSIG = 3 SIGL = 9

$COVARIANCE UNCONDITIONAL MATRIX=R PRINT = E


;; Phenotype: ([('ODE', 1), ('OMEGAS_V3', 0), ('OMEGAS_Q', 0), ('OMEGAS_V4', 1), ('OMEGAS_Q2', 0), ('OMEGAS_D1', 1), ('OMEGAS_D2', 1), ('TLAG', 0), ('TLAG2', 1), ('ZERO_ORDER_ABS', 2), ('TRANSIT_COMP', 0), ('DOSE_COV_CL', 1), ('DOSE_COV_V2', 0), ('DOSE_COV_KA', 0), ('DOSE_COV_V3', 1), ('DOSE_COV_Q', 1), ('ERRORFIX', 0)])
;; Genotype: [1, 0, 0, 1, 0, 1, 1, 0, 1, 2, 0, 1, 0, 0, 1, 1, 0]
;; Num non-influential tokens: 0
