CLASS zcl_curr_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS convert_amount
      IMPORTING iv_amount           TYPE yamount
                iv_from_curr        TYPE ycurr
                iv_to_curr          TYPE ycurr
                iv_date             TYPE d
      RETURNING VALUE(rv_converted) TYPE yamount.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_curr_conv IMPLEMENTATION.
  METHOD convert_amount.
    SELECT rate
FROM zcurre_rates
WHERE from_curr  = @iv_from_curr
AND to_curr    = @iv_to_curr
AND valid_from <= @iv_date
ORDER BY valid_from DESCENDING
INTO @DATA(conv_rate).
    ENDSELECT.

    rv_converted = iv_amount * conv_rate.

  ENDMETHOD.
ENDCLASS.
