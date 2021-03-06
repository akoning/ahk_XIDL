 ;+
; NAME:
;   ahk_objstr
;
; PURPOSE:
;   Add tag in objstr which points to yfit found from ahk_profile. To be integrated with long_objfind.
;
; CALLING SEQUENCE:
;   objstruct = ahk_objstr( slitim )
;
; INPUTS:
;    slitim  -- 1-d array of flux across slit in spatial direction.
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;   objstruct  - Structure with object parameters
;
; OPTIONAL OUTPUTS:
;   skymask    - Image of the cleanest sky pixels, =1 for good sky pixels
;
; COMMENTS:
;
; EXAMPLES:
;
; BUGS:
;
; PROCEDURES CALLED:
;
; INTERNAL SUPPORT ROUTINES:
;
; REVISION HISTORY:
;   27-Jun-2014  Written by Alice Koning
;-
;------------------------------------------------------------------------------
; Create the return structure for NOBJ objects
function long_obj_create, nobj, slitid=slitid, ny=ny

   objstr = create_struct( $
    'OBJID' , 0L, $
    'SLITID', 0L, $
    'XFRACPOS', 0.0, $
    'PEAKFLUX', 0.0, $
    'MASKWIDTH', 0.0, $
    'FWHM', 0.0, $
    'FLX_SHFT_WAV', 0.0, $
    'FLX_SHFT_SPA', 0.0, $                   
    'FWHMFIT'  , fltarr(ny), $
    'XPOS'  , fltarr(ny), $
    'YPOS', findgen(ny), $
    'HAND_AP', 0L, $
    'HAND_X', 0.0, $
    'HAND_Y', 0.0, $
    'HAND_MINX', 0.0, $
    'HAND_MAXX', 0.0, $
    'HAND_FWHM', 0.0, $
    'HAND_SUB', 0L, $
    'OBJ_MODEL', Ptr_New() )                        
;    'XPOSIVAR'  , fltarr(ny), $
     if (keyword_set(slitid)) then objstr.slitid = slitid
   if (keyword_set(nobj)) then objstr = replicate(objstr, nobj)

;; Initialize pointer field after replicating structure so each pointer points to a different variable and can be set independently.
;; If it turns out we do want all pointers pointing to same variable, use 'OBJ_MODEL', Ptr_New(/ALLOCATE_HEAP) in above definition of objstr.
    objstr.OBJ_MODEL = PtrArr(nobj, /ALLOCATE_HEAP)

   return, objstr
end
;------------------------------------------------------------------------------
function ahk_objstr, slitim

	;;Params to use for testing:
	npeak = 5
	slitid=1
	ny=10

	;;Initialize objstruct and yfit variable
	objstruct = long_obj_create(npeak, slitid = slitid, ny = ny)
	yfit = []

	;;Run ahk_profile. Note return is boolean skymask, but function will also change value of yfit to be the best Gaussian+baseline fit y values.
	skymask = ahk_profile(slitim,yfit)


	;;Populate OBJ_MODEL with yfit from ahk_profile
	*objstruct[1].OBJ_MODEL = yfit
	print, 'objstruct 1 model: ', *objstruct[1].OBJ_MODEL

	
end
