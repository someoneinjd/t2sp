#include "gbmv-interface.h"


int MAX_DEVICES = 4;
int NUM_QUEUES_TO_CREATE = 11;
int NUM_KERNELS_TO_CREATE = 11;
cl_int status;
cl_context context = NULL;
cl_command_queue cmdQueue[12]; // extra queue for reading buffer D
cl_device_id devices[4];
int current_kernel = 0;
cl_kernel kernel[11];

const char *kernel_name[] = {
    "kernel_aLoader",
    "kernel_aFeeder",
    "kernel_xLoader",
    "kernel_xFeeder",
    "kernel_V",
    "kernel_yLoader",
    "kernel_yFeeder",
    "kernel_Out",
    "kernel_drainer",
    "kernel_collector",
    "kernel_unloader",
};

#ifdef __cplusplus
extern "C" {
#endif

HALIDE_FUNCTION_ATTRS
int gbmv(float _Alpha, float _Beta, struct halide_buffer_t *_A_buffer, struct halide_buffer_t *_X_buffer, struct halide_buffer_t *_Y_buffer, struct halide_buffer_t *_deserializer_buffer) {
 void * const _ucon = nullptr;
 uint64_t _217 = (uint64_t)(_deserializer_buffer);
 uint64_t _218 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
 bool _219 = _217 != _218;
 if (!_219)  {
  int32_t _220 = halide_error_buffer_argument_is_null(_ucon, "deserializer");
  return _220;
 }
 uint64_t _221 = (uint64_t)(_Y_buffer);
 uint64_t _222 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
 bool _223 = _221 != _222;
 if (!_223)  {
  int32_t _224 = halide_error_buffer_argument_is_null(_ucon, "Y");
  return _224;
 }
 uint64_t _225 = (uint64_t)(_X_buffer);
 uint64_t _226 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
 bool _227 = _225 != _226;
 if (!_227)  {
  int32_t _228 = halide_error_buffer_argument_is_null(_ucon, "X");
  return _228;
 }
 uint64_t _229 = (uint64_t)(_A_buffer);
 uint64_t _230 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
 bool _231 = _229 != _230;
 if (!_231)  {
  int32_t _232 = halide_error_buffer_argument_is_null(_ucon, "A");
  return _232;
 }
 void *_233 = _halide_buffer_get_host(_A_buffer);
 void * _A = _233;
 uint32_t _234 = _halide_buffer_get_type(_A_buffer);
 int32_t _235 = _halide_buffer_get_dimensions(_A_buffer);
 int32_t _236 = _halide_buffer_get_min(_A_buffer, 0);
 int32_t _237 = _halide_buffer_get_extent(_A_buffer, 0);
 int32_t _238 = _halide_buffer_get_stride(_A_buffer, 0);
 int32_t _239 = _halide_buffer_get_min(_A_buffer, 1);
 int32_t _240 = _halide_buffer_get_extent(_A_buffer, 1);
 int32_t _241 = _halide_buffer_get_stride(_A_buffer, 1);
 void *_242 = _halide_buffer_get_host(_X_buffer);
 void * _X = _242;
 uint32_t _243 = _halide_buffer_get_type(_X_buffer);
 int32_t _244 = _halide_buffer_get_dimensions(_X_buffer);
 int32_t _245 = _halide_buffer_get_min(_X_buffer, 0);
 int32_t _246 = _halide_buffer_get_extent(_X_buffer, 0);
 int32_t _247 = _halide_buffer_get_stride(_X_buffer, 0);
 void *_248 = _halide_buffer_get_host(_Y_buffer);
 void * _Y = _248;
 uint32_t _249 = _halide_buffer_get_type(_Y_buffer);
 int32_t _250 = _halide_buffer_get_dimensions(_Y_buffer);
 int32_t _251 = _halide_buffer_get_min(_Y_buffer, 0);
 int32_t _252 = _halide_buffer_get_extent(_Y_buffer, 0);
 int32_t _253 = _halide_buffer_get_stride(_Y_buffer, 0);
 void *_254 = _halide_buffer_get_host(_deserializer_buffer);
 void * _deserializer = _254;
 uint32_t _255 = _halide_buffer_get_type(_deserializer_buffer);
 int32_t _256 = _halide_buffer_get_dimensions(_deserializer_buffer);
 int32_t _257 = _halide_buffer_get_min(_deserializer_buffer, 0);
 int32_t _258 = _halide_buffer_get_extent(_deserializer_buffer, 0);
 int32_t _259 = _halide_buffer_get_stride(_deserializer_buffer, 0);
 int32_t _260 = _halide_buffer_get_min(_deserializer_buffer, 1);
 int32_t _261 = _halide_buffer_get_extent(_deserializer_buffer, 1);
 int32_t _262 = _halide_buffer_get_stride(_deserializer_buffer, 1);
 int32_t _263 = _halide_buffer_get_min(_deserializer_buffer, 2);
 int32_t _264 = _halide_buffer_get_extent(_deserializer_buffer, 2);
 int32_t _265 = _halide_buffer_get_stride(_deserializer_buffer, 2);
 bool _266 = _halide_buffer_is_bounds_query(_A_buffer);
 if (_266)
 {
  struct halide_dimension_t *_267 = _halide_buffer_get_shape(_A_buffer);
  uint64_t _268 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_269 = (void *)(_268);
  struct halide_device_interface_t *_270 = (struct halide_device_interface_t *)(_268);
  struct halide_dimension_t s0[2] = {
   {_236, _237, 1, 0},
   {_239, _240, _237, 0},
  };
  struct halide_dimension_t *_271 = s0;
  struct halide_buffer_t *_272 = _halide_buffer_init(_A_buffer, _267, _269, _268, _270, 2, 32, 2, _271, _268);
  (void)_272;
 } // if _266
 bool _273 = _halide_buffer_is_bounds_query(_X_buffer);
 if (_273)
 {
  struct halide_dimension_t *_274 = _halide_buffer_get_shape(_X_buffer);
  uint64_t _275 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_276 = (void *)(_275);
  struct halide_device_interface_t *_277 = (struct halide_device_interface_t *)(_275);
  struct halide_dimension_t s1[1] = {
   {_245, _246, 1, 0},
  };
  struct halide_dimension_t *_278 = s1;
  struct halide_buffer_t *_279 = _halide_buffer_init(_X_buffer, _274, _276, _275, _277, 2, 32, 1, _278, _275);
  (void)_279;
 } // if _273
 bool _280 = _halide_buffer_is_bounds_query(_Y_buffer);
 if (_280)
 {
  struct halide_dimension_t *_281 = _halide_buffer_get_shape(_Y_buffer);
  uint64_t _282 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_283 = (void *)(_282);
  struct halide_device_interface_t *_284 = (struct halide_device_interface_t *)(_282);
  struct halide_dimension_t s2[1] = {
   {_251, _252, 1, 0},
  };
  struct halide_dimension_t *_285 = s2;
  struct halide_buffer_t *_286 = _halide_buffer_init(_Y_buffer, _281, _283, _282, _284, 2, 32, 1, _285, _282);
  (void)_286;
 } // if _280
 bool _287 = _halide_buffer_is_bounds_query(_deserializer_buffer);
 if (_287)
 {
  struct halide_dimension_t *_288 = _halide_buffer_get_shape(_deserializer_buffer);
  uint64_t _289 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_290 = (void *)(_289);
  struct halide_device_interface_t *_291 = (struct halide_device_interface_t *)(_289);
  int32_t _292 = _237 + _240;
  int32_t _293 = _292 + 3;
  int32_t _294 = _293 >> 2;
  struct halide_dimension_t s3[3] = {
   {0, 2, 1, 0},
   {0, 2, 2, 0},
   {0, _294, 4, 0},
  };
  struct halide_dimension_t *_295 = s3;
  struct halide_buffer_t *_296 = _halide_buffer_init(_deserializer_buffer, _288, _290, _289, _291, 2, 32, 3, _295, _289);
  (void)_296;
 } // if _287
 bool _297 = _halide_buffer_is_bounds_query(_deserializer_buffer);
 bool _298 = _halide_buffer_is_bounds_query(_Y_buffer);
 bool _299 = _halide_buffer_is_bounds_query(_A_buffer);
 bool _300 = _halide_buffer_is_bounds_query(_X_buffer);
 bool _301 = _299 || _300;
 bool _302 = _298 || _301;
 bool _303 = _297 || _302;
 bool _304 = !(_303);
 if (_304)
 {
  uint32_t _305 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
  bool _306 = _234 == _305;
  if (!_306)   {
   uint32_t _307 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
   int32_t _308 = halide_error_bad_type(_ucon, "Input buffer A", _234, _307);
   return _308;
  }
  bool _309 = _235 == 2;
  if (!_309)   {
   int32_t _310 = halide_error_bad_dimensions(_ucon, "Input buffer A", _235, 2);
   return _310;
  }
  uint32_t _311 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
  bool _312 = _243 == _311;
  if (!_312)   {
   uint32_t _313 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
   int32_t _314 = halide_error_bad_type(_ucon, "Input buffer X", _243, _313);
   return _314;
  }
  bool _315 = _244 == 1;
  if (!_315)   {
   int32_t _316 = halide_error_bad_dimensions(_ucon, "Input buffer X", _244, 1);
   return _316;
  }
  uint32_t _317 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
  bool _318 = _249 == _317;
  if (!_318)   {
   uint32_t _319 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
   int32_t _320 = halide_error_bad_type(_ucon, "Input buffer Y", _249, _319);
   return _320;
  }
  bool _321 = _250 == 1;
  if (!_321)   {
   int32_t _322 = halide_error_bad_dimensions(_ucon, "Input buffer Y", _250, 1);
   return _322;
  }
  uint32_t _323 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
  bool _324 = _255 == _323;
  if (!_324)   {
   uint32_t _325 = (uint32_t)(ADD_UINT64_T_SUFFIX(73730));
   int32_t _326 = halide_error_bad_type(_ucon, "Output buffer deserializer", _255, _325);
   return _326;
  }
  bool _327 = _256 == 3;
  if (!_327)   {
   int32_t _328 = halide_error_bad_dimensions(_ucon, "Output buffer deserializer", _256, 3);
   return _328;
  }
  bool _329 = 0 <= _237;
  if (!_329)   {
   int32_t _330 = halide_error_buffer_extents_negative(_ucon, "Input buffer A", 0, _237);
   return _330;
  }
  bool _331 = 0 <= _240;
  if (!_331)   {
   int32_t _332 = halide_error_buffer_extents_negative(_ucon, "Input buffer A", 1, _240);
   return _332;
  }
  bool _333 = 0 <= _246;
  if (!_333)   {
   int32_t _334 = halide_error_buffer_extents_negative(_ucon, "Input buffer X", 0, _246);
   return _334;
  }
  bool _335 = 0 <= _252;
  if (!_335)   {
   int32_t _336 = halide_error_buffer_extents_negative(_ucon, "Input buffer Y", 0, _252);
   return _336;
  }
  bool _337 = _257 <= 0;
  int32_t _338 = _258 + _257;
  bool _339 = 2 <= _338;
  bool _340 = _337 && _339;
  if (!_340)   {
   int32_t _341 = _258 + _257;
   int32_t _342 = _341 + -1;
   int32_t _343 = halide_error_access_out_of_bounds(_ucon, "Output buffer deserializer", 0, 0, 1, _257, _342);
   return _343;
  }
  bool _344 = 0 <= _258;
  if (!_344)   {
   int32_t _345 = halide_error_buffer_extents_negative(_ucon, "Output buffer deserializer", 0, _258);
   return _345;
  }
  bool _346 = _260 <= 0;
  int32_t _347 = _261 + _260;
  bool _348 = 2 <= _347;
  bool _349 = _346 && _348;
  if (!_349)   {
   int32_t _350 = _261 + _260;
   int32_t _351 = _350 + -1;
   int32_t _352 = halide_error_access_out_of_bounds(_ucon, "Output buffer deserializer", 1, 0, 1, _260, _351);
   return _352;
  }
  bool _353 = 0 <= _261;
  if (!_353)   {
   int32_t _354 = halide_error_buffer_extents_negative(_ucon, "Output buffer deserializer", 1, _261);
   return _354;
  }
  bool _355 = _263 <= 0;
  int32_t _356 = _237 + _240;
  int32_t _357 = _356 + 3;
  int32_t _358 = _357 >> 2;
  int32_t _359 = _264 + _263;
  bool _360 = _358 <= _359;
  bool _361 = _355 && _360;
  if (!_361)   {
   int32_t _362 = _237 + _240;
   int32_t _363 = _362 + -1;
   int32_t _364 = _363 >> 2;
   int32_t _365 = _264 + _263;
   int32_t _366 = _365 + -1;
   int32_t _367 = halide_error_access_out_of_bounds(_ucon, "Output buffer deserializer", 2, 0, _364, _263, _366);
   return _367;
  }
  bool _368 = 0 <= _264;
  if (!_368)   {
   int32_t _369 = halide_error_buffer_extents_negative(_ucon, "Output buffer deserializer", 2, _264);
   return _369;
  }
  bool _370 = _238 == 1;
  if (!_370)   {
   int32_t _371 = halide_error_constraint_violated(_ucon, "A.stride.0", _238, "1", 1);
   return _371;
  }
  bool _372 = _247 == 1;
  if (!_372)   {
   int32_t _373 = halide_error_constraint_violated(_ucon, "X.stride.0", _247, "1", 1);
   return _373;
  }
  bool _374 = _253 == 1;
  if (!_374)   {
   int32_t _375 = halide_error_constraint_violated(_ucon, "Y.stride.0", _253, "1", 1);
   return _375;
  }
  bool _376 = _259 == 1;
  if (!_376)   {
   int32_t _377 = halide_error_constraint_violated(_ucon, "deserializer.stride.0", _259, "1", 1);
   return _377;
  }
  int64_t _378 = (int64_t)(_240);
  int64_t _379 = (int64_t)(_237);
  int64_t _380 = _378 * _379;
  int64_t _381 = (int64_t)(_261);
  int64_t _382 = (int64_t)(_258);
  int64_t _383 = _381 * _382;
  int64_t _384 = (int64_t)(_264);
  int64_t _385 = _383 * _384;
  int64_t _386;
  int64_t _387 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _388 = _379 > _387;
  if (_388)
  {
   int64_t _389 = (int64_t)(_237);
   _386 = _389;
  } // if _388
  else
  {
   int64_t _390 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _391 = (int64_t)(_237);
   int64_t _392 = _390 - _391;
   _386 = _392;
  } // if _388 else
  int64_t _393 = _386;
  uint64_t _394 = (uint64_t)(_393);
  uint64_t _395 = _394;
  uint64_t _396 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _397 = _395 <= _396;
  if (!_397)   {
   int64_t _398;
   int64_t _399 = (int64_t)(_237);
   int64_t _400 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _401 = _399 > _400;
   if (_401)
   {
    int64_t _402 = (int64_t)(_237);
    _398 = _402;
   } // if _401
   else
   {
    int64_t _403 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _404 = (int64_t)(_237);
    int64_t _405 = _403 - _404;
    _398 = _405;
   } // if _401 else
   int64_t _406 = _398;
   uint64_t _407 = (uint64_t)(_406);
   uint64_t _408 = _407;
   uint64_t _409 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _410 = halide_error_buffer_allocation_too_large(_ucon, "A", _408, _409);
   return _410;
  }
  int64_t _411;
  int64_t _412 = (int64_t)(_240);
  int64_t _413 = (int64_t)(_241);
  int64_t _414 = _412 * _413;
  int64_t _415 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _416 = _414 > _415;
  if (_416)
  {
   int64_t _417 = (int64_t)(_240);
   int64_t _418 = (int64_t)(_241);
   int64_t _419 = _417 * _418;
   _411 = _419;
  } // if _416
  else
  {
   int64_t _420 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _421 = (int64_t)(_240);
   int64_t _422 = (int64_t)(_241);
   int64_t _423 = _421 * _422;
   int64_t _424 = _420 - _423;
   _411 = _424;
  } // if _416 else
  int64_t _425 = _411;
  uint64_t _426 = (uint64_t)(_425);
  uint64_t _427 = _426;
  uint64_t _428 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _429 = _427 <= _428;
  if (!_429)   {
   int64_t _430;
   int64_t _431 = (int64_t)(_240);
   int64_t _432 = (int64_t)(_241);
   int64_t _433 = _431 * _432;
   int64_t _434 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _435 = _433 > _434;
   if (_435)
   {
    int64_t _436 = (int64_t)(_240);
    int64_t _437 = (int64_t)(_241);
    int64_t _438 = _436 * _437;
    _430 = _438;
   } // if _435
   else
   {
    int64_t _439 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _440 = (int64_t)(_240);
    int64_t _441 = (int64_t)(_241);
    int64_t _442 = _440 * _441;
    int64_t _443 = _439 - _442;
    _430 = _443;
   } // if _435 else
   int64_t _444 = _430;
   uint64_t _445 = (uint64_t)(_444);
   uint64_t _446 = _445;
   uint64_t _447 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _448 = halide_error_buffer_allocation_too_large(_ucon, "A", _446, _447);
   return _448;
  }
  int64_t _449 = (int64_t)(ADD_INT64_T_SUFFIX(2147483647));
  bool _450 = _380 <= _449;
  if (!_450)   {
   int64_t _451 = (int64_t)(ADD_INT64_T_SUFFIX(2147483647));
   int32_t _452 = halide_error_buffer_extents_too_large(_ucon, "A", _380, _451);
   return _452;
  }
  int64_t _453;
  int64_t _454 = (int64_t)(_246);
  int64_t _455 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _456 = _454 > _455;
  if (_456)
  {
   int64_t _457 = (int64_t)(_246);
   _453 = _457;
  } // if _456
  else
  {
   int64_t _458 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _459 = (int64_t)(_246);
   int64_t _460 = _458 - _459;
   _453 = _460;
  } // if _456 else
  int64_t _461 = _453;
  uint64_t _462 = (uint64_t)(_461);
  uint64_t _463 = _462;
  uint64_t _464 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _465 = _463 <= _464;
  if (!_465)   {
   int64_t _466;
   int64_t _467 = (int64_t)(_246);
   int64_t _468 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _469 = _467 > _468;
   if (_469)
   {
    int64_t _470 = (int64_t)(_246);
    _466 = _470;
   } // if _469
   else
   {
    int64_t _471 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _472 = (int64_t)(_246);
    int64_t _473 = _471 - _472;
    _466 = _473;
   } // if _469 else
   int64_t _474 = _466;
   uint64_t _475 = (uint64_t)(_474);
   uint64_t _476 = _475;
   uint64_t _477 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _478 = halide_error_buffer_allocation_too_large(_ucon, "X", _476, _477);
   return _478;
  }
  int64_t _479;
  int64_t _480 = (int64_t)(_252);
  int64_t _481 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _482 = _480 > _481;
  if (_482)
  {
   int64_t _483 = (int64_t)(_252);
   _479 = _483;
  } // if _482
  else
  {
   int64_t _484 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _485 = (int64_t)(_252);
   int64_t _486 = _484 - _485;
   _479 = _486;
  } // if _482 else
  int64_t _487 = _479;
  uint64_t _488 = (uint64_t)(_487);
  uint64_t _489 = _488;
  uint64_t _490 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _491 = _489 <= _490;
  if (!_491)   {
   int64_t _492;
   int64_t _493 = (int64_t)(_252);
   int64_t _494 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _495 = _493 > _494;
   if (_495)
   {
    int64_t _496 = (int64_t)(_252);
    _492 = _496;
   } // if _495
   else
   {
    int64_t _497 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _498 = (int64_t)(_252);
    int64_t _499 = _497 - _498;
    _492 = _499;
   } // if _495 else
   int64_t _500 = _492;
   uint64_t _501 = (uint64_t)(_500);
   uint64_t _502 = _501;
   uint64_t _503 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _504 = halide_error_buffer_allocation_too_large(_ucon, "Y", _502, _503);
   return _504;
  }
  int64_t _505;
  int64_t _506 = (int64_t)(_258);
  int64_t _507 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _508 = _506 > _507;
  if (_508)
  {
   int64_t _509 = (int64_t)(_258);
   _505 = _509;
  } // if _508
  else
  {
   int64_t _510 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _511 = (int64_t)(_258);
   int64_t _512 = _510 - _511;
   _505 = _512;
  } // if _508 else
  int64_t _513 = _505;
  uint64_t _514 = (uint64_t)(_513);
  uint64_t _515 = _514;
  uint64_t _516 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _517 = _515 <= _516;
  if (!_517)   {
   int64_t _518;
   int64_t _519 = (int64_t)(_258);
   int64_t _520 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _521 = _519 > _520;
   if (_521)
   {
    int64_t _522 = (int64_t)(_258);
    _518 = _522;
   } // if _521
   else
   {
    int64_t _523 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _524 = (int64_t)(_258);
    int64_t _525 = _523 - _524;
    _518 = _525;
   } // if _521 else
   int64_t _526 = _518;
   uint64_t _527 = (uint64_t)(_526);
   uint64_t _528 = _527;
   uint64_t _529 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _530 = halide_error_buffer_allocation_too_large(_ucon, "deserializer", _528, _529);
   return _530;
  }
  int64_t _531;
  int64_t _532 = (int64_t)(_261);
  int64_t _533 = (int64_t)(_262);
  int64_t _534 = _532 * _533;
  int64_t _535 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _536 = _534 > _535;
  if (_536)
  {
   int64_t _537 = (int64_t)(_261);
   int64_t _538 = (int64_t)(_262);
   int64_t _539 = _537 * _538;
   _531 = _539;
  } // if _536
  else
  {
   int64_t _540 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _541 = (int64_t)(_261);
   int64_t _542 = (int64_t)(_262);
   int64_t _543 = _541 * _542;
   int64_t _544 = _540 - _543;
   _531 = _544;
  } // if _536 else
  int64_t _545 = _531;
  uint64_t _546 = (uint64_t)(_545);
  uint64_t _547 = _546;
  uint64_t _548 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _549 = _547 <= _548;
  if (!_549)   {
   int64_t _550;
   int64_t _551 = (int64_t)(_261);
   int64_t _552 = (int64_t)(_262);
   int64_t _553 = _551 * _552;
   int64_t _554 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _555 = _553 > _554;
   if (_555)
   {
    int64_t _556 = (int64_t)(_261);
    int64_t _557 = (int64_t)(_262);
    int64_t _558 = _556 * _557;
    _550 = _558;
   } // if _555
   else
   {
    int64_t _559 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _560 = (int64_t)(_261);
    int64_t _561 = (int64_t)(_262);
    int64_t _562 = _560 * _561;
    int64_t _563 = _559 - _562;
    _550 = _563;
   } // if _555 else
   int64_t _564 = _550;
   uint64_t _565 = (uint64_t)(_564);
   uint64_t _566 = _565;
   uint64_t _567 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _568 = halide_error_buffer_allocation_too_large(_ucon, "deserializer", _566, _567);
   return _568;
  }
  int64_t _569 = (int64_t)(ADD_INT64_T_SUFFIX(2147483647));
  bool _570 = _383 <= _569;
  if (!_570)   {
   int64_t _571 = (int64_t)(ADD_INT64_T_SUFFIX(2147483647));
   int32_t _572 = halide_error_buffer_extents_too_large(_ucon, "deserializer", _383, _571);
   return _572;
  }
  int64_t _573;
  int64_t _574 = (int64_t)(_264);
  int64_t _575 = (int64_t)(_265);
  int64_t _576 = _574 * _575;
  int64_t _577 = (int64_t)(ADD_INT64_T_SUFFIX(0));
  bool _578 = _576 > _577;
  if (_578)
  {
   int64_t _579 = (int64_t)(_264);
   int64_t _580 = (int64_t)(_265);
   int64_t _581 = _579 * _580;
   _573 = _581;
  } // if _578
  else
  {
   int64_t _582 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   int64_t _583 = (int64_t)(_264);
   int64_t _584 = (int64_t)(_265);
   int64_t _585 = _583 * _584;
   int64_t _586 = _582 - _585;
   _573 = _586;
  } // if _578 else
  int64_t _587 = _573;
  uint64_t _588 = (uint64_t)(_587);
  uint64_t _589 = _588;
  uint64_t _590 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
  bool _591 = _589 <= _590;
  if (!_591)   {
   int64_t _592;
   int64_t _593 = (int64_t)(_264);
   int64_t _594 = (int64_t)(_265);
   int64_t _595 = _593 * _594;
   int64_t _596 = (int64_t)(ADD_INT64_T_SUFFIX(0));
   bool _597 = _595 > _596;
   if (_597)
   {
    int64_t _598 = (int64_t)(_264);
    int64_t _599 = (int64_t)(_265);
    int64_t _600 = _598 * _599;
    _592 = _600;
   } // if _597
   else
   {
    int64_t _601 = (int64_t)(ADD_INT64_T_SUFFIX(0));
    int64_t _602 = (int64_t)(_264);
    int64_t _603 = (int64_t)(_265);
    int64_t _604 = _602 * _603;
    int64_t _605 = _601 - _604;
    _592 = _605;
   } // if _597 else
   int64_t _606 = _592;
   uint64_t _607 = (uint64_t)(_606);
   uint64_t _608 = _607;
   uint64_t _609 = (uint64_t)(ADD_UINT64_T_SUFFIX(2147483647));
   int32_t _610 = halide_error_buffer_allocation_too_large(_ucon, "deserializer", _608, _609);
   return _610;
  }
  int64_t _611 = (int64_t)(ADD_INT64_T_SUFFIX(2147483647));
  bool _612 = _385 <= _611;
  if (!_612)   {
   int64_t _613 = (int64_t)(ADD_INT64_T_SUFFIX(2147483647));
   int32_t _614 = halide_error_buffer_extents_too_large(_ucon, "deserializer", _385, _613);
   return _614;
  }
  uint64_t _615 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_616 = (void *)(_615);
  bool _617 = _A != _616;
  if (!_617)   {
   int32_t _618 = halide_error_host_is_null(_ucon, "Input buffer A");
   return _618;
  }
  uint64_t _619 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_620 = (void *)(_619);
  bool _621 = _X != _620;
  if (!_621)   {
   int32_t _622 = halide_error_host_is_null(_ucon, "Input buffer X");
   return _622;
  }
  uint64_t _623 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_624 = (void *)(_623);
  bool _625 = _Y != _624;
  if (!_625)   {
   int32_t _626 = halide_error_host_is_null(_ucon, "Input buffer Y");
   return _626;
  }
  uint64_t _627 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_628 = (void *)(_627);
  bool _629 = _deserializer != _628;
  if (!_629)   {
   int32_t _630 = halide_error_host_is_null(_ucon, "Output buffer deserializer");
   return _630;
  }
  halide_buffer_t b36;
  struct halide_buffer_t *_631 = &b36;
  int32_t _632 = _240 >> 2;
  int32_t _633 = _237 + _240;
  int32_t _634 = _633 + 3;
  int32_t _635 = _634 >> 2;
  int32_t _636 = _632 * 16;
  struct halide_dimension_t s4[6] = {
   {0, 2, 1, 0},
   {0, 2, 2, 0},
   {0, 2, 4, 0},
   {0, 2, 8, 0},
   {0, _632, 16, 0},
   {0, _635, _636, 0},
  };
  struct halide_dimension_t *_637 = s4;
  uint64_t _638 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
  void *_639 = (void *)(_638);
  struct halide_device_interface_t *_640 = (struct halide_device_interface_t *)(_638);
  struct halide_dimension_t s5[6] = {
   {0, 2, 1, 0},
   {0, 2, 2, 0},
   {0, 2, 4, 0},
   {0, 2, 8, 0},
   {0, _632, 16, 0},
   {0, _635, _636, 0},
  };
  struct halide_dimension_t *_641 = s5;
  struct halide_buffer_t *_642 = _halide_buffer_init(_631, _637, _639, _638, _640, 2, 32, 6, _641, _638);
  struct halide_buffer_t * _aSerializer_buffer = _642;
  struct halide_device_interface_t const *_643 = halide_opencl_device_interface();
  int32_t _644 = halide_device_and_host_malloc(_ucon, _aSerializer_buffer, _643);
  bool _645 = _644 == 0;
  if (!_645)   {
   return _644;
  }
  struct s6 { void * const ucon; void * const arg; s6(void *ucon, void *a) : ucon(ucon), arg((void *)a) {} ~s6() { halide_device_and_host_free_as_destructor(ucon, arg); } } d0(_ucon, _aSerializer_buffer);
  void *_646 = 0;
  (void)_646;
  {
   void *_647 = _halide_buffer_get_host(_aSerializer_buffer);
   float *_aSerializer = (float *)(_647);
   if (!_aSerializer)
   {
    return halide_error_out_of_memory(_ucon);
   }
   HalideFreeHelper _aSerializer_free(_ucon, _aSerializer, halide_device_host_nop_free);
   // produce aSerializer
   int32_t _648 = halide_copy_to_host(_ucon, _A_buffer);
   bool _649 = _648 == 0;
   if (!_649)    {
    return _648;
   }
   int32_t _650 = _237 + _240;
   int32_t _651 = _650 + 3;
   int32_t _652 = _651 >> 2;
   for (int _aSerializer_s0_i = 0; _aSerializer_s0_i < 0 + _652; _aSerializer_s0_i++)
   {
    int32_t _653 = _240 >> 2;
    for (int _aSerializer_s0_k = 0; _aSerializer_s0_k < 0 + _653; _aSerializer_s0_k++)
    {
     int32_t _654 = _240 >> 1;
     int32_t _655 = _aSerializer_s0_k * 2;
     int32_t _656 = _654 - _655;
     int32_t _657 = ::halide_cpp_min(_656, 1);
     int32_t _658 = ::halide_cpp_max(_657, -1);
     int32_t _659 = _658 + 1;
     for (int _aSerializer_s0_kk = 0; _aSerializer_s0_kk < 0 + _659; _aSerializer_s0_kk++)
     {
      for (int _aSerializer_s0_ii_iii = 0; _aSerializer_s0_ii_iii < 0 + 4; _aSerializer_s0_ii_iii++)
      {
       int32_t _660 = _aSerializer_s0_k * 2;
       int32_t _661 = _660 + _aSerializer_s0_kk;
       int32_t _662 = _661 * 2;
       int32_t _663 = _240 - _662;
       int32_t _664 = ::halide_cpp_min(_663, 1);
       int32_t _665 = ::halide_cpp_max(_664, -1);
       int32_t _666 = _665 + 1;
       for (int _aSerializer_s0_kkk = 0; _aSerializer_s0_kkk < 0 + _666; _aSerializer_s0_kkk++)
       {
        int32_t _667 = _aSerializer_s0_k * 4;
        int32_t _668 = _aSerializer_s0_kk * 2;
        int32_t _669 = _668 + _aSerializer_s0_kkk;
        int32_t _670 = _667 + _669;
        bool _671 = _670 <= _240;
        if (_671)
        {
         int32_t _672 = _aSerializer_s0_k * 4;
         int32_t _673 = _aSerializer_s0_kk * 2;
         int32_t _674 = _673 + _aSerializer_s0_kkk;
         int32_t _675 = _672 + _674;
         int32_t _676 = _675 * _241;
         int32_t _677 = _aSerializer_s0_i * 4;
         int32_t _678 = _677 + _aSerializer_s0_ii_iii;
         int32_t _679 = _678 - _675;
         int32_t _680 = _676 + _679;
         int32_t _681 = _239 * _241;
         int32_t _682 = _681 + _236;
         int32_t _683 = _680 - _682;
         float _684 = ((const float *)_A)[_683];
         int32_t _685 = _240 >> 2;
         int32_t _686 = _685 * _aSerializer_s0_i;
         int32_t _687 = _686 * 16;
         int32_t _688 = _aSerializer_s0_k * 16;
         int32_t _689 = _aSerializer_s0_kk * 8;
         int32_t _690 = _aSerializer_s0_ii_iii >> 1;
         int32_t _691 = _690 * 4;
         int32_t _692 = _aSerializer_s0_ii_iii & 1;
         int32_t _693 = _692 * 2;
         int32_t _694 = _693 + _aSerializer_s0_kkk;
         int32_t _695 = _691 + _694;
         int32_t _696 = _689 + _695;
         int32_t _697 = _688 + _696;
         int32_t _698 = _687 + _697;
         _aSerializer[_698] = _684;
        } // if _671
       } // for _aSerializer_s0_kkk
      } // for _aSerializer_s0_ii_iii
     } // for _aSerializer_s0_kk
    } // for _aSerializer_s0_k
   } // for _aSerializer_s0_i
   bool _699 = (bool)(ADD_UINT64_T_SUFFIX(1));
   int32_t _700 = _halide_buffer_set_host_dirty(_aSerializer_buffer, _699);
   (void)_700;
   // consume aSerializer
   // produce aLoader
   struct halide_device_interface_t const *_701 = halide_opencl_device_interface();
   int32_t _702 = halide_copy_to_device(_ucon, _aSerializer_buffer, _701);
   bool _703 = _702 == 0;
   if (!_703)    {
    return _702;
   }
   status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
   CHECK(status);
   status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
   CHECK(status);
   status = clSetKernelArg(kernel[current_kernel], 2, sizeof(cl_mem), (void *)&((device_handle *)_halide_buffer_get_device(_aSerializer_buffer))->mem);
   CHECK(status);
   current_kernel++;

   // consume aLoader
   // produce aFeeder
   status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
   CHECK(status);
   status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
   CHECK(status);
   current_kernel++;

   // consume aFeeder
   halide_buffer_t b37;
   struct halide_buffer_t *_704 = &b37;
   int32_t _705 = _240 >> 2;
   int32_t _706 = _237 + _240;
   int32_t _707 = _706 + 3;
   int32_t _708 = _707 >> 2;
   int32_t _709 = _705 * 16;
   struct halide_dimension_t s7[6] = {
    {0, 2, 1, 0},
    {0, 2, 2, 0},
    {0, 2, 4, 0},
    {0, 2, 8, 0},
    {0, _705, 16, 0},
    {0, _708, _709, 0},
   };
   struct halide_dimension_t *_710 = s7;
   uint64_t _711 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
   void *_712 = (void *)(_711);
   struct halide_device_interface_t *_713 = (struct halide_device_interface_t *)(_711);
   struct halide_dimension_t s8[6] = {
    {0, 2, 1, 0},
    {0, 2, 2, 0},
    {0, 2, 4, 0},
    {0, 2, 8, 0},
    {0, _705, 16, 0},
    {0, _708, _709, 0},
   };
   struct halide_dimension_t *_714 = s8;
   struct halide_buffer_t *_715 = _halide_buffer_init(_704, _710, _712, _711, _713, 2, 32, 6, _714, _711);
   struct halide_buffer_t * _xSerializer_buffer = _715;
   struct halide_device_interface_t const *_716 = halide_opencl_device_interface();
   int32_t _717 = halide_device_and_host_malloc(_ucon, _xSerializer_buffer, _716);
   bool _718 = _717 == 0;
   if (!_718)    {
    return _717;
   }
   struct s9 { void * const ucon; void * const arg; s9(void *ucon, void *a) : ucon(ucon), arg((void *)a) {} ~s9() { halide_device_and_host_free_as_destructor(ucon, arg); } } d1(_ucon, _xSerializer_buffer);
   void *_719 = 0;
   (void)_719;
   {
    void *_720 = _halide_buffer_get_host(_xSerializer_buffer);
    float *_xSerializer = (float *)(_720);
    if (!_xSerializer)
    {
     return halide_error_out_of_memory(_ucon);
    }
    HalideFreeHelper _xSerializer_free(_ucon, _xSerializer, halide_device_host_nop_free);
    // produce xSerializer
    int32_t _721 = halide_copy_to_host(_ucon, _X_buffer);
    bool _722 = _721 == 0;
    if (!_722)     {
     return _721;
    }
    int32_t _723 = _237 + _240;
    int32_t _724 = _723 + 3;
    int32_t _725 = _724 >> 2;
    for (int _xSerializer_s0_i = 0; _xSerializer_s0_i < 0 + _725; _xSerializer_s0_i++)
    {
     int32_t _726 = _240 >> 2;
     for (int _xSerializer_s0_k = 0; _xSerializer_s0_k < 0 + _726; _xSerializer_s0_k++)
     {
      for (int _xSerializer_s0_kk_ii_iii_kkk = 0; _xSerializer_s0_kk_ii_iii_kkk < 0 + 16; _xSerializer_s0_kk_ii_iii_kkk++)
      {
       int32_t _727 = _xSerializer_s0_kk_ii_iii_kkk & 1;
       bool _728 = _727 == 0;
       int32_t _729 = _xSerializer_s0_kk_ii_iii_kkk & 3;
       int32_t _730 = _729 >> 1;
       bool _731 = _730 == 0;
       bool _732 = _728 || _731;
       if (_732)
       {
        int32_t _733 = _xSerializer_s0_i * 4;
        int32_t _734 = _xSerializer_s0_kk_ii_iii_kkk & 3;
        int32_t _735 = _734 >> 1;
        int32_t _736 = _xSerializer_s0_kk_ii_iii_kkk & 7;
        int32_t _737 = _736 >> 2;
        int32_t _738 = _737 * 2;
        int32_t _739 = _735 + _738;
        int32_t _740 = _733 + _739;
        int32_t _741 = _xSerializer_s0_k * 4;
        int32_t _742 = _xSerializer_s0_kk_ii_iii_kkk >> 3;
        int32_t _743 = _742 * 2;
        int32_t _744 = _xSerializer_s0_kk_ii_iii_kkk & 1;
        int32_t _745 = _743 + _744;
        int32_t _746 = _741 + _745;
        int32_t _747 = _740 - _746;
        int32_t _748 = _747 - _245;
        float _749 = ((const float *)_X)[_748];
        int32_t _750 = _240 >> 2;
        int32_t _751 = _750 * _xSerializer_s0_i;
        int32_t _752 = _751 * 16;
        int32_t _753 = _xSerializer_s0_k * 16;
        int32_t _754 = _753 + _xSerializer_s0_kk_ii_iii_kkk;
        int32_t _755 = _752 + _754;
        _xSerializer[_755] = _749;
       } // if _732
      } // for _xSerializer_s0_kk_ii_iii_kkk
     } // for _xSerializer_s0_k
    } // for _xSerializer_s0_i
    bool _756 = (bool)(ADD_UINT64_T_SUFFIX(1));
    int32_t _757 = _halide_buffer_set_host_dirty(_xSerializer_buffer, _756);
    (void)_757;
    // consume xSerializer
    // produce xLoader
    struct halide_device_interface_t const *_758 = halide_opencl_device_interface();
    int32_t _759 = halide_copy_to_device(_ucon, _xSerializer_buffer, _758);
    bool _760 = _759 == 0;
    if (!_760)     {
     return _759;
    }
    status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
    CHECK(status);
    status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
    CHECK(status);
    status = clSetKernelArg(kernel[current_kernel], 2, sizeof(cl_mem), (void *)&((device_handle *)_halide_buffer_get_device(_xSerializer_buffer))->mem);
    CHECK(status);
    current_kernel++;

    // consume xLoader
    // produce xFeeder
    status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
    CHECK(status);
    status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
    CHECK(status);
    current_kernel++;

    // consume xFeeder
    // produce V
    status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
    CHECK(status);
    status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
    CHECK(status);
    current_kernel++;

    // consume V
    // consume uZ
    // consume uX
    // consume uA
    halide_buffer_t b38;
    struct halide_buffer_t *_761 = &b38;
    int32_t _762 = _237 + _240;
    int32_t _763 = _762 + 3;
    int32_t _764 = _763 >> 2;
    struct halide_dimension_t s10[3] = {
     {0, 2, 1, 0},
     {0, 2, 2, 0},
     {0, _764, 4, 0},
    };
    struct halide_dimension_t *_765 = s10;
    uint64_t _766 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
    void *_767 = (void *)(_766);
    struct halide_device_interface_t *_768 = (struct halide_device_interface_t *)(_766);
    struct halide_dimension_t s11[3] = {
     {0, 2, 1, 0},
     {0, 2, 2, 0},
     {0, _764, 4, 0},
    };
    struct halide_dimension_t *_769 = s11;
    struct halide_buffer_t *_770 = _halide_buffer_init(_761, _765, _767, _766, _768, 2, 32, 3, _769, _766);
    struct halide_buffer_t * _ySerializer_mem_channel_buffer = _770;
    struct halide_device_interface_t const *_771 = halide_opencl_device_interface();
    int32_t _772 = halide_device_and_host_malloc(_ucon, _ySerializer_mem_channel_buffer, _771);
    bool _773 = _772 == 0;
    if (!_773)     {
     return _772;
    }
    struct s12 { void * const ucon; void * const arg; s12(void *ucon, void *a) : ucon(ucon), arg((void *)a) {} ~s12() { halide_device_and_host_free_as_destructor(ucon, arg); } } d2(_ucon, _ySerializer_mem_channel_buffer);
    void *_774 = 0;
    (void)_774;
    {
     void *_775 = _halide_buffer_get_host(_ySerializer_mem_channel_buffer);
     float *_ySerializer_mem_channel = (float *)(_775);
     if (!_ySerializer_mem_channel)
     {
      return halide_error_out_of_memory(_ucon);
     }
     HalideFreeHelper _ySerializer_mem_channel_free(_ucon, _ySerializer_mem_channel, halide_device_host_nop_free);
     // produce ySerializer
     {
      int32_t _addr_temp;
      _addr_temp = 0;
      int32_t _776 = halide_copy_to_host(_ucon, _Y_buffer);
      bool _777 = _776 == 0;
      if (!_777)       {
       return _776;
      }
      int32_t _778 = _237 + _240;
      int32_t _779 = _778 + 3;
      int32_t _780 = _779 >> 2;
      for (int _ySerializer_s0_i = 0; _ySerializer_s0_i < 0 + _780; _ySerializer_s0_i++)
      {
       for (int _ySerializer_s0_ii_iii = 0; _ySerializer_s0_ii_iii < 0 + 4; _ySerializer_s0_ii_iii++)
       {
        int32_t _781 = _ySerializer_s0_i * 4;
        int32_t _782 = _781 + _ySerializer_s0_ii_iii;
        int32_t _783 = _782 - _251;
        float _784 = ((const float *)_Y)[_783];
        int32_t _785 = _addr_temp;
        _ySerializer_mem_channel[_785] = _784;
        int32_t _786 = _addr_temp;
        int32_t _787 = _786 + 1;
        _addr_temp = _787;
       } // for _ySerializer_s0_ii_iii
      } // for _ySerializer_s0_i
      bool _788 = (bool)(ADD_UINT64_T_SUFFIX(1));
      int32_t _789 = _halide_buffer_set_host_dirty(_ySerializer_mem_channel_buffer, _788);
      (void)_789;
     } // alloc _addr_temp
     // consume ySerializer
     // produce yLoader
     struct halide_device_interface_t const *_790 = halide_opencl_device_interface();
     int32_t _791 = halide_copy_to_device(_ucon, _ySerializer_mem_channel_buffer, _790);
     bool _792 = _791 == 0;
     if (!_792)      {
      return _791;
     }
     status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 2, sizeof(cl_mem), (void *)&((device_handle *)_halide_buffer_get_device(_ySerializer_mem_channel_buffer))->mem);
     CHECK(status);
     current_kernel++;

     // consume yLoader
     // produce yFeeder
     status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
     CHECK(status);
     current_kernel++;

     // consume yFeeder
     // produce Out
     status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 2, sizeof(float), (void *)&_Alpha);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 3, sizeof(float), (void *)&_Beta);
     CHECK(status);
     current_kernel++;

     // consume Out
     // produce drainer
     status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
     CHECK(status);
     current_kernel++;

     // consume drainer
     // produce collector
     status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
     CHECK(status);
     status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
     CHECK(status);
     current_kernel++;

     // consume collector
     halide_buffer_t b39;
     struct halide_buffer_t *_793 = &b39;
     int32_t _794 = _237 + _240;
     int32_t _795 = _794 + 3;
     int32_t _796 = _795 >> 2;
     struct halide_dimension_t s13[3] = {
      {0, 2, 1, 0},
      {0, 2, 2, 0},
      {0, _796, 4, 0},
     };
     struct halide_dimension_t *_797 = s13;
     uint64_t _798 = (uint64_t)(ADD_UINT64_T_SUFFIX(0));
     void *_799 = (void *)(_798);
     struct halide_device_interface_t *_800 = (struct halide_device_interface_t *)(_798);
     struct halide_dimension_t s14[3] = {
      {0, 2, 1, 0},
      {0, 2, 2, 0},
      {0, _796, 4, 0},
     };
     struct halide_dimension_t *_801 = s14;
     struct halide_buffer_t *_802 = _halide_buffer_init(_793, _797, _799, _798, _800, 2, 32, 3, _801, _798);
     struct halide_buffer_t * _unloader_mem_channel_buffer = _802;
     struct halide_device_interface_t const *_803 = halide_opencl_device_interface();
     int32_t _804 = halide_device_and_host_malloc(_ucon, _unloader_mem_channel_buffer, _803);
     bool _805 = _804 == 0;
     if (!_805)      {
      return _804;
     }
     struct s15 { void * const ucon; void * const arg; s15(void *ucon, void *a) : ucon(ucon), arg((void *)a) {} ~s15() { halide_device_and_host_free_as_destructor(ucon, arg); } } d3(_ucon, _unloader_mem_channel_buffer);
     void *_806 = 0;
     (void)_806;
     {
      void *_807 = _halide_buffer_get_host(_unloader_mem_channel_buffer);
      float *_unloader_mem_channel = (float *)(_807);
      if (!_unloader_mem_channel)
      {
       return halide_error_out_of_memory(_ucon);
      }
      HalideFreeHelper _unloader_mem_channel_free(_ucon, _unloader_mem_channel, halide_device_host_nop_free);
      // produce unloader
      struct halide_device_interface_t const *_808 = halide_opencl_device_interface();
      int32_t _809 = halide_device_malloc(_ucon, _unloader_mem_channel_buffer, _808);
      bool _810 = _809 == 0;
      if (!_810)       {
       return _809;
      }
      status = clSetKernelArg(kernel[current_kernel], 0, sizeof(int32_t), (void *)&_237);
      CHECK(status);
      status = clSetKernelArg(kernel[current_kernel], 1, sizeof(int32_t), (void *)&_240);
      CHECK(status);
      status = clSetKernelArg(kernel[current_kernel], 2, sizeof(cl_mem), (void *)&((device_handle *)_halide_buffer_get_device(_unloader_mem_channel_buffer))->mem);
      CHECK(status);
      current_kernel++;

      int32_t _811 = halide_opencl_wait_for_kernels_finish(_ucon);
      bool _812 = _811 == 0;
      if (!_812)       {
       return _811;
      }
      bool _813 = (bool)(ADD_UINT64_T_SUFFIX(1));
      int32_t _814 = _halide_buffer_set_device_dirty(_unloader_mem_channel_buffer, _813);
      (void)_814;
      // consume unloader
      // produce deserializer
      {
       int32_t _addr_temp;
       _addr_temp = 0;
       int32_t _815 = halide_copy_to_host(_ucon, _unloader_mem_channel_buffer);
       bool _816 = _815 == 0;
       if (!_816)        {
        return _815;
       }
       int32_t _817 = halide_copy_to_host(_ucon, _deserializer_buffer);
       bool _818 = _817 == 0;
       if (!_818)        {
        return _817;
       }
       int32_t _819 = _237 + _240;
       int32_t _820 = _819 + 3;
       int32_t _821 = _820 >> 2;
       for (int _deserializer_s0_i = 0; _deserializer_s0_i < 0 + _821; _deserializer_s0_i++)
       {
        for (int _deserializer_s0_ii_iii = 0; _deserializer_s0_ii_iii < 0 + 4; _deserializer_s0_ii_iii++)
        {
         int32_t _822 = _addr_temp;
         float _823 = _unloader_mem_channel[_822];
         int32_t _824 = _deserializer_s0_i * _265;
         int32_t _825 = _deserializer_s0_ii_iii >> 1;
         int32_t _826 = _825 * _262;
         int32_t _827 = _deserializer_s0_ii_iii & 1;
         int32_t _828 = _826 + _827;
         int32_t _829 = _824 + _828;
         int32_t _830 = _263 * _265;
         int32_t _831 = _260 * _262;
         int32_t _832 = _831 + _257;
         int32_t _833 = _830 + _832;
         int32_t _834 = _829 - _833;
         ((float *)_deserializer)[_834] = _823;
         int32_t _835 = _addr_temp;
         int32_t _836 = _835 + 1;
         _addr_temp = _836;
        } // for _deserializer_s0_ii_iii
       } // for _deserializer_s0_i
       bool _837 = (bool)(ADD_UINT64_T_SUFFIX(1));
       int32_t _838 = _halide_buffer_set_host_dirty(_deserializer_buffer, _837);
       (void)_838;
       int32_t _839 = halide_device_and_host_free(_ucon, _unloader_mem_channel_buffer);
       bool _840 = _839 == 0;
       if (!_840)        {
        return _839;
       }
      } // alloc _addr_temp
      _unloader_mem_channel_free.free();
     } // alloc _unloader_mem_channel
     _ySerializer_mem_channel_free.free();
    } // alloc _ySerializer_mem_channel
    _xSerializer_free.free();
   } // alloc _xSerializer
   _aSerializer_free.free();
  } // alloc _aSerializer
 } // if _304
 return 0;
}

#ifdef __cplusplus
}  // extern "C"
#endif

